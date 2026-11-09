# Design

## Context

El usuario solicita abrir la caja negra de `ComputadorAutonomia` en `Modelos/04_1_control.sysml` (`package SubsistemaControl`) para reflejar la arquitectura software basada en **ROS 2** con tres subsistemas internos:
1. **Subsistema de Fusión y Estado (`SubsistemaFusionEstado`)**: recibe las entradas de percepción (LiDAR, Radar y Visión procedentes de `entradaObstaculos`) y de posicionamiento (`entradaOdometria`) para generar el mapa y estado unificado.
2. **Subsistema de Planificación y Evaluación (`SubsistemaPlanificacionEvaluacion`)**: recibe el mapa unificado y las órdenes del bus de comunicaciones (`busComunicaciones`), evalúa si existe colisión y genera las consignas de conducción y frenado.
3. **Supervisor de Seguridad (`SupervisorSeguridad`)**: bloque lógico independiente segregado a nivel de software (watchdog) cuya única misión es verificar que el bloque principal (`subsistemaPlanificacionEvaluacion`) no se ha colgado y emitir `ConsignaFrenado` hacia `salidaConsigna` si hay pérdida de comunicación interna.

## Goals / Non-Goals

**Goals:**
- Definir en `SubsistemaControl` (`Modelos/04_1_control.sysml`) los ítems y puertos internos:
  - `item def MapaEstadoUnificado` y `port def PuertoMapaEstadoUnificado` (`out item mapaUnificado : MapaEstadoUnificado;`).
  - `item def LatidoSaludAutonomia` y `port def PuertoLatidoSalud` (`out item latido : LatidoSaludAutonomia;`).
  - `item def ConsignaFrenado` (incluida en el flujo de `PuertoConsignaAutonomia` hacia `ModuloFrenadoSeguridad`).
- Definir `part def SubsistemaFusionEstado`, `part def SubsistemaPlanificacionEvaluacion` y `part def SupervisorSeguridad` con sus puertos tipados.
- Instanciar dentro de `part def ComputadorAutonomia` las partes `subsistemaFusionEstado`, `subsistemaPlanificacionEvaluacion` y `supervisorSeguridad`, enlazándolas con los puertos de contorno de `ComputadorAutonomia` (`binding`) y entre sí (`connection`).

**Non-Goals:**
- Modificar `04_2_navegacion.sysml`, `05_comunicaciones.sysml` o `09_sistema_ugv.sysml`, conservando intacta la frontera externa de `ComputadorAutonomia` (`entradaObstaculos`, `entradaOdometria`, `busComunicaciones`, `salidaConsigna`).

## Decisions

1. **Arquitectura de puertos y conexiones internas de `ComputadorAutonomia`**:
   - **`SubsistemaFusionEstado`**:
     - `port entradaObstaculos : ~PuertoMapaObstaculos;`
     - `port entradaOdometria : ~PuertoOdometriaVIO;`
     - `port salidaMapaUnificado : PuertoMapaEstadoUnificado;`
   - **`SubsistemaPlanificacionEvaluacion`**:
     - `port entradaMapaUnificado : ~PuertoMapaEstadoUnificado;`
     - `port busComunicaciones : DataBusPort;`
     - `port salidaSalud : PuertoLatidoSalud;`
     - `port salidaConsigna : PuertoConsignaAutonomia;`
   - **`SupervisorSeguridad`**:
     - `port entradaSalud : ~PuertoLatidoSalud;`
     - `port salidaFrenadoWatchdog : PuertoConsignaAutonomia;`
   - **Conexiones dentro de `part def ComputadorAutonomia`**:
     - `binding b_fusion_obstaculos bind entradaObstaculos = subsistemaFusionEstado.entradaObstaculos;`
     - `binding b_fusion_odometria bind entradaOdometria = subsistemaFusionEstado.entradaOdometria;`
     - `binding b_plan_comms bind busComunicaciones = subsistemaPlanificacionEvaluacion.busComunicaciones;`
     - `connection c_fusion_planificacion connect subsistemaFusionEstado.salidaMapaUnificado to subsistemaPlanificacionEvaluacion.entradaMapaUnificado;`
     - `connection c_planificacion_watchdog connect subsistemaPlanificacionEvaluacion.salidaSalud to supervisorSeguridad.entradaSalud;`
     - `binding b_plan_consigna bind subsistemaPlanificacionEvaluacion.salidaConsigna = salidaConsigna;`
     - `binding b_watchdog_consigna bind supervisorSeguridad.salidaFrenadoWatchdog = salidaConsigna;`

2. **Ítem `ConsignaFrenado` en `PuertoConsignaAutonomia`**:
   - *Decisión*: Declarar `item def ConsignaFrenado` en `SubsistemaControl` y exponer `out item consignaFrenado : ConsignaFrenado;` junto a `out item consigna : ConsignaNavegacionAutonoma;` en `PuertoConsignaAutonomia` (o especializarlo), de modo que tanto la consigna nominal/progresiva de `subsistemaPlanificacionEvaluacion` como la `ConsignaFrenado` de emergencia del `supervisorSeguridad` lleguen a `moduloFrenadoSeguridad.entradaConsigna`.

## Risks / Trade-offs

- **[Risk] Visibilidad de las partes anidadas en Spec42** → **Mitigation**: Añadir `expose SubsistemaControl::SistemaControl::computadorAutonomia;` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` (`Modelos/11_vistas.sysml`) y verificar con `spec42.exe check Modelos` y `spec42.exe diagram Modelos --view "VistasUGV::vistaConexionesNavegacionControl"` que las tres partes internas (`subsistemaFusionEstado`, `subsistemaPlanificacionEvaluacion` y `supervisorSeguridad`) y sus conexiones dentro de `computadorAutonomia` se muestran explícitamente en ambas vistas de Navegación y Control.
