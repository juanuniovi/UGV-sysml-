# Spec Delta

## ADDED Requirements

### Requirement: Descomposición interna de ComputadorAutonomia en tres subsistemas ROS 2 (ROPE-05, ROPE-06, RGEN-17)
El bloque `ComputadorAutonomia` en `Modelos/04_1_control.sysml` SHALL descomponerse internamente en tres partes interconectadas: `subsistemaFusionEstado : SubsistemaFusionEstado`, `subsistemaPlanificacionEvaluacion : SubsistemaPlanificacionEvaluacion` y `supervisorSeguridad : SupervisorSeguridad`, modelando el flujo interno del mapa unificado, la evaluación de colisión y la supervisión por *watchdog* con emisión de `ConsignaFrenado` ante pérdida de comunicación interna.

#### Scenario: Generación del mapa unificado y evaluación de colisión en ComputadorAutonomia
- **WHEN** `ComputadorAutonomia` recibe los datos sensoriales de obstáculos por `entradaObstaculos` y la odometría por `entradaOdometria`
- **THEN** `subsistemaFusionEstado` fusiona ambas entradas en `MapaEstadoUnificado` y lo entrega a `subsistemaPlanificacionEvaluacion`, el cual evalúa si existe riesgo de colisión y emite las consignas de navegación y frenado hacia `salidaConsigna`

#### Scenario: Supervisión de seguridad y frenado ante caída del computador principal
- **WHEN** `supervisorSeguridad` detecta la pérdida de comunicación interna (`LatidoSaludAutonomia`) desde `subsistemaPlanificacionEvaluacion`
- **THEN** `supervisorSeguridad` emite `ConsignaFrenado` hacia `salidaConsigna` (conectada con `moduloFrenadoSeguridad`) para detener el UGV de forma segura (`RGEN-17`)
