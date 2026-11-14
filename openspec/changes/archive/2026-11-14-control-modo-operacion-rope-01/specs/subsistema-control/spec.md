# Spec Delta: subsistema-control

## ADDED Requirements

### Requirement: Modo de operación teleoperado e inhibición de consignas de autonomía (ROPE-01)
El subsistema `SistemaControl` SHALL incorporar la parte `controlModoOperacion : ControlModoOperacion` encargada de gestionar los modos de conducción (`TELEOPERADO` y `NAVEGACION`), recibiendo la orden de modo desde las estaciones de control PMP/CPT vía `dataBus` y gobernando la activación/desactivación de las consignas de guiado del computador de autonomía según el requisito contractual `ROPE-01`.

#### Scenario: Transición a Modo Teleoperado con desactivación de consignas de autonomía
- **WHEN** `controlModoOperacion` recibe a través de `dataBus` la consigna de conmutación al modo `TELEOPERADO`
- **THEN** desactiva la emisión de consignas de guiado en `subsistemaPlanificacionEvaluacion` para otorgar el mando exclusivo a la teleoperación manual

#### Scenario: Transición a Modo Navegación con activación de consignas de autonomía
- **WHEN** `controlModoOperacion` recibe a través de `dataBus` la orden de modo `NAVEGACION`
- **THEN** activa la generación de consignas de conducción y frenado en `subsistemaPlanificacionEvaluacion` hacia los actuadores

## MODIFIED Requirements

### Requirement: Separación estructural del Subsistema 4.1 de Control (ROPE-05, RGEN-09, RGEN-17)
El modelo SHALL definir en `Modelos/04_1_control.sysml` el paquete `SubsistemaControl` con el bloque principal `SistemaControl` (y la instancia `subsistemaControl : SistemaControl`), integrando las partes tipadas `computadorAutonomia : ComputadorAutonomia`, `controlModoOperacion : ControlModoOperacion` y `moduloFrenadoSeguridad : ModuloFrenadoSeguridad`.

#### Scenario: Composición interna de SistemaControl
- **WHEN** se inspecciona la estructura de `SubsistemaControl::SistemaControl`
- **THEN** contiene los bloques de control y actuación segura (`computadorAutonomia`, `controlModoOperacion` y `moduloFrenadoSeguridad`), sin acoplar directamente los sensores físicos de navegación
