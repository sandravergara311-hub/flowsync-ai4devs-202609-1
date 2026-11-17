# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Saltó la regla correo al intentar versionar el ejemplo del README de tasks; el registro dejó `2026-11-17T17:39:49Z BLOQUEADO correo docs/capabilities/tasks/README.md`.

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- La contraseña de prueba que ya está escrita en los tests y en el README de tasks, si se añade otra vez en un archivo de texto: no tiene forma de clave de proveedor, no es un correo y el archivo no se llama `.env`, así que ninguna de las tres reglas la ve.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- El hook corre antes de que el comando se ejecute, así que un add y un commit en la misma línea todavía no han preparado el índice, y un `.env` ignorado solo aparece si ese add lo fuerza; además, sin `jq` en el PATH el script sale con código 2 y corta cualquier commit.
