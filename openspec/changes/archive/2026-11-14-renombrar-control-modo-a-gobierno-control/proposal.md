# Proposal: Renombrar ControlModoOperacion a GobiernoControl

## Why
En `Modelos/04_1_control.sysml`, se modeló recientemente el componente `ControlModoOperacion` para conmutar entre el modo teleoperado y la navegación autónoma. Para reflejar con mayor precisión su cometido técnico en la arquitectura jerárquica de ingeniería de sistemas (arbitraje y gobierno de la conducción dentro del subsistema de control) y evitar ambigüedades con los modos operativos globales del sistema UGV (`FUERA_DE_LINEA`, `TELEOPERADO`, `AUTONOMO`), el usuario ha solicitado explícitamente renombrar este elemento a `GobiernoControl`.

## What Changes
- **Renombrado de definición de bloque**: En `Modelos/04_1_control.sysml`, renombrar `part def ControlModoOperacion` a `part def GobiernoControl`.
- **Renombrado de instancia**: En `part def SistemaControl`, renombrar `part controlModoOperacion : ControlModoOperacion;` a `part gobiernoControl : GobiernoControl;`.
- **Actualización de enlaces y relaciones**: Actualizar las conexiones internas `c_bus_comms_modo`, `c_modo_habilitacion_consignas` y la relación `satisfy ReqModoTeleoperado by gobiernoControl;`.
- **Actualización de especificaciones**: Sincronizar [openspec/specs/subsistema-control/spec.md](file:///C:/Users/mario/Desktop/UGV/ugv-sysml-/openspec/specs/subsistema-control/spec.md) con la nueva nomenclatura `gobiernoControl : GobiernoControl`.

## Capabilities

### New Capabilities
<!-- Ninguna nueva capacidad -->

### Modified Capabilities
- `subsistema-control`: Actualización de la especificación estructural de `SistemaControl` para referenciar la parte arbitral bajo el nombre `gobiernoControl : GobiernoControl`.

## Impact
- **Archivos de modelo afectados**: `Modelos/04_1_control.sysml`.
- **Compatibilidad**: Conserva exactamente la misma funcionalidad, puertos e interfaces con `dataBus` y `computadorAutonomia`.
- **Trazabilidad**: Mantiene la satisfacción de `ROPE-01` (`ReqModoTeleoperado`).
