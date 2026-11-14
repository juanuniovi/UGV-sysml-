# Design: Renombrar ControlModoOperacion a GobiernoControl

## Context
En `Modelos/04_1_control.sysml`, `part def ControlModoOperacion` y su uso `part controlModoOperacion : ControlModoOperacion;` definen el árbitro de modos de conducción dentro de `SistemaControl`. El usuario ha decidido adoptar la denominación más descriptiva y jerárquica `GobiernoControl` para evitar conflictos conceptuales con los modos operativos globales del UGV (`ROPE-07`). Véase `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**
- Renombrar `part def ControlModoOperacion` a `part def GobiernoControl` en `Modelos/04_1_control.sysml`.
- Renombrar la parte interna `part controlModoOperacion : ControlModoOperacion;` a `part gobiernoControl : GobiernoControl;`.
- Actualizar de forma coherente las referencias internas en `SistemaControl`:
  - `connection c_bus_comms_modo connect dataBus to gobiernoControl.busComunicaciones;`
  - `connection c_modo_habilitacion_consignas connect gobiernoControl.salidaControlHabilitacion to computadorAutonomia.entradaHabilitacionConsignas;`
  - `satisfy ReqModoTeleoperado by gobiernoControl;`
- Mantener la sintaxis SysML v2 estricta y la trazabilidad de `ROPE-01`.

**Non-Goals:**
- No alterar puertos externos ni interfaces de contorno de `SistemaControl`.
- No modificar el comportamiento funcional de inhibición de consignas en `SubsistemaPlanificacionEvaluacion`.

## Decisions

### Decisión 1: Alcance del renombrado
- **Elección**: Renombrar de forma integral tanto la definición del bloque (`part def GobiernoControl`) como su uso (`part gobiernoControl : GobiernoControl;`) y docstrings asociados.
- **Justificación**: Mantiene máxima claridad y estilo idiomático en SysML v2, alineado con las buenas prácticas del proyecto.

## Risks / Trade-offs

- **[Riesgo] Referencias obsoletas** → **Mitigación**: Auditoría de texto grep en todo `Modelos/` tras la edición para verificar que no queden ocurrencias de `ControlModoOperacion` ni `controlModoOperacion`.
