# Proposal

## Why

Actualmente, `ComputadorAutonomia` en `Modelos/04_1_control.sysml` está modelado como una caja negra sin estructura ni conexiones internas. Dado que la navegación y el control se implementarán sobre **ROS 2** y se desea detallar con rigor la evaluación de riesgo de colisión y la supervisión del frenado automático (`RGEN-17`, `ROPE-05`, `ROPE-06`), es necesario abrir `ComputadorAutonomia` y modelar dentro de él tres subsistemas/partes internas interconectadas: **Subsistema de Fusión y Estado**, **Subsistema de Planificación y Evaluación** y **Supervisor de Seguridad**.

## What Changes

- Actualizar `Modelos/04_1_control.sysml` (`package SubsistemaControl`):
  - Definir los ítems y puertos internos de comunicación ROS 2 dentro de `ComputadorAutonomia`:
    - `item def MapaEstadoUnificado` y `port def PuertoMapaEstadoUnificado` (mapa unificado de percepción + estado/odometría).
    - `item def LatidoSaludAutonomia` y `port def PuertoLatidoSalud` (señal de supervisión de vida/comunicación interna hacia el supervisor de seguridad).
    - `item def ConsignaFrenado` (orden de frenado de emergencia ante colisión o pérdida de comunicación interna).
  - Definir las tres partes internas de `ComputadorAutonomia`:
    - `part def SubsistemaFusionEstado`: recibe la información sensorial de obstáculos (`entradaObstaculos`: LiDAR, Radar y Visión procedentes de Navegación) y la odometría (`entradaOdometria`) para generar el mapa y estado unificado (`salidaMapaUnificado`).
    - `part def SubsistemaPlanificacionEvaluacion`: recibe el mapa unificado (`entradaMapaUnificado`) y las órdenes de misión (`busComunicaciones`), evalúa si existe riesgo de colisión, emite las consignas de navegación/frenado (`salidaConsigna`) y envía el latido de salud/comunicación interna (`salidaSalud`) al supervisor.
    - `part def SupervisorSeguridad`: bloque lógico independiente segregado a nivel de software (watchdog ROS 2) cuya misión es verificar que el computador principal (`subsistemaPlanificacionEvaluacion`) no se ha colgado (`entradaSalud`) y emitir `ConsignaFrenado` hacia `salidaConsigna` si hay pérdida de comunicación interna.
  - Dentro de `part def ComputadorAutonomia`, instanciar las tres partes (`subsistemaFusionEstado`, `subsistemaPlanificacionEvaluacion` y `supervisorSeguridad`) y sus conexiones y enlaces (`binding` y `connection`) para que se visualice todo el flujo interno sin ser una caja negra.
- **Confirmación explícita del usuario (`AGENTS.md`)**:
  - El usuario ha confirmado y autorizado explícitamente ampliar la especificación de `subsistema-control` manteniendo `computadorAutonomia` y creando dentro de él estas tres partes internas y sus conexiones.
- **Fuera de alcance**:
  - No se modifican `04_2_navegacion.sysml`, `05_comunicaciones.sysml`, `09_sistema_ugv.sysml` ni ningún otro subsistema externo a `04_1_control.sysml` (salvo ajustes de exposición en `11_vistas.sysml` si fueran necesarios para visualizar el interior de `computadorAutonomia`).

## Capabilities

### New Capabilities
<!-- Ninguna capacidad nueva. -->

### Modified Capabilities
- `subsistema-control`: Se amplía para especificar la descomposición interna de `ComputadorAutonomia` en `SubsistemaFusionEstado`, `SubsistemaPlanificacionEvaluacion` y `SupervisorSeguridad`, junto con sus puertos e interconexiones internas en ROS 2 (`ROPE-05`, `ROPE-06`, `RGEN-17`).

## Impact

- **Archivos afectados**:
  - `Modelos/04_1_control.sysml` (nuevos ítems/puertos internos, `part def SubsistemaFusionEstado`, `part def SubsistemaPlanificacionEvaluacion`, `part def SupervisorSeguridad`, e instanciación y conexiones internas dentro de `ComputadorAutonomia`).
  - `Modelos/11_vistas.sysml` (verificación de exposición de las partes internas de `computadorAutonomia` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`).
- **Subsistemas afectados**:
  - `SubsistemaControl` (4.1) y `VistasUGV`.
- **Requisitos del pliego relacionados y conflictos**:
  - `RGEN-17`, `ROPE-05`, `ROPE-06`, `RGEN-09`, `RNAV-01`: se refuerza la trazabilidad interna de evaluación de colisión y supervisión por *watchdog* sin conflicto con ningún requisito vigente.
