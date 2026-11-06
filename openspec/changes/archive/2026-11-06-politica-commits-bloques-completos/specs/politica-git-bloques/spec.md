# Spec Delta

## Purpose
Establecer como estándar transversal del proyecto la política de desarrollo en ramas dedicadas y la entrega por bloques funcionales completos, evitando micro-commits en el historial principal y garantizando la verificación exhaustiva previa a la integración.

## ADDED Requirements

### Requirement: Trabajo exhaustivo en ramas dedicadas
Cualquier modificación, desarrollo de subsistemas o refactorización del proyecto SHALL desarrollarse íntegramente dentro de una rama dedicada. Todo el ciclo de edición, pruebas de compilación y resolución de advertencias de Spec42 MUST ocurrir y quedar resuelto en la rama antes de plantear la integración.

#### Scenario: Depuracion y correccion sintactica
- **WHEN** un agente o colaborador introduce o modifica modelos en SysML v2 y detecta avisos o fallos de sintaxis en Spec42
- **THEN** todas las correcciones MUST ejecutarse y solventarse dentro de la rama dedicada sin realizar entregas parciales a `main`.

### Requirement: Granularidad de commits y bloques funcionales completos
Los commits realizados en el repositorio SHALL agrupar unidades de funcionalidad coherentes, completas y verificables. El agente SHALL NOT generar micro-commits fragmentarios que dividan arbitrariamente un mismo bloque funcional.

#### Scenario: Consolidacion de bloque funcional
- **WHEN** se culmina la implementación de un subsistema o requisito
- **THEN** los cambios MUST consolidarse en un commit estructurado y explicativo que represente el bloque funcional íntegro.

#### Scenario: Prohibicion de micro-commits en main
- **WHEN** se prepara la integración del trabajo hacia la rama principal `main`
- **THEN** el historial resultante en `main` MUST contener únicamente la entrega consolidada del bloque terminado, evitando commits aislados de ajustes menores o correcciones inmediatas.

### Requirement: Criterio de fusion previa verificacion
La integración de una rama dedicada en `main` SHALL autorizarse únicamente cuando el bloque de trabajo esté completamente terminado, las especificaciones OpenSpec archivadas y el modelo verificado sin errores ni advertencias (`0 errors, 0 warnings` en Spec42).

#### Scenario: Verificacion previa obligatoria
- **WHEN** se solicita o propone fusionar una rama en `main`
- **THEN** el agente MUST comprobar previamente la ausencia de errores y advertencias en el compilador Spec42 antes de solicitar o ejecutar el merge.
