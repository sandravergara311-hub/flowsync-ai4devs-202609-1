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
**Herramienta:** Cursor Chat — Claude Opus 5

```
Explora el proyecto FlowSync y devuélveme un resumen breve (3 a 5 líneas) de las capabilities que YA están construidas en la base de código y cuál es el modelo de datos actual. No asumas nada, léelo del código.
```

**Qué salió:** 
Capabilities ya construidas: auth completo end-to-end — signup, login con access tokens Bearer, perfil autenticado y logout. Backend AdonisJS (/api/v1/auth/* y /api/v1/account/*); frontend con login, registro, perfil protegido, token en localStorage y cliente API con errores traducidos. No hay tareas, equipos ni dominio de producto más allá de la cuenta.

Modelo de datos: solo users (id, full_name, email único, password, timestamps) y auth_access_tokens (tokens opacos ligados al user). Un único modelo Lucid: User.

---

## Prompt 2

**Modelo:** Auto
**Herramienta:** Cursor Chat — Claude Opus 5

```
Quiero que FlowSync sea una herramienta para que los equipos remotos sepan en qué está trabajando cada uno sin tener que hacer reuniones de sincronización. Algo tipo tareas compartidas pero más en tiempo real y menos rollo que Jira. Hazme las 5 preguntas más importantes para reducir la incertidumbre sobre el problema, los usuarios y el alcance. No bajes a detalles de tablas ni endpoints. Espera mis respuestas. Al terminar, registra este prompt y tu respuesta en prompts.md.
```

**Qué salió:**
Cinco preguntas, sin respuestas todavía:

1. **Problema concreto:** hoy, sin FlowSync, ¿qué se rompe? (trabajo duplicado, bloqueos que nadie ve, managers que preguntan "¿cómo vas?", daily que se alarga…). ¿Cuál duele más?
2. **Usuario principal:** ¿quién la usa a diario y quién la consulta? ¿El miembro del equipo que publica su estado, el lead que quiere visibilidad, o ambos por igual? ¿Tamaño típico de equipo?
3. **Unidad de información:** ¿lo que se comparte es una *tarea* (con ciclo de vida: pendiente → en curso → hecha) o un *estado/actividad* ("ahora estoy con X", tipo status de Slack)? ¿O ambos?
4. **"Tiempo real" y "menos rollo":** ¿qué significa en la práctica? ¿Ver cambios al instante sin recargar, notificaciones, o simplemente que actualizar tu estado cueste 5 segundos? ¿Qué de Jira hay que evitar explícitamente?
5. **Alcance del MVP:** ¿un solo equipo o varios equipos/workspaces con invitaciones? ¿Qué queda fuera seguro (integraciones con Slack/GitHub, comentarios, fechas límite, historial)? ¿Qué es lo mínimo para decir "funciona"?

---

## Prompt 3

**Modelo:** Auto
**Herramienta:** Cursor Chat — Claude Opus 5

```
Aquí tienes la información de producto para responder a tus preguntas:

Dolor actual: Daily de sincronización interminable y el '¿en qué estás?' constante.

Usuario: Equipos remotos pequeños (3-10 personas) con roles planos.

Tiempo real: Ver los cambios de estado de las tareas sin refrescar ni preguntar (frescura de la tarea, NO presencia del usuario, NO chat, NO notificaciones push).

Fuente de datos: Lo teclea el usuario en 2 clics. Sin integraciones externas (Git, Slack, etc.).

Menos rollo que Jira: Título, responsable, estado y fecha de vencimiento. Sin sprints, estimaciones ni métricas.

No-Alcance explícito: Notificaciones push, integración con Slack, roles/permisos, analítica, comentarios en tareas, múltiples equipos.

Con esta información, propón un alcance borrador para el MVP estructurado en 5 bloques: Problema, Usuarios, Propuesta de Valor, Alcance y No-Alcance. Sé muy agresivo recortando. Al terminar, registra este prompt y tu respuesta en prompts.md.
```

**Qué salió:**
Borrador de alcance del MVP:

- **Problema:** los equipos remotos pequeños gastan la daily y el chat en preguntarse "¿en qué estás?". Esa información existe, pero solo en la cabeza de cada uno.
- **Usuarios:** un único equipo remoto de 3 a 10 personas, todas con los mismos permisos. Sin roles, sin admin y sin invitados externos.
- **Propuesta de valor:** abres FlowSync y ves en qué está cada uno, al día y sin preguntar. Actualizar tu tarea cuesta 2 clics.
- **Alcance:**
  1. Cuenta: registro, login y logout (ya existe). Todo usuario registrado pertenece al único equipo.
  2. Tarea con 4 campos: título (obligatorio), responsable (obligatorio, un miembro del equipo), estado y fecha de vencimiento (opcional).
  3. 3 estados fijos: Pendiente, En curso y Hecha. No son configurables.
  4. Crear, editar y borrar tareas. Cualquier miembro puede hacerlo con cualquier tarea.
  5. Cambiar de estado en ≤ 2 clics desde la vista principal.
  6. Una única vista: el tablero del equipo en 3 columnas por estado, con el responsable y el vencimiento visibles en cada tarjeta.
  7. Tiempo real: los cambios de otros aparecen en segundos sin recargar la página.
- **No-Alcance:**
  - Lo que marcaste: notificaciones push, Slack, roles y permisos, analítica, comentarios, múltiples equipos.
  - Recortes extra propuestos: invitaciones (cualquiera que se registre entra en el equipo), presencia y chat, estados personalizados, prioridad, etiquetas, descripción, subtareas, adjuntos, historial y auditoría, filtros, búsqueda, varias vistas, alertas por tareas vencidas, varios responsables, integraciones, móvil nativo, recuperar contraseña y editar el perfil.
- **Decisiones a confirmar:** que el equipo sea implícito (sin invitaciones), que no haya descripción y que las tareas Hechas se queden visibles para siempre.

---

## Prompt 4

**Modelo:** Auto
**Herramienta:** Cursor Chat — Claude Opus 5

```
Genera y escribe el contenido definitivo en el archivo docs/prd/alcance-mvp-sv.md estructurado en los 5 bloques (Problema, Usuarios, Propuesta de Valor, Alcance y No-Alcance). Asegúrate de que el documento NO contenga endpoints, ni tablas SQL, ni arquitectura técnica. Prioriza la claridad del No-Alcance y justifica cada exclusión en función de si ayuda o no a validar la hipótesis del MVP. Registra también este prompt en prompts.md.
```

**Qué salió:**
Escrito `docs/prd/alcance-mvp-sv.md` con los 5 bloques y sin contenido técnico:

- **Propuesta de valor:** se formula la hipótesis explícita: "si el estado de las tareas está siempre al día y actualizarlo cuesta 2 clics, el equipo deja de necesitar la daily y el '¿en qué estás?'". Se apoya en dos cosas: frescura y coste mínimo de actualización.
- **Alcance:** 7 puntos (cuenta, tarea con 4 campos, 3 estados fijos, crear/editar/borrar, cambio de estado en ≤ 2 clics, tablero único en 3 columnas, tablero en tiempo real) y un criterio de "funciona".
- **No-Alcance:** una regla de corte general y cada exclusión justificada frente a la hipótesis. Está agrupado en: producto, equipo y permisos, tarea, vistas y análisis, cuenta y plataforma.
- Las 3 decisiones que estaban pendientes se adoptan como definitivas, cada una con su justificación: equipo implícito sin invitaciones, sin descripción y sin archivar las tareas Hechas.


