Scenarios en el requisito: 3 · Cubiertos: 0

| Scenario | Test que lo cubre | Estado | Qué te faltó (si no lo sabes) |
| :--- | :--- | :--- | :--- |
| Responsable identificable | — | No cubierto | — |
| La tarea no filtra datos de cuenta | — | No cubierto | — |
| Responsable sin nombre | — | No cubierto | — |

## Reflexión (Parte B)

1. **Predicción vs. Realidad:** Creía cubiertos: 2 · Estaban cubiertos: 0
2. **Duda Spec vs. Test:** En el escenario de responsable sin nombre, dudé si la spec requería validar que el campo fuera nulo o si debía retornar un objeto con propiedades vacías, ya que la regla no aclaraba la estructura exacta del JSON devuelto.
3. **Decisión propia al escribir el test:** Al implementar los tests tuve que decidir qué transformer debía estructurar la respuesta en el endpoint de listado, descubriendo que se usaba `TaskAssigneeTransformer` para evitar filtrar campos como el email.