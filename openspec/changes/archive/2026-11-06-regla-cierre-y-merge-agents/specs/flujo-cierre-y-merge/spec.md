# Spec Delta

## Purpose
Establecer el protocolo estandarizado para los agentes de IA al concluir un cambio OpenSpec, requiriendo la evaluación de buenas prácticas y la consulta al usuario para la integración en `main`, el cierre de issues relacionados y la limpieza de ramas temporales.

## ADDED Requirements

### Requirement: Consulta de integración y cierre de tareas
Tras completar el archivado de un cambio con `opsx-archive`, el agente SHALL evaluar si las modificaciones respetan las buenas prácticas del proyecto y SHALL consultar al autor si desea integrar el trabajo en `main`, cerrar el issue vinculado y eliminar la rama temporal.

#### Scenario: Finalización con issue y rama dedicada activa
- **WHEN** el agente concluye la fase `opsx-archive` y verifica que el árbol de trabajo está limpio y cumple las convenciones técnicas
- **THEN** el agente MUST informar al usuario de la conformidad con las buenas prácticas y proponer explícitamente:
  - Localizar y cerrar el issue de GitHub relacionado en caso de existir.
  - Fusionar la rama de trabajo dedicada en `main` y realizar push al repositorio remoto.
  - Eliminar la rama temporal tanto en local como en el repositorio remoto tras la confirmación del usuario.

#### Scenario: Detección de desviaciones de buenas prácticas
- **WHEN** el agente detecta durante la evaluación previa que existen requisitos pendientes de validación, modificaciones no autorizadas o advertencias de coherencia
- **THEN** el agente SHALL advertir al usuario de las discrepancias antes de proponer la fusión en `main`.
