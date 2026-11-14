# Proposal: Formalización y Satisfacción de ROPE-06 (Detect & Avoid)

## Why

El requisito operativo contractual `ROPE-06` ("Detectar y Evadir" obstáculos en modo AUTÓNOMO, en modos NORMAL y SIGILOSO) se encuentra ampliamente referenciado en comentarios y docstrings de `04_2_navegacion.sysml` y `04_1_control.sysml`, pero carece de definición formal (`requirement def`) y de relaciones de satisfacción (`satisfy`) en el modelo SysML v2. Esta laguna de trazabilidad impide validar en la ingeniería de sistemas que el UGV satisface formalmente la exigencia contractual de detección y evasión de obstáculos antes de delegar la implementación a los desarrolladores de ROS 2.

## What Changes

- **Formalización de `ReqDeteccionEvasionObstaculos` en `Modelos/04_2_navegacion.sysml`**:
  - Incorporar la definición formal `requirement def ReqDeteccionEvasionObstaculos` con `subject nav : SistemaNavegacion;` y la cita literal auditada de `ROPE-06` del pliego oficial (`docs/ROBOT_TERRESTRE_Anexo_I.pdf`, pág. 114).
  - Incluir en `SistemaNavegacion` la relación de satisfacción: `satisfy ReqDeteccionEvasionObstaculos by moduloDeteccionEvasion;`.
- **Satisfacción a nivel de Plataforma en `Modelos/09_sistema_ugv.sysml`**:
  - Incluir en `PlataformaUGV` la relación de satisfacción de plataforma: `satisfy requirement : ReqDeteccionEvasionObstaculos by navegacion;`.
- **Trazabilidad y Vistas en `Modelos/11_vistas.sysml`**:
  - Verificar que Spec42 renderice la trazabilidad de `ROPE-06` en `vistaRequisitos` y en las vistas de interconexión con 0 errores y 0 advertencias.

## Capabilities

### New Capabilities
*(Ninguna)*

### Modified Capabilities
- `subsistema-navegacion`: Incorporación formal del requisito contractual `ReqDeteccionEvasionObstaculos` (`ROPE-06`) y su satisfacción formal por `moduloDeteccionEvasion` en `SistemaNavegacion` y por `navegacion` en `PlataformaUGV`.

## Impact

- **Modelos modificados**:
  - `Modelos/04_2_navegacion.sysml`: nueva definición `ReqDeteccionEvasionObstaculos` y `satisfy`.
  - `Modelos/09_sistema_ugv.sysml`: relación `satisfy requirement : ReqDeteccionEvasionObstaculos by navegacion;` en `PlataformaUGV`.
- **Requisitos contractuales auditados**:
  - `ROPE-06` (Anexo I, cláusula 3.4, pág. 114): "El sistema en su modo AUTÓNOMO deberá tener la capacidad de “Detectar y Evadir” obstáculos estáticos y dinámicos, que se interpongan en la trayectoria del UGV, y lo deberá realizar independientemente de si se encuentra en Modo de Detección NORMAL o SIGILOSO. Esto incluye recalcular trayectorias, dar marcha atrás, volverse y buscar otras alternativas, etc."
  - Sin alteración de requisitos previos: `RNAV-01`, `RGEN-09`, `RGEN-17`, `RGEN-20`, `RGEN-22` y `ROPE-01` permanecen intactos.
