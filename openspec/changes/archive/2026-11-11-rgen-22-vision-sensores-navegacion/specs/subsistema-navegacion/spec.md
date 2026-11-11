## MODIFIED Requirements

### Requirement: Separación estructural del Subsistema 4.2 de Navegación (RGEN-09, RNAV-01, ROPE-06, RGEN-20, RGEN-22)
El modelo SHALL definir en `Modelos/04_2_navegacion.sysml` el paquete `SubsistemaNavegacion` con el bloque `SistemaNavegacion`, integrando dos subpartes contenedoras: `camaras : SubsistemaCamaras` (que agrupa `camarasOpticas360` con visión de profundidad 360°, las dos cámaras laterales independientes `camaraLateralIzquierda` y `camaraLateralDerecha` para visualización de implementos y estado lateral del UGV, y `camaraTermicaNocturna` con identificación de puntos calientes) y `sensores : SubsistemaSensores` (que agrupa los sensores radiantes `sensoresLidar` y `sensoresRadar` y los nuevos sensores físicos del tren de rodaje `transductoresRodaje : TransductoresContactoDinamicos`), manteniendo `sistemaVisionComputador`, `moduloDeteccionEvasion` y `odometriaVisualInercialVIO` directamente en `SistemaNavegacion` (fuera de `camaras` y `sensores`).

> **Nota de autorización (`AGENTS.md`)**: El usuario ha autorizado explícitamente agrupar todas las cámaras dentro de la subparte `camaras` y agrupar LiDAR, radar y los transductores del tren de rodaje dentro de la subparte `sensores` en `SistemaNavegacion`, manteniendo `sistemaVisionComputador` fuera de `camaras`.

#### Scenario: Composición interna de SistemaNavegacion
- **WHEN** se inspecciona la estructura de `SubsistemaNavegacion::SistemaNavegacion`
- **THEN** contiene `part camaras : SubsistemaCamaras` (con `camarasOpticas360`, `camaraLateralIzquierda`, `camaraLateralDerecha` y `camaraTermicaNocturna`), `part sensores : SubsistemaSensores` (con `sensoresLidar`, `sensoresRadar` y `transductoresRodaje`), y en el nivel de `SistemaNavegacion` mantiene `part sistemaVisionComputador : SistemaVisionComputador`, `part moduloDeteccionEvasion : ModuloDeteccionEvasion` y `part odometriaVisualInercialVIO : OdometriaVisualInercialVIO`

### Requirement: Interconexiones internas de percepción, apagado desde Comunicaciones y enlace con Control en PlataformaUGV (RGEN-09, RNAV-01)
El bloque `SistemaNavegacion` SHALL conectar internamente las salidas de `sensores` (`sensoresLidar` y `sensoresRadar`) y `sistemaVisionComputador` (alimentado desde `camaras`) con `moduloDeteccionEvasion`, conectar `entradaModoDeteccion` a través de `sensores` con `sensoresLidar` y `sensoresRadar` para ejecutar su apagado/encendido desde `SistemaComunicacionesEmbarcado`, exponer `salidaObstaculos` y `salidaOdometria` hacia `SistemaControl`, y conectar directamente tanto la salida de vídeo de `camaras` (`salidaVideoTeleoperacion`) como la salida en tiempo real de `transductoresRodaje` en `sensores` (`salidaEstadoRodaje`) hacia `SistemaComunicacionesEmbarcado` en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`, `RGEN-22`).

#### Scenario: Apagado de LiDAR y radar desde Comunicaciones en modo SIGILOSO y entrega de obstáculos a Control
- **WHEN** `PlataformaUGV` ensambla `part comunicaciones : SistemaComunicacionesEmbarcado`, `part navegacion : SistemaNavegacion` y `part control : SistemaControl`
- **THEN** `comunicaciones.salidaModoDeteccion` se conecta a `navegacion.entradaModoDeteccion` (y de ahí a `sensores` para apagar `sensoresLidar` y `sensoresRadar` en modo `SIGILOSO`), `navegacion.salidaObstaculos` se conecta a `control.entradaObstaculos` y `navegacion.salidaOdometria` se conecta a `control.entradaOdometria`

#### Scenario: Envío de vídeo de cámaras y estado del tren de rodaje hacia Comunicaciones para teleoperación (RGEN-22)
- **WHEN** `camaras` capta las imágenes de 360° con profundidad, laterales de implementos/UGV y cámara térmica de puntos calientes, y `sensores.transductoresRodaje` adquiere el estado en tiempo real del tren de rodaje
- **THEN** `camaras` envía toda la información de vídeo hacia `comunicaciones.entradaVideoTeleoperacion` (`c_nav_video_comms`) y `sensores.transductoresRodaje` envía la información del tren de rodaje hacia `comunicaciones.entradaEstadoRodaje` (`c_nav_rodaje_comms`) para facilitar la teleoperación del UGV

### Requirement: Trazabilidad de requisitos RNAV-01 y RGEN-09 sobre SistemaNavegacion y vista conjunta con Control
El paquete `SubsistemaNavegacion` SHALL mantener los requisitos `ReqNavegacionGNSSDenegado` (`RNAV-01`), `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) y `ReqConcienciaSituacionalVisionSensores` (`RGEN-22`) con `subject nav : SistemaNavegacion` y satisfacción formal `satisfy`, y `Modelos/11_vistas.sysml` SHALL representar en la vista conjunta (`vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`) tanto `SistemaControl` como `SistemaNavegacion` (incluyendo sus subpartes `camaras` y `sensores` y sus conexiones con Comunicaciones).

#### Scenario: Verificación de trazabilidad y vista conjunta de Navegación y Control en Spec42
- **WHEN** se valida el modelo con Spec42 (`vistaRequisitos`, `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`)
- **THEN** los requisitos `RNAV-01`, `RGEN-09` y `RGEN-22` quedan trazados sin errores ni advertencias y se visualizan las subpartes `camaras` y `sensores` junto con sus conexiones internas y hacia `comunicaciones`
