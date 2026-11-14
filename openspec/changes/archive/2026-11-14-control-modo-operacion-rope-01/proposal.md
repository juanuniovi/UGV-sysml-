# Proposal: Control de Modo de Operación y Gestión de Consignas (ROPE-01)

## Why
Actualmente en `Modelos/04_1_control.sysml`, el `SubsistemaPlanificacionEvaluacion` emite continuamente `ConsignaNavegacionAutonoma` hacia el módulo de frenado y actuadores sin contemplar la inhibición requerida cuando el vehículo opera bajo telemando directo. Para cumplir con el requisito contractual **`ROPE-01`** (Modo de Operación Teleoperado), es necesario que `SistemaControl` disponga de una parte dedicada (`ControlModoOperacion`) que reciba la orden de modo desde las estaciones de control (CPT/PMP vía bus de comunicaciones) y gestione activamente la activación o desactivación de las consignas de guiado del computador de autonomía.

## What Changes
- **Nuevo bloque `ControlModoOperacion` en `SistemaControl`**: Definir `part def ControlModoOperacion` encargado de gobernar el estado de operación (`TELEOPERADO` vs. `NAVEGACION_AUTONOMA`).
- **Inhibición/activación de consignas de planificación**: Incorporar una interfaz de habilitación (`consignasHabilitadas : Boolean`) hacia `SubsistemaPlanificacionEvaluacion` (dentro de `ComputadorAutonomia`), de modo que en modo `TELEOPERADO` las consignas de la autonomía queden desactivadas y en modo `NAVEGACION` queden activadas.
- **Ítem y enumeración de modos de operación**: Definir en `SubsistemaControl` la enumeración `ModoOperacionConduccion` (`TELEOPERADO`, `NAVEGACION`) y el ítem `ComandoModoOperacion`.
- **Formalización de `ROPE-01`**: Introducir el requisito formal `ReqModoTeleoperado` (`ROPE-01`) en `SubsistemaControl` y establecer su trazabilidad formal mediante `satisfy`.

## Capabilities

### New Capabilities
<!-- Ninguna nueva capacidad -->

### Modified Capabilities
- `subsistema-control`: Ampliación del subsistema 4.1 de Control para incorporar el componente `ControlModoOperacion`, la interfaz de habilitación de consignas de autonomía y la trazabilidad del requisito `ROPE-01`.

## Impact
- **Archivos de modelo afectados**: `Modelos/04_1_control.sysml`.
- **Compatibilidad**: No rompe las conexiones existentes de contorno en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`), pues la señal de conmutación viaja por el `dataBus` ya conectado con `SistemaComunicacionesEmbarcado`.
- **Trazabilidad**: Permite formalizar `ROPE-01` y coordinarlo con la máquina de estados de [Modelos/10_comportamiento.sysml](file:///C:/Users/mario/Desktop/UGV/ugv-sysml-/Modelos/10_comportamiento.sysml).
