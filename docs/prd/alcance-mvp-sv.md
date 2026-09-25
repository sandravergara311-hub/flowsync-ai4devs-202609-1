# FlowSync — Alcance del MVP

## 1. Terreno Existente
- **Capabilities construidas:** Autenticación completa end-to-end (signup, login con access tokens Bearer, perfil autenticado y logout). Backend en AdonisJS (`/api/v1/auth/*` y `/api/v1/account/*`); frontend con vistas de login, registro, perfil protegido y cliente API. No existen capacidades relativas a tareas ni equipos.
- **Modelo de datos actual:** Entidad `User` (`id`, `full_name`, `email`, `password`, `timestamps`) y la tabla técnica `auth_access_tokens`.

## 2. Problema

En los equipos remotos pequeños, saber en qué está trabajando cada persona obliga a preguntar. Pasa de dos formas:
- **La daily de sincronización se alarga** porque cada uno cuenta en voz alta lo que ya podría estar visible.
- **El "¿en qué estás?" aparece constantemente** por chat y corta el trabajo de quien pregunta y de quien responde.

La información existe, pero solo está en la cabeza de cada uno. Las herramientas tipo Jira piden tanto esfuerzo (sprints, estimaciones, campos, flujos) que el equipo deja de actualizarlas, y acaba preguntando otra vez.

## 3. Usuarios

- **Un único equipo remoto de 3 a 10 personas.**
- **Roles planos:** todos los miembros tienen los mismos permisos. No hay administrador, ni lead con privilegios.
- Cada miembro hace dos cosas: **publica** el estado de sus tareas y **consulta** el de los demás.

## 4. Propuesta de valor

> Abres FlowSync y ves en qué está cada uno, al día y sin preguntar. Actualizar tu tarea cuesta 2 clics.

**Hipótesis que el MVP debe validar:**
> Si el estado de las tareas del equipo está siempre visible y al día, y actualizarlo cuesta 2 clics, el equipo deja de necesitar la daily de sincronización y de preguntar "¿en qué estás?".

## 5. Alcance (Tras Recorte Humano)

1. **Cuenta:** registro, inicio de sesión y cierre de sesión. Todo usuario que se registra pasa a formar parte del único equipo.
2. **Tarea ultra-simple (solo 3 campos):**
   - **Título:** obligatorio.
   - **Responsable:** obligatorio (un solo miembro del equipo).
   - **Estado:** uno de los 3 estados fijos.
3. **3 estados fijos:** Pendiente, En curso y Hecha (no configurables).
4. **Cambio de estado en 2 clics o menos** desde la vista principal.
5. **Una sola vista (Tablero Kanban):** 3 columnas (Pendiente, En curso, Hecha). Cada tarjeta muestra solo título y responsable.
6. **Tablero en tiempo real:** sincronización sin recargar la página cuando alguien mueve o crea una tarea.

## 6. No-Alcance Explícito

*(Mantiene todas las exclusiones planteadas por la IA + las agregadas en el recorte manual)*
- **Fecha de vencimiento:** [Recorte Humano] Se elimina para no añadir selectors de fecha ni campos opcionales; en el MVP importa qué se hace HOY.
- **Edición avanzada y borrado de tareas:** [Recorte Humano] En el MVP solo se permite crear y cambiar de estado para no inflar la interfaz.
- **Notificaciones push y Slack:** No se incluyen para evitar ruido y obligar a probar si la visibilidad del tablero por sí sola elimina las preguntas por chat.
- **Comentarios, adjuntos, prioridades, roles y analíticas:** Excluidos explícitamente para mantener el coste de actualización bajo y no parecerse a Jira.

---

## Parte B: Reflexión y Recorte Real

1. **Los dos números:**
   - Funcionalidades propuestas por la IA: 7
   - Funcionalidades mantenidas tras mi recorte humano: 5

2. **Tres cosas dejadas fuera y su porqué:**
   - **Fecha de vencimiento:** La IA la incluyó como campo opcional, pero la eliminé porque agrega fricción al crear la tarea. Para validar la hipótesis de la daily solo importa saber qué se hace en el momento.
   - **Edición de títulos y borrado:** Dejé solo la creación y el movimiento entre columnas. Menos botones equivalen a un flujo más rápido y menos código para la primera prueba.
   - **Integración con Slack:** Es tentador llevar notificaciones al chat, pero la hipótesis evalúa si consultar el tablero sustituye la costumbre de preguntar por chat.

3. **La exclusión de la que menos segura estoy:**
   - **Fecha de vencimiento:** Me generó duda quitarla por si el equipo no sabe qué tareas son urgentes, pero decidir mantener el formulario en su expresión mínima (título + responsable) prevaleció para no inflar el alcance del MVP.