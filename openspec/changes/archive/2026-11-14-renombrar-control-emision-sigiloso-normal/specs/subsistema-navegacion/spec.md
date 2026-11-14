# Spec Delta: subsistema-navegacion

## MODIFIED Requirements

### Requirement: Interconexiones internas de percepción, apagado desde Comunicaciones y enlace con Control en PlataformaUGV (RGEN-09, RNAV-01)
El bloque `SistemaNavegacion` SHALL conectar internamente las salidas de `sensores` (`sensoresLidar` y `sensoresRadar`) y `sistemaVisionComputador` (alimentado desde `camaras`) con `moduloDeteccionEvasion`, conectar `entradaModoDeteccion` a través de `sensores` con `sensoresLidar` y `sensoresRadar` para ejecutar su apagado/encendido mediante el ítem de control `ControlEmisionSigilosoNormal` desde `SistemaComunicacionesEmbarcado`, exponer `salidaObstaculos` y `salidaOdometria` hacia `SistemaControl`, y conectar directamente tanto la salida de vídeo de `camaras` (`salidaVideoTeleoperacion`) como la salida en tiempo real de `transductoresRodaje` en `sensores` (`salidaEstadoRodaje`) hacia `SistemaComunicacionesEmbarcado` en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`, `RGEN-22`).

#### Scenario: Apagado de LiDAR y radar desde Comunicaciones en modo SIGILOSO y entrega de obstáculos a Control
- **WHEN** `PlataformaUGV` ensambla `part comunicaciones : SistemaComunicacionesEmbarcado`, `part navegacion : SistemaNavegacion` y `part control : SistemaControl`
- **THEN** `comunicaciones.salidaModoDeteccion` se conecta a `navegacion.entradaModoDeteccion` (y de ahí a `sensores` para apagar `sensoresLidar` y `sensoresRadar` en modo `SIGILOSO` mediante `ControlEmisionSigilosoNormal`), `navegacion.salidaObstaculos` se conecta a `control.entradaObstaculos` y `navegacion.salidaOdometria` se conecta a `control.entradaOdometria`

#### Scenario: Envío de vídeo de cámaras y estado del tren de rodaje hacia Comunicaciones para teleoperación (RGEN-22)
- **WHEN** `camaras` capta las imágenes de 360° con profundidad, laterales de implementos/UGV y cámara térmica de puntos calientes, y `sensores.transductoresRodaje` adquiere el estado en tiempo real del tren de rodaje
- **THEN** `camaras` envía toda la información de vídeo hacia `comunicaciones.entradaVideoTeleoperacion` (`c_nav_video_comms`) y `sensores.transductoresRodaje` envía la información del tren de rodaje hacia `comunicaciones.entradaEstadoRodaje` (`c_nav_rodaje_comms`) para facilitar la teleoperación del UGV
