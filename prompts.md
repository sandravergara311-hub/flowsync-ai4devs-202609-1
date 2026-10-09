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

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Auto
**Herramienta:** Cursor

```
Lee el requisito 'Lo que cada tarea muestra de su responsable' en openspec/specs/tasks/spec.md y revisa los tests funcionales en backend/tests/functional/tasks/. Genera la tabla de trazabilidad mapeando cada scenario contra su test correspondiente.
```

**Qué salió:** Funcionó a la primera pero no encontró los test en la carpeta que le dije.

---

## Prompt 2

**Modelo:** Auto
**Herramienta:** Cursor

```
Lee el requisito 'Lo que cada tarea muestra de su responsable' en openspec/specs/tasks/spec.md y revisa los tests funcionales en backend/tests/functional/. Genera la tabla de trazabilidad mapeando cada scenario contra su test correspondiente.
```

**Qué salió:** Funcionó a la primera pero no encontró los test en la carpeta que le dije.

---

## Prompt 3

**Modelo:** Auto
**Herramienta:** Cursor

```
Genera los 3 tests funcionales que faltan para el requisito 'Lo que cada tarea muestra de su responsable' en backend/tests/functional/tasks/. Involucra los escenarios: Responsable identificable, La tarea no filtra datos de cuenta, y Responsable sin nombre. Sigue la misma estructura y estilo de los tests de backend/tests/functional/auth/.
```

**Qué salió:** Se demoró unos 5 minutos pero ejecutó los tres tests y pasaron.


