# Proposal: Formalización y Submodos de Navegación Autónoma de ROPE-05

## Why

El requisito operativo contractual `ROPE-05` exige que el modo AUTÓNOMO del UGV incorpore al menos cinco submodos funcionales (navegación por puntos de paso, punto de destino, regreso a casa, seguimiento Follow-Me y lanzadera shuttle) habilitables y deshabilitables en cualquier momento antes y durante la misión. Actualmente, `ROPE-05` solo se menciona de forma testimonial en comentarios de `Modelos/04_1_control.sysml`, sin definición formal (`requirement def`), sin relaciones `satisfy` y sin el tipado explícito de los cinco submodos ni de su comando de misión en SysML v2.

## What Changes

- **Tipado de los 5 Submodos de Autonomía en `Modelos/04_1_control.sysml`**:
  - Declarar `enum def SubmodoNavegacionAutonoma` con los valores `PUNTOS_PASO`, `PUNTO_DESTINO`, `REGRESO_ORIGEN`, `SEGUIMIENTO_FOLLOW_ME` y `SHUTTLE_LANZADERA`.
  - Definir `item def ComandoSubmodoAutonomia` para tipar el comando de activación y conmutación de submodos recibido por `dataBus`.
  - Añadir el atributo `submodoActivo : SubmodoNavegacionAutonoma` en `ComputadorAutonomia` y `submodoAutonomiaComandado` en `SistemaControl`.
- **Formalización de `ReqSubmodosNavegacionAutonoma` en `Modelos/04_1_control.sysml`**:
  - Incorporar `requirement def ReqSubmodosNavegacionAutonoma` con `subject ctrl : SistemaControl;` y la cita literal auditada de `ROPE-06` del pliego oficial (`docs/ROBOT_TERRESTRE_Anexo_I.pdf`, págs. 113-114).
  - Incluir en `SistemaControl` la relación `satisfy ReqSubmodosNavegacionAutonoma by computadorAutonomia;`.
- **Satisfacción a nivel de Plataforma en `Modelos/09_sistema_ugv.sysml`**:
  - Incluir en `PlataformaUGV` la relación `satisfy requirement : ReqSubmodosNavegacionAutonoma by control;`.
- **Verificación y validación**:
  - Verificar que Spec42 resuelva los tipos, satisfacciones y vistas con 0 errores y 0 advertencias.

## Capabilities

### New Capabilities
*(Ninguna)*

### Modified Capabilities
- `subsistema-control`: Incorporación del requisito formal `ReqSubmodosNavegacionAutonoma` (`ROPE-05`), tipado explícito de los cinco submodos de navegación autónoma (`SubmodoNavegacionAutonoma`), ítem de comando de submodo (`ComandoSubmodoAutonomia`) y relaciones `satisfy` en `SistemaControl` y `PlataformaUGV`.

## Impact

- **Modelos modificados**:
  - `Modelos/04_1_control.sysml`: enumerado de submodos, comando de submodo, requisito formal y satisfy en `SistemaControl`.
  - `Modelos/09_sistema_ugv.sysml`: relación satisfy de plataforma en `PlataformaUGV`.
- **Requisitos contractuales auditados**:
  - `ROPE-05` (Anexo I, cláusula 3.4, págs. 113-114): funcionalidades de navegación autónoma (puntos de paso, punto de destino, regreso a origen/casa, seguimiento automático Follow-Me y lanzadera shuttle).
  - Preservación íntegra de `ROPE-01`, `ROPE-06`, `RGEN-09`, `RGEN-17`, `RGEN-20`, `RNAV-01`.
