# Spec Delta

## MODIFIED Requirements

### Requirement: Separación estructural del Subsistema 4.2 de Navegación (RGEN-09, RNAV-01, ROPE-06, RGEN-20, RGEN-22)
El modelo SHALL definir en `Modelos/04_2_navegacion.sysml` el paquete `SubsistemaNavegacion` con el bloque `SistemaNavegacion`, integrando dos subpartes contenedoras: `camaras : SubsistemaCamaras` (que agrupa `camarasOpticas360` con visión de profundidad 360°, las dos cámaras laterales independientes `camaraLateralIzquierda` y `camaraLateralDerecha` para visualización de implementos y estado lateral del UGV, y `camaraTermicaNocturna` con identificación de puntos calientes) y `sensores : SubsistemaSensores` (que agrupa los sensores radiantes `sensoresLidar` y `sensoresRadar` y los nuevos sensores físicos del tren de rodaje `transductoresRodaje : TransductoresContactoDinamicos`), manteniendo únicamente `moduloDeteccionEvasion` y `odometriaVisualInercialVIO` directamente en `SistemaNavegacion` (fuera de `camaras` y `sensores`), sin nodo intermedio de visión por computador.

> **Nota de autorización (`AGENTS.md`)**: El usuario (ingeniero de sistemas de la parte 4 de Navegación y Control) ha autorizado explícitamente eliminar `SistemaVisionComputador` (`sistemaVisionComputador`) como nodo intermedio en `SistemaNavegacion` y conectar directamente la información óptica y térmica de `camaras` hacia `moduloDeteccionEvasion`.

#### Scenario: Composición interna de SistemaNavegacion
- **WHEN** se inspecciona la estructura de `SubsistemaNavegacion::SistemaNavegacion`
- **THEN** contiene `part camaras : SubsistemaCamaras` (con `camarasOpticas360`, `camaraLateralIzquierda`, `camaraLateralDerecha` y `camaraTermicaNocturna`), `part sensores : SubsistemaSensores` (con `sensoresLidar`, `sensoresRadar` y `transductoresRodaje`), y en el nivel de `SistemaNavegacion` mantiene `part moduloDeteccionEvasion : ModuloDeteccionEvasion` y `part odometriaVisualInercialVIO : OdometriaVisualInercialVIO`, sin `sistemaVisionComputador`

### Requirement: Interconexiones internas de percepción, apagado desde Comunicaciones y enlace con Control en PlataformaUGV (RGEN-09, RNAV-01)
El bloque `SistemaNavegacion` SHALL conectar internamente las salidas de `sensores` (`sensoresLidar` y `sensoresRadar`) y las salidas óptica y térmica de `camaras` (`salidaOptica` y `salidaTermica`) directamente con `moduloDeteccionEvasion`, conectar `entradaModoDeteccion` a través de `sensores` con `sensoresLidar` y `sensoresRadar` para ejecutar su apagado/encendido mediante el ítem de control `ControlEmisionSigilosoNormal` desde `SistemaComunicacionesEmbarcado`, exponer `salidaObstaculos` y `salidaOdometria` hacia `SistemaControl`, y conectar directamente tanto la salida de vídeo de `camaras` (`salidaVideoTeleoperacion`) como la salida en tiempo real de `transductoresRodaje` en `sensores` (`salidaEstadoRodaje`) hacia `SistemaComunicacionesEmbarcado` en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`, `RGEN-22`).

#### Scenario: Conexión directa de sensores y cámaras hacia el módulo de detección y evasión
- **WHEN** `camaras` capta los flujos óptico y térmico y `sensores` capta los datos LiDAR y radar
- **THEN** `camaras.salidaOptica` se conecta directamente a `moduloDeteccionEvasion.entradaOptica` (`c_camaras_optica_deteccion`), `camaras.salidaTermica` se conecta directamente a `moduloDeteccionEvasion.entradaTermica` (`c_camaras_termica_deteccion`), y `sensores.salidaLidar` y `sensores.salidaRadar` se conectan directamente a `moduloDeteccionEvasion.entradaLidar` y `moduloDeteccionEvasion.entradaRadar`

#### Scenario: Apagado de LiDAR y radar desde Comunicaciones en modo SIGILOSO y entrega de obstáculos a Control
- **WHEN** `PlataformaUGV` ensambla `part comunicaciones : SistemaComunicacionesEmbarcado`, `part navegacion : SistemaNavegacion` y `part control : SistemaControl`
- **THEN** `comunicaciones.salidaModoDeteccion` se conecta a `navegacion.entradaModoDeteccion` (y de ahí a `sensores` para apagar `sensoresLidar` y `sensoresRadar` en modo `SIGILOSO` mediante `ControlEmisionSigilosoNormal`), `navegacion.salidaObstaculos` se conecta a `control.entradaObstaculos` y `navegacion.salidaOdometria` se conecta a `control.entradaOdometria`

#### Scenario: Envío de vídeo de cámaras y estado del tren de rodaje hacia Comunicaciones para teleoperación (RGEN-22)
- **WHEN** `camaras` capta las imágenes de 360° con profundidad, laterales de implementos/UGV y cámara térmica de puntos calientes, y `sensores.transductoresRodaje` adquiere el estado en tiempo real del tren de rodaje
- **THEN** `camaras` envía toda la información de vídeo hacia `comunicaciones.entradaVideoTeleoperacion` (`c_nav_video_comms`) y `sensores.transductoresRodaje` envía la información del tren de rodaje hacia `comunicaciones.entradaEstadoRodaje` (`c_nav_rodaje_comms`) para facilitar la teleoperación del UGV
