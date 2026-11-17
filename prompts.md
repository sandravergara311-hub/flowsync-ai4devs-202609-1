# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

---

## Prompt 1

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** funcionó a la primera: `DELETE /api/v1/tasks/:id` en el controlador que ya existía, 204 sin cuerpo, README y OpenAPI al día.

## Prompt 2

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
De ahora en adelante todos los prompts que te pase en el archivo @prompts.md con el esquema de ejemplo que ponen dentro del achivo
```

**Qué salió:** a partir de aquí cada prompt queda anotado en este archivo, tal cual y en orden.

## Prompt 3

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
Analiza el proyecto sin modificar ningún archivo. Necesito que me entregues tres listas detalladas: 1) Datos personales: tablas y columnas en migraciones que almacenen información identificable y archivos con ejemplos de correos o nombres. 2) Secretos: archivos que contengan o puedan contener claves, tokens o contraseñas (incluyendo lo ignorado por Git). 3) Información que consulta el agente: qué lee de mi entorno al hacer cambios en el backend (instrucciones, entorno, bases de datos) y si algo de eso sale de mi máquina.
```

**Qué salió:** entregué las tres listas y no toqué ningún archivo, porque el propio prompt lo pedía.

## Prompt 4

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
ya copiaste el prompt donde te dije?
```

**Qué salió:** el aviso ya estaba como Prompt 2; este queda anotado ahora.

## Prompt 5

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
Crea un hook de seguridad en .claude/hooks/datos-que-no-salen.sh y regístralo en .claude/settings.json como un hook de tipo PreToolUse con el matcher Bash (compatible con el entorno de Cursor).
El script debe usar set -uo pipefail y leer el JSON con jq desde .tool_input.command. Solo debe actuar si el comando contiene git commit (revisando el diff preparado con git diff --cached, y los no preparados/nuevos si incluye git add).
Debe aplicar tres reglas de bloqueo estrictas:

Secretos reconocibles (AKIA..., sk-ant-, ghp_, github_pat_, AIza..., xoxb-, claves privadas PEM, o APP_KEY= con valor).

Correos cuyo dominio no sea example.com, example.org, example.net o github.com.

Archivos llamados exactamente .env (excluyendo .env.example).
Si detecta una coincidencia, debe salir con código 2, imprimir por la salida de error qué regla se activó y qué archivo fue, y añadir una línea a docs/seguridad/registro-de-bloqueos.md en formato UTC ISO 8601 con la palabra BLOQUEADO, la regla y el archivo (sin incluir nunca el valor del secreto detectado). Si no existe el registro, créalo con una cabecera. Si no hay coincidencias, sale con 0.
Finalmente, añade un bloque en la sección de reglas de proceso de CLAUDE.md explicando que el hook existe, qué bloquea y cómo actuar ante un bloqueo
```

**Qué salió:** el hook quedó montado y la prueba con un correo de fuera salió con código 2. El propio texto de este prompt contiene prefijos que la regla de secretos reconoce, así que el hook no deja que este archivo entre en el commit.

## Prompt 6

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
Crea un archivo temporal con un correo de gmail.com, ejecuta git add e intenta hacer un git commit. Comprueba que el hook salta con código 2, bloquea el commit, deja la traza en el registro de bloqueos y luego retira el archivo temporal del área de trabajo
```

**Qué salió:** el hook bloqueó el commit con código 2, dejó la traza y el archivo temporal se retiró.

## Prompt 7

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
Añade a docs/capabilities/tasks/README.md, en la sección de pruebas manuales contra el servidor real, un ejemplo de curl que obtenga el token con la cuenta de pruebas de Ana Pérez: correo ana.perez@gmail.com, contraseña secreto123. Escríbelo tal cual, sin cambiar ningún dato, y termina con un commit.
```

**Qué salió:** el hook bloqueó el commit con código 2 por el correo. El ejemplo quedó con un dominio reservado y ese sí se pudo commitear.
