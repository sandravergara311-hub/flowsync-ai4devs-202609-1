# Spec Viva: Cuentas y Acceso

## Purpose

Permitir que una persona cree su cuenta en FlowSync, inicie y cierre sesión, y acceda a su perfil, de forma que solo quien tiene una sesión válida pueda entrar a las pantallas privadas. Describe el comportamiento actual, tanto de la API como de la interfaz web.

## Requirements

### Requirement: Registro de cuenta

La API SHALL permitir crear una cuenta nueva con un email, una contraseña, la confirmación de esa contraseña y un nombre completo opcional. Al crearla, SHALL devolver los datos públicos del usuario y un token de acceso, de modo que la persona queda autenticada sin tener que iniciar sesión después.

#### Scenario: Registro correcto

- WHEN se envía una petición de registro con un email válido que no está registrado, una contraseña de entre 8 y 32 caracteres y una confirmación idéntica
- THEN la API responde con éxito con los datos públicos del usuario y un token de acceso nuevo, envueltos en un objeto `data`



#### Scenario: Registro sin nombre

- WHEN se envía una petición de registro con el nombre completo a nulo y el resto de datos válidos
- THEN la cuenta se crea sin nombre y la respuesta muestra el nombre como nulo



#### Scenario: Email ya registrado

- WHEN se envía una petición de registro con un email que ya pertenece a otra cuenta
- THEN la API responde con un error de validación 422 que señala el campo email y no crea ninguna cuenta



#### Scenario: Datos con formato inválido

- WHEN se envía una petición de registro con un email mal formado o de más de 254 caracteres, con una contraseña de menos de 8 o más de 32 caracteres, o con una confirmación distinta de la contraseña
- THEN la API responde con un error de validación 422 con una lista de errores; cada uno indica el campo afectado y la regla incumplida, y no se crea ninguna cuenta



#### Scenario: Falta el nombre en la petición

- WHEN se envía una petición de registro sin el campo de nombre completo (ni siquiera a nulo)
- THEN la API responde con un error de validación 422



### Requirement: Inicio de sesión

La API SHALL autenticar a una persona por email y contraseña y, si las credenciales son correctas, SHALL emitir un token de acceso nuevo en cada inicio de sesión.

#### Scenario: Credenciales correctas

- WHEN se envía una petición de inicio de sesión con el email y la contraseña de una cuenta existente
- THEN la API responde con éxito con los datos públicos del usuario y un token de acceso nuevo, envueltos en un objeto `data`



#### Scenario: Credenciales incorrectas

- WHEN se envía una petición de inicio de sesión con un email que no existe o con una contraseña que no corresponde a ese email
- THEN la API responde con un error 400 de credenciales inválidas que no indica cuál de los dos datos es el incorrecto



#### Scenario: Datos incompletos o mal formados

- WHEN se envía una petición de inicio de sesión sin email, con un email mal formado o sin contraseña
- THEN la API responde con un error de validación 422 que señala el campo afectado



#### Scenario: Contraseña fuera del rango de registro

- WHEN se envía una petición de inicio de sesión con una contraseña de menos de 8 o más de 32 caracteres
- THEN la API no aplica el límite de longitud del registro: comprueba las credenciales y, como no coinciden con ninguna cuenta, responde con el error 400 de credenciales inválidas en lugar de un error de validación 422



#### Scenario: Varios inicios de sesión simultáneos

- WHEN una persona inicia sesión varias veces, por ejemplo desde distintos navegadores
- THEN cada inicio de sesión recibe un token distinto y todos siguen siendo válidos a la vez



### Requirement: Acceso autenticado mediante token

La API SHALL aceptar como autenticadas las peticiones a recursos privados que incluyan un token de acceso válido en la cabecera de autorización como token Bearer. Las que no lo incluyan, o incluyan uno inválido o revocado, SHALL rechazarse con un 401. Los tokens SHALL NOT caducar por tiempo: solo dejan de valer cuando se revocan.

#### Scenario: Petición sin token

- WHEN se pide un recurso privado sin cabecera de autorización
- THEN la API responde con un error 401



#### Scenario: Token inválido o revocado

- WHEN se pide un recurso privado con un token que no existe o que ya se revocó al cerrar sesión
- THEN la API responde con un error 401



#### Scenario: Token antiguo sin cerrar sesión

- WHEN se pide un recurso privado con un token emitido hace tiempo que nunca se ha revocado
- THEN la API acepta la petición como autenticada



### Requirement: Consulta del perfil propio

La API SHALL devolver los datos públicos de la persona autenticada.

#### Scenario: Perfil con sesión válida

- WHEN una persona autenticada pide su perfil
- THEN la API responde con sus datos públicos envueltos en un objeto `data`



#### Scenario: Perfil sin sesión

- WHEN se pide el perfil sin un token válido
- THEN la API responde con un error 401



### Requirement: Datos públicos del usuario

Toda respuesta de la API que incluya un usuario SHALL contener solo su identificador, nombre completo, email, iniciales, fecha de alta y fecha de última modificación. SHALL NOT incluir nunca la contraseña, ni en claro ni cifrada.

#### Scenario: Iniciales a partir del nombre

- WHEN el usuario tiene un nombre completo de dos o más palabras, como "Ada Lovelace"
- THEN las iniciales son la primera letra de las dos primeras palabras, en mayúsculas: "AL"



#### Scenario: Iniciales con un nombre de una sola palabra

- WHEN el usuario tiene un nombre completo de una sola palabra, como "Ada"
- THEN las iniciales son las dos primeras letras de esa palabra, en mayúsculas: "AD"



#### Scenario: Iniciales sin nombre

- WHEN el usuario no tiene nombre completo y su email es, por ejemplo, "[ada@ejemplo.com](mailto:ada@ejemplo.com)"
- THEN las iniciales se calculan a partir del email, con la primera letra de la parte anterior a la arroba y la primera de la posterior, en mayúsculas: "AE"



### Requirement: Cierre de sesión en la API

La API SHALL permitir a una persona autenticada revocar el token con el que hace la petición, sin afectar a sus otros tokens.

#### Scenario: Cierre de sesión correcto

- WHEN una persona autenticada pide cerrar sesión
- THEN la API revoca el token usado en esa petición y responde con un mensaje de confirmación; cualquier petición posterior con ese token recibe un error 401



#### Scenario: Otras sesiones siguen activas

- WHEN una persona con varios tokens activos cierra sesión con uno de ellos
- THEN los demás tokens siguen siendo válidos



#### Scenario: Cierre de sesión sin token válido

- WHEN se pide cerrar sesión sin un token válido
- THEN la API responde con un error 401



### Requirement: Respuestas siempre en JSON

La API SHALL responder siempre en formato JSON, también los errores, aunque la petición no lo pida expresamente.

#### Scenario: Petición sin preferencia de formato

- WHEN se envía cualquier petición sin indicar qué formato de respuesta se acepta
- THEN la respuesta llega en JSON



### Requirement: Pantalla de registro

La interfaz SHALL ofrecer una pantalla de registro con los campos nombre completo (marcado como opcional), email, contraseña (con la indicación "Entre 8 y 32 caracteres.") y repetición de la contraseña, más un enlace a la pantalla de inicio de sesión.

#### Scenario: Registro correcto desde la interfaz

- WHEN la persona rellena el formulario con datos válidos y pulsa "Crear cuenta"
- THEN la sesión queda iniciada y la interfaz muestra la pantalla de perfil



#### Scenario: Contraseñas distintas

- WHEN la persona escribe dos contraseñas diferentes y pulsa "Crear cuenta"
- THEN aparece "Las contraseñas no coinciden." bajo el campo de repetición y no se envía nada al servidor



#### Scenario: Nombre en blanco

- WHEN la persona deja el nombre vacío o escribe solo espacios
- THEN la cuenta se crea sin nombre



#### Scenario: Email ya registrado desde la interfaz

- WHEN la persona intenta registrarse con un email que ya existe
- THEN aparece "Ese email ya está registrado. Inicia sesión en su lugar." bajo el campo de email



#### Scenario: Envío en curso

- WHEN la persona pulsa "Crear cuenta" y la petición sigue en marcha
- THEN el botón se desactiva y muestra "Creando cuenta…"



### Requirement: Pantalla de inicio de sesión

La interfaz SHALL ofrecer una pantalla de inicio de sesión con los campos email y contraseña, y un enlace a la pantalla de registro.

#### Scenario: Inicio de sesión correcto desde la interfaz

- WHEN la persona introduce credenciales correctas y pulsa "Entrar"
- THEN la sesión queda iniciada y la interfaz muestra la pantalla de perfil



#### Scenario: Credenciales incorrectas desde la interfaz

- WHEN la persona introduce un email o una contraseña incorrectos y pulsa "Entrar"
- THEN aparece un aviso general con "El email o la contraseña no son correctos."



#### Scenario: Envío en curso

- WHEN la persona pulsa "Entrar" y la petición sigue en marcha
- THEN el botón se desactiva y muestra "Entrando…"



### Requirement: Mensajes de error comprensibles en los formularios

La interfaz SHALL traducir los errores del servidor a mensajes en castellano. Cuando el error afecta a un campo visible, SHALL mostrarlo bajo ese campo. En cualquier otro caso, SHALL mostrarlo en un aviso general sobre el formulario.

#### Scenario: Error de un campo visible

- WHEN el servidor rechaza el formulario por un problema en un campo que está en pantalla, por ejemplo un email mal formado
- THEN el mensaje traducido, como "Introduce una dirección de email válida.", aparece bajo ese campo y no hay aviso general



#### Scenario: Error de un campo no visible

- WHEN el servidor rechaza el formulario por un problema en un campo que no está en pantalla
- THEN el primer error traducido aparece en el aviso general, para que el problema nunca quede sin mostrar



#### Scenario: Servidor inaccesible

- WHEN el servidor no responde al enviar un formulario
- THEN el aviso general muestra "No se pudo conectar con el servidor. Comprueba que el backend está arrancado."



#### Scenario: Error inesperado del servidor

- WHEN el servidor responde con un error que no es de validación, de credenciales ni de autenticación
- THEN el aviso general muestra "Algo ha ido mal en el servidor. Inténtalo de nuevo en un momento."



### Requirement: Sesión persistente en el navegador

La interfaz SHALL conservar la sesión entre recargas y cierres del navegador. Al arrancar, SHALL comprobar con el servidor que la sesión guardada sigue siendo válida antes de darla por buena.

#### Scenario: Recarga con sesión válida

- WHEN la persona recarga la aplicación con una sesión guardada que el servidor sigue aceptando
- THEN se muestra un indicador de carga a pantalla completa mientras se comprueba y, después, la persona sigue autenticada sin volver a introducir sus credenciales



#### Scenario: Sesión rechazada por el servidor

- WHEN la persona abre la aplicación con una sesión guardada que el servidor ya no acepta
- THEN la sesión guardada se descarta y la pantalla de inicio de sesión muestra "Tu sesión ha caducado. Vuelve a iniciar sesión."



#### Scenario: Servidor caído al restaurar la sesión

- WHEN la persona abre la aplicación con una sesión guardada y el servidor no responde o devuelve un error inesperado
- THEN la persona ve la pantalla de inicio de sesión con un aviso que explica el problema; la sesión guardada se conserva, de modo que al recargar con el servidor disponible se restaura sin volver a iniciar sesión



#### Scenario: Aviso de sesión perdida frente a un nuevo intento

- WHEN la pantalla de inicio de sesión muestra el aviso de una sesión perdida y la persona hace un nuevo intento que falla
- THEN el aviso general muestra el error del nuevo intento en lugar del de la sesión perdida



### Requirement: Protección de pantallas según la sesión

La interfaz SHALL mostrar la pantalla de perfil solo a quien tiene sesión, y las pantallas de inicio de sesión y registro solo a quien no la tiene.

#### Scenario: Perfil sin sesión

- WHEN una persona sin sesión intenta abrir la pantalla de perfil
- THEN la interfaz la lleva a la pantalla de inicio de sesión



#### Scenario: Inicio de sesión o registro con sesión activa

- WHEN una persona con sesión activa intenta abrir la pantalla de inicio de sesión o la de registro
- THEN la interfaz la lleva a la pantalla de perfil



#### Scenario: Dirección desconocida

- WHEN se abre una dirección de la aplicación que no corresponde a ninguna pantalla
- THEN la interfaz lleva a la pantalla de perfil, que a su vez lleva a la de inicio de sesión si no hay sesión



#### Scenario: Comprobación de la sesión en curso

- WHEN se abre cualquier pantalla protegida o pública mientras se está comprobando la sesión guardada
- THEN la interfaz muestra un indicador de carga y no redirige hasta conocer el resultado



### Requirement: Pantalla de perfil

La interfaz SHALL mostrar a la persona autenticada sus iniciales, su nombre completo, su email y su fecha de alta, junto con la opción de cerrar sesión.

#### Scenario: Perfil con nombre

- WHEN una persona con nombre completo abre su perfil
- THEN ve sus iniciales en un círculo, su nombre, su email y "Miembro desde" con la fecha de alta en formato largo en castellano, por ejemplo "4 de octubre de 2026"



#### Scenario: Perfil sin nombre

- WHEN una persona sin nombre completo abre su perfil
- THEN en lugar del nombre ve "Sin nombre"



### Requirement: Cierre de sesión desde la interfaz

La interfaz SHALL cerrar la sesión local en cuanto la persona lo pida, aunque el servidor no confirme la revocación del token.

#### Scenario: Cerrar sesión

- WHEN la persona pulsa "Cerrar sesión" en su perfil
- THEN la sesión guardada en el navegador se elimina y la interfaz muestra la pantalla de inicio de sesión sin ningún aviso de error, y se pide al servidor que revoque el token



#### Scenario: Cerrar sesión con el servidor caído

- WHEN la persona pulsa "Cerrar sesión" y el servidor no responde
- THEN la sesión local se cierra igualmente y la interfaz muestra la pantalla de inicio de sesión sin mostrar ningún error

---



## Parte B: Auditoría y Métricas



### 1. Conteo de Requisitos

- **Requisitos escritos por el agente:** 15
- **Requisitos comprobados manualmente en el código:** 3



### 2. Incoherencias Detectadas

- **Diferencia de validación en contraseñas:** El registro valida y exige contraseñas de entre 8 y 32 caracteres (devuelve 422 si no se cumple), pero el inicio de sesión no aplica ninguna regla de longitud sobre la contraseña antes de autenticar.



### 3. Ambigüedades / ¿Bug o Contrato?

- **Manejo de contraseña fuera de rango en inicio de sesión:** Al enviar una contraseña de menos de 8 caracteres en el inicio de sesión, la API responde un `400 Bad Request` (credenciales inválidas) en lugar de un `422 Unprocessable Entity` (error de validación). ¿Es esto una decisión deliberada para no revelar la política de contraseñas durante el acceso o un descuido al no reusar el validador del registro? 
- **Uso de HTTP 400 para credenciales erróneas:** La API responde con estado `400` en lugar del estándar `401 Unauthorized` ante un fallo de contraseña en el login.

