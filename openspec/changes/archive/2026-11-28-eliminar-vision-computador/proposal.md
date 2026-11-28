# Proposal

## Why

En la arquitectura actual de `SubsistemaNavegacion` (`Modelos/04_2_navegacion.sysml`), el bloque `SistemaVisionComputador` (`sistemaVisionComputador`) actúa únicamente como un nodo intermedio redundante que recibe los flujos óptico y térmico de `SubsistemaCamaras` (`camaras`) para reenviarlos a `ModuloDeteccionEvasion` (`moduloDeteccionEvasion`). Dado que el procesamiento y la fusión de percepción para detección y evasión de obstáculos (*Sense & Avoid*) se realizan en `ModuloDeteccionEvasion` (y en el computador de autonomía), el ingeniero de sistemas de la parte 4 ha solicitado eliminar `SistemaVisionComputador` como nodo y conectar directamente la información de las cámaras al módulo de detección y evasión.

## What Changes

- **Eliminación de `SistemaVisionComputador` (`Modelos/04_2_navegacion.sysml`)**:
  - Se elimina `part def SistemaVisionComputador` y la instancia `part sistemaVisionComputador : SistemaVisionComputador;` de `SistemaNavegacion`.
  - Se eliminan los elementos exclusivos de ese nodo intermedio (`PuertoDatosVision`, `DatosVisionComputador` o su sustitución/renombrado a `DatosVideoCamaras` según diseño, y las conexiones `c_camaras_optica_vision`, `c_camaras_termica_vision` y `c_vision_deteccion`).
- **Conexión directa `camaras` → `moduloDeteccionEvasion` (`Modelos/04_2_navegacion.sysml`)**:
  - `ModuloDeteccionEvasion` pasa a recibir directamente los puertos óptico y térmico procedentes de `SubsistemaCamaras` (`camaras.salidaOptica` y `camaras.salidaTermica`).
  - Se actualiza `DetectarObstaculosNavegacion` y el texto descriptivo (`doc`) de `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) para reflejar que la tecnología no radiante pasiva procede directamente de las cámaras ópticas y térmicas hacia `ModuloDeteccionEvasion`, preservando íntegramente el requisito contractual `RGEN-09`.
- **Actualización de comentarios y vistas (`Modelos/04_1_control.sysml`, `Modelos/11_vistas.sysml`)**:
  - Se actualizan los comentarios de documentación (`doc`) de `SubsistemaFusionEstado` (`04_1_control.sysml`) y de `vistaEstructuraNavegacionControl` / `vistaConexionesNavegacionControl` (`11_vistas.sysml`) para eliminar las referencias al nodo suprimido `visión por computador`.
- **Fuera de alcance**:
  - No se modifican las cámaras de `SubsistemaCamaras` ni sus enlaces de teleoperación hacia `SistemaComunicacionesEmbarcado` (`RGEN-22`).
  - No se modifican `SubsistemaSensores` (`sensoresLidar`, `sensoresRadar`, `transductoresRodaje`), `OdometriaVisualInercialVIO` (`RNAV-01`), ni la arquitectura interna de `ComputadorAutonomia` (`04_1_control.sysml`).

## Capabilities

### New Capabilities
<!-- Ninguna capacidad nueva -->

### Modified Capabilities
- `subsistema-navegacion`: Se modifica la arquitectura interna de `SistemaNavegacion` para eliminar el nodo `sistemaVisionComputador` y conectar directamente las salidas óptica y térmica de `camaras` a `moduloDeteccionEvasion`, manteniendo intactos los requisitos contractuales `RGEN-09`, `RGEN-20`, `RGEN-22`, `ROPE-06` y `RNAV-01`.

## Confirmación explícita de requisitos (`AGENTS.md`)

- **Requisitos afectados**:
  - `openspec/specs/subsistema-navegacion/spec.md`: los requisitos *"Separación estructural del Subsistema 4.2 de Navegación"* e *"Interconexiones internas de percepción, apagado desde Comunicaciones y enlace con Control en PlataformaUGV"* exigían mantener `sistemaVisionComputador` como parte independiente en `SistemaNavegacion` y conectarlo entre `camaras` y `moduloDeteccionEvasion`.
  - `Modelos/04_2_navegacion.sysml`: `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) mencionaba `"no radiantes (vision por computador)"` en su `doc`.
- **Autorización y justificación**: El usuario (ingeniero de sistemas de la parte 4 de Navegación y Control) ha confirmado explícitamente la eliminación del nodo `SistemaVisionComputador` y la conexión directa de `camaras` hacia `moduloDeteccionEvasion`, al ser el procesado de detección y evasión responsabilidad directa de `ModuloDeteccionEvasion` (*Sense & Avoid*). El cumplimiento contractual de `RGEN-09` (detección pasiva no radiante en modo `SIGILOSO`) se mantiene sin relajación mediante las cámaras ópticas 360°, laterales y térmica conectadas a `ModuloDeteccionEvasion`.

## Impact

- **Modelos SysML v2**:
  - `Modelos/04_2_navegacion.sysml` (estructura, puertos, conexiones, acciones y `doc` de `ReqDeteccionObstaculosModoSigiloso`).
  - `Modelos/04_1_control.sysml` (ajuste de comentario `doc` en `SubsistemaFusionEstado`).
  - `Modelos/11_vistas.sysml` (ajuste de `doc` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`).
- **Especificaciones**: `openspec/specs/subsistema-navegacion/spec.md`.
- **Vistas gráficas**: Regeneración/actualización de vistas afectadas tras validar con Spec42 (0 errores, 0 avisos).
