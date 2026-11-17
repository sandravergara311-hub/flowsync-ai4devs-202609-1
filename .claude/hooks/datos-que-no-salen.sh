#!/usr/bin/env bash
# Bloquea un git commit si lo que va a entrar lleva un secreto reconocible,
# un correo de persona o un fichero llamado exactamente .env.
set -uo pipefail

export PATH="${HOME}/.local/bin:${PATH}"

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$root"

if ! command -v jq >/dev/null 2>&1; then
  echo "datos-que-no-salen: falta jq; no se puede revisar el commit." >&2
  exit 2
fi

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // .command // empty' 2>/dev/null || true)

if [[ "$cmd" != *'git commit'* ]]; then
  exit 0
fi

incluye_add=0
if [[ "$cmd" == *'git add'* ]]; then
  incluye_add=1
fi

registrar() {
  local file=$1
  local rule=$2
  local registro="${root}/docs/seguridad/registro-de-bloqueos.md"
  local ts

  mkdir -p "$(dirname "$registro")"
  if [[ ! -f "$registro" ]]; then
    printf '%s\n' '# Registro de bloqueos del hook datos-que-no-salen' >"$registro"
  fi

  ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  printf '%s BLOQUEADO %s %s\n' "$ts" "$rule" "$file" >>"$registro"
  printf 'datos-que-no-salen: BLOQUEADO por la regla %s en %s. Sustituye el dato por uno inventado y vuelve a intentar. No desactives el hook.\n' \
    "$rule" "$file" >&2
}

# Las marcas se arman en ejecución. Si el propio script las llevara escritas
# seguidas, el hook se bloquearía a sí mismo al entrar en un commit.
marca_aws=$(printf '%s%s[A-Za-z0-9]{16}' 'AK' 'IA')
marca_ant=$(printf '%s%s' 'sk-' 'ant-')
marca_gh=$(printf '%s%s' 'gh' 'p_')
marca_pat=$(printf '%s%s' 'github_' 'pat_')
marca_ai=$(printf '%s%s[A-Za-z0-9_-]{35}' 'AI' 'za')
marca_slack=$(printf '%s%s-|%s%s-|%s%s-' 'xo' 'xb' 'xo' 'xp' 'xo' 'xa')
marca_pem=$(printf '%s%s[A-Za-z0-9 ]*%s%s' '-----BE' 'GIN ' 'PRIVATE ' 'KEY-----')
marca_clave=$(printf '%s%s' 'APP_' 'KEY=')
re_secreto="${marca_aws}|${marca_ant}|${marca_gh}|${marca_pat}|${marca_ai}|${marca_slack}|${marca_pem}"

linea_tiene_secreto() {
  local line=$1
  local raw val

  if printf '%s\n' "$line" | grep -Eq "$re_secreto"; then
    return 0
  fi

  if printf '%s\n' "$line" | grep -Eq "$marca_clave"; then
    raw=$(printf '%s\n' "$line" | sed -n "s/.*${marca_clave}//p")
    val=$(printf '%s' "$raw" | sed -E 's/^[[:space:]]*//; s/^["'\'']//; s/["'\''][[:space:]]*$//; s/[[:space:]]*$//')
    if [[ -n "$val" ]]; then
      return 0
    fi
  fi

  return 1
}

linea_tiene_correo() {
  local line=$1
  local emails email domain

  emails=$(printf '%s\n' "$line" | grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' || true)
  [[ -z "$emails" ]] && return 1

  while IFS= read -r email; do
    [[ -z "$email" ]] && continue
    domain=${email##*@}
    domain=$(printf '%s' "$domain" | tr '[:upper:]' '[:lower:]')
    case "$domain" in
      example.com | example.org | example.net | github.com) ;;
      *) return 0 ;;
    esac
  done <<<"$emails"

  return 1
}

revisar_linea() {
  local file=$1
  local line=$2

  if linea_tiene_secreto "$line"; then
    registrar "$file" secreto
    return 0
  fi
  if linea_tiene_correo "$line"; then
    registrar "$file" correo
    return 0
  fi
  return 1
}

revisar_diff() {
  local fallback=$1
  local diff=$2
  local line file content

  file=$fallback
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == diff\ --git\ * ]]; then
      file=$(printf '%s\n' "$line" | sed -E 's/^diff --git .* b\///; s/^"//; s/"$//')
      continue
    fi
    [[ "$line" == +++\ * ]] && continue
    [[ "$line" == +* ]] || continue
    content=${line:1}
    if revisar_linea "$file" "$content"; then
      return 0
    fi
  done <<<"$diff"

  return 1
}

revisar_fichero_entero() {
  local file=$1
  local line

  if [[ -s "$file" ]] && ! LC_ALL=C grep -qI . "$file"; then
    return 1
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    if revisar_linea "$file" "$line"; then
      return 0
    fi
  done <"$file"

  return 1
}

revisar_archivo() {
  local file=$1
  local diff

  if [[ $(basename -- "$file") == ".env" ]]; then
    registrar "$file" env
    return 0
  fi

  if [[ -z $(git ls-files -- "$file") ]]; then
    revisar_fichero_entero "$file"
    return
  fi

  diff=$(git diff --cached -U0 --no-color -- "$file" || true)
  if [[ -n "$diff" ]] && revisar_diff "$file" "$diff"; then
    return 0
  fi

  if [[ "$incluye_add" -eq 1 ]]; then
    diff=$(git diff -U0 --no-color -- "$file" || true)
    if [[ -n "$diff" ]] && revisar_diff "$file" "$diff"; then
      return 0
    fi
  fi

  return 1
}

files=$(
  {
    git diff --cached --name-only --diff-filter=ACMR
    if [[ "$incluye_add" -eq 1 ]]; then
      git diff --name-only --diff-filter=ACMR
      git ls-files --others --exclude-standard
      # Un .env ignorado no entra con un add normal. Solo entra si el mismo
      # comando lo fuerza, que es lo que hace falta para versionarlo.
      if [[ "$cmd" == *' -f'* || "$cmd" == *'--force'* ]]; then
        find . -type f -name '.env' \
          -not -path './.git/*' \
          -not -path '*/node_modules/*' \
          -printf '%P\n'
      fi
    fi
  } | awk 'NF && !seen[$0]++'
)

while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  if revisar_archivo "$file"; then
    exit 2
  fi
done <<<"$files"

exit 0
