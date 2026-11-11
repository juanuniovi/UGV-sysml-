# Proposal

## Why

El requisito **RGEN-22** del pliego técnico exige que el UGV disponga de los medios de captación de imagen y de los sensores necesarios para aportar conciencia situacional, facilitar la teleoperación y el trabajo con los distintos implementos, incluyendo la visualización de los implementos y el estado del tren de rodaje, imágenes independientes de cada lateral del UGV, visión de profundidad que permita el movimiento en 360° y una cámara térmica que identifique puntos calientes. Actualmente, `SubsistemaNavegacion` (`Modelos/04_2_navegacion.sysml`) carece de las dos cámaras laterales independientes para implementos y estado lateral del UGV, de la especificación de visión de profundidad en 360° en `CamarasOpticas360`, de la identificación de puntos calientes en `CamaraTermicaNocturna`, de los transductores de contacto y dinámicos para supervisión en tiempo real del tren de rodaje, de la agrupación interna en las subpartes `camaras` y `sensores`, de las conexiones hacia `SistemaComunicacionesEmbarcado` para enviar al operador tanto la información de vídeo de `camaras` como el estado del tren de rodaje en tiempo real desde `sensores`, y de la formalización trazable del requisito `RGEN-22`.

## What Changes

- **Confirmación explícita del usuario y justificación (`AGENTS.md`)**:
  - El usuario ha confirmado y autorizado explícitamente reorganizar la estructura interna de `SistemaNavegacion` (`Modelos/04_2_navegacion.sysml`) creando dos subpartes dentro de `SistemaNavegacion`: **`camaras : SubsistemaCamaras`** y **`sensores : SubsistemaSensores`**, dejando `sistemaVisionComputador` fuera de `camaras` (en `SistemaNavegacion`). Esta reorganización preserva íntegramente el cumplimiento de `RGEN-09`, `RNAV-01`, `ROPE-06` y `RGEN-20` mientras satisface `RGEN-22`.
- **Actualización de `Modelos/04_2_navegacion.sysml` (`package SubsistemaNavegacion`)**:
  - Actualizar `CamarasOpticas360` (`RGEN-20`, `RGEN-22`) para incorporar visión de profundidad que permita el movimiento en 360° (`attribute visionProfundidad360 : Boolean`).
  - Actualizar la documentación y atributos de `CamaraTermicaNocturna` (`RGEN-22`) indicando expresamente que tiene como objetivo la visión nocturna e identificar puntos calientes (`attribute identificaPuntosCalientes : Boolean`).
  - Crear la definición de cámara lateral `part def CamaraLateralImplementos` (`RGEN-22`) para proporcionar imágenes independientes de cada lateral del UGV, información de los implementos y visión lateral del estado del UGV.
  - Crear la definición de sensores físicos del tren de rodaje `part def TransductoresContactoDinamicos` (`RGEN-22`), con su ítem `DatosEstadoRodaje` y puerto `PuertoEstadoRodaje`, para adquirir información en tiempo real del estado del tren de rodaje.
  - Definir la subparte contenedora `part def SubsistemaCamaras` (`part camaras : SubsistemaCamaras` en `SistemaNavegacion`), agrupando:
    - `part camarasOpticas360 : CamarasOpticas360;` (cobertura 360° con visión de profundidad, `RGEN-20`, `RGEN-22`)
    - `part camaraLateralIzquierda : CamaraLateralImplementos;` (imagen lateral izquierda e implementos, `RGEN-22`)
    - `part camaraLateralDerecha : CamaraLateralImplementos;` (imagen lateral derecha e implementos, `RGEN-22`)
    - `part camaraTermicaNocturna : CamaraTermicaNocturna;` (cámara térmica con identificación de puntos calientes, `RGEN-22`)
    - Exponiendo puertos de salida hacia `sistemaVisionComputador` (`salidaOptica`, `salidaTermica`) y un puerto `salidaVideoTeleoperacion : DataBusPort` hacia `SistemaComunicacionesEmbarcado` (a través del contorno de `SistemaNavegacion`) para que toda la información de vídeo se reciba en Comunicaciones y facilite la teleoperación del UGV.
  - Definir la subparte contenedora `part def SubsistemaSensores` (`part sensores : SubsistemaSensores` en `SistemaNavegacion`), agrupando:
    - `part sensoresLidar : SensorLidar;` (`RGEN-09`)
    - `part sensoresRadar : SensorRadar;` (`RGEN-09`)
    - `part transductoresRodaje : TransductoresContactoDinamicos;` (transductores de contacto y dinámicos para supervisión en tiempo real del tren de rodaje, `RGEN-22`)
    - Exponiendo los puertos de salida de LiDAR (`salidaLidar`) y radar (`salidaRadar`) hacia `moduloDeteccionEvasion`, el puerto de entrada `controlModoDeteccion : DataBusPort` para apagado/encendido de LiDAR y radar en modo sigiloso (`RGEN-09`), y el puerto `salidaEstadoRodaje : DataBusPort` para enviar la información en tiempo real de los transductores del tren de rodaje directamente hacia `SistemaComunicacionesEmbarcado`.
  - Mantener `part sistemaVisionComputador : SistemaVisionComputador`, `part moduloDeteccionEvasion : ModuloDeteccionEvasion` y `part odometriaVisualInercialVIO : OdometriaVisualInercialVIO` directamente en `SistemaNavegacion` (fuera de `camaras` y `sensores`).
  - Exponer en el contorno de `SistemaNavegacion` los nuevos puertos `salidaVideoTeleoperacion : DataBusPort` y `salidaEstadoRodaje : DataBusPort` vinculados internamente con `camaras.salidaVideoTeleoperacion` y `sensores.salidaEstadoRodaje`.
  - Definir formalmente `requirement def ReqConcienciaSituacionalVisionSensores` (`RGEN-22`) con `subject nav : SistemaNavegacion`.
- **Actualización de `Modelos/05_comunicaciones.sysml` (`package SubsistemaComunicaciones`)**:
  - Añadir en `SistemaComunicacionesEmbarcado` los puertos `entradaVideoTeleoperacion : DataBusPort` y `entradaEstadoRodaje : DataBusPort` para recibir toda la información de vídeo de `camaras` y la información en tiempo real de los transductores del tren de rodaje desde `sensores` (`RGEN-22`).
- **Actualización de `Modelos/09_sistema_ugv.sysml` (`package SistemaUGV`)**:
  - Añadir en `PlataformaUGV`:
    - `connection c_nav_video_comms connect navegacion.salidaVideoTeleoperacion to comunicaciones.entradaVideoTeleoperacion;`
    - `connection c_nav_rodaje_comms connect navegacion.salidaEstadoRodaje to comunicaciones.entradaEstadoRodaje;`
    - `satisfy requirement : ReqConcienciaSituacionalVisionSensores by navegacion;`
- **Actualización de `Modelos/11_vistas.sysml` (`package VistasUGV`)**:
  - Exponer en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` las nuevas conexiones `c_nav_video_comms` y `c_nav_rodaje_comms`, de modo que las subpartes `camaras` y `sensores` se vean anidadas dentro de `navegacion` (con sus elementos internos y conexiones), sin duplicarlas como raíces independientes.
- **Fuera de alcance**:
  - Estipular carcasas o atributos de protección física de sensores/cámaras (excluido expresamente por indicación del usuario).
  - Modificar `01_barcaza.sysml`, `02_tren_rodaje.sysml`, `03_planta_motriz.sysml`, `04_1_control.sysml`, `06_estaciones_control.sysml`, `07_uav_cenital.sysml`, `08_cargas_pago.sysml` o `10_comportamiento.sysml`.

## Capabilities

### New Capabilities
<!-- Ninguna capacidad nueva; se amplía y actualiza la capacidad existente subsistema-navegacion. -->

### Modified Capabilities
- `subsistema-navegacion`: Se actualiza la estructura interna de `SistemaNavegacion` para agrupar todas las cámaras (`camarasOpticas360` con visión de profundidad 360°, `camaraLateralIzquierda`, `camaraLateralDerecha` y `camaraTermicaNocturna` con identificación de puntos calientes) en la subparte `camaras : SubsistemaCamaras`, y agrupar `sensoresLidar`, `sensoresRadar` y los nuevos `transductoresRodaje : TransductoresContactoDinamicos` en la subparte `sensores : SubsistemaSensores`, manteniendo `sistemaVisionComputador` fuera de `camaras` y conectando tanto el vídeo de `camaras` como el estado del tren de rodaje de `sensores` con `SistemaComunicacionesEmbarcado`, además de formalizar `ReqConcienciaSituacionalVisionSensores` (`RGEN-22`).

## Impact

- **Archivos afectados**:
  - `Modelos/04_2_navegacion.sysml`
  - `Modelos/05_comunicaciones.sysml`
  - `Modelos/09_sistema_ugv.sysml`
  - `Modelos/11_vistas.sysml`
- **Subsistemas afectados**:
  - `SubsistemaNavegacion`, `SubsistemaComunicaciones`, `SistemaUGV` y `VistasUGV`.
- **Requisitos del pliego relacionados y posibles conflictos**:
  - `RGEN-22`: Formalizado mediante `ReqConcienciaSituacionalVisionSensores`, cámaras 360° con profundidad, dos cámaras laterales de implementos/estado, cámara térmica con identificación de puntos calientes, transductores de contacto y dinámicos del tren de rodaje, y envío de vídeo y estado de rodaje a Comunicaciones.
  - `RGEN-09`, `RNAV-01`, `ROPE-06`, `RGEN-20`: Se mantienen íntegros sin pérdida de trazabilidad; la agrupación interna en las subpartes `camaras` y `sensores` cuenta con autorización explícita del usuario.
