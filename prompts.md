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

**Modelo:** Claude Opus 5.5
**Herramienta:** Cursor

```
Lee todo el código relacionado con Cuentas y Acceso (Backend: rutas de auth, controladores, modelo User, validadores y middlewares; Frontend: vistas de login/registro, gestión de estado de sesión y guards/protección de rutas).

Escribe la Spec Viva del comportamiento actual de esta capacidad en castellano, respetando estrictamente la especificación RFC-2119 y esta estructura:

Un ## Purpose inicial con 1-2 frases.

Sección ## Requirements con varios ### Requirement: (usando SHALL).

Bajo cada requisito, añade uno o varios #### Scenario: con viñetas WHEN y THEN (sin indicar GIVEN, la precondición va en el WHEN).

Reglas estrictas:

Prohibido usar las palabras ADDED, MODIFIED o REMOVED.

Prohibido incluir nombres de clases, archivos, funciones, tablas o rutas de código. Solo describe comportamiento observable desde fuera (peticiones/respuestas API o interfaz de usuario).

Escribe el resultado directamente en el archivo docs/spec-viva/sv.md.
```

**Qué salió:** Me creó y redactó el archivo docs/spec-viva/sv.md en 2 minutos.

## Prompt 2

**Modelo:** Claude Opus 5.5 **Herramienta:** Cursor

```
Dime en que parte del código encuentro este requerimiento 

WHEN se envía una petición de registro con un email válido que no está registrado, una contraseña de entre 8 y 32 caracteres y una confirmación idéntica

THEN la API responde con éxito con los datos públicos del usuario y un token de acceso nuevo, envueltos en un objeto data
```

**Qué salió:** Me mostró los trozos de código donde estan las validaciones.

## Prompt 3

**Modelo:** Claude Opus 5.5 **Herramienta:** Cursor

```
Dime en que parte del código encuentro este escenario

#### Scenario: Iniciales sin nombre

- WHEN el usuario no tiene nombre completo y su email es, por ejemplo, "[ada@ejemplo.com](mailto:ada@ejemplo.com)"
- THEN las iniciales se calculan a partir del email, con la primera letra de la parte anterior a la arroba y la primera de la posterior, en mayúsculas: "AE"
```

**Qué salió:** Me mostró los trozos de código donde estan las validaciones.

## Prompt 4

**Modelo:** Claude Opus 5.5 **Herramienta:** Cursor

```
Dime en que parte del código encuentro este escenario


#### Scenario: Token antiguo sin cerrar sesión

- WHEN se pide un recurso privado con un token emitido hace tiempo que nunca se ha revocado
- THEN la API acepta la petición como autenticada
```

**Qué salió:** Me mostró los trozos de código donde estan las validaciones.