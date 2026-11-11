# Design

## Context

El requisito **RGEN-22** exige dotar al UGV de los medios de captación de imagen y sensores necesarios para aportar conciencia situacional, facilitar la teleoperación y el trabajo con los distintos implementos:
- Visualización en 360° con **visión de profundidad** que permita el movimiento en 360°.
- **Dos cámaras laterales independientes** (izquierda y derecha) que aporten información de los implementos y visión lateral del estado del UGV.
- **Cámara térmica** que, además de visión nocturna, tenga como objetivo **identificar puntos calientes**.
- **Sensores físicos (transductores de contacto y dinámicos)** para supervisar en tiempo real el estado del tren de rodaje.
- Agrupación dentro de `SistemaNavegacion` (`Modelos/04_2_navegacion.sysml`) en dos subpartes: **`camaras`** (todas las cámaras/vídeo) y **`sensores`** (`sensoresLidar`, `sensoresRadar` y `transductoresRodaje`), dejando **`sistemaVisionComputador` fuera de `camaras`**.
- Conexión desde `camaras` hacia `SistemaComunicacionesEmbarcado` (para que toda la información de vídeo la vean desde Comunicaciones y facilite la teleoperación) y desde los transductores del tren de rodaje en `sensores` directamente hacia `SistemaComunicacionesEmbarcado`.

## Goals / Non-Goals

**Goals:**
- Actualizar `CamarasOpticas360` con visión de profundidad 360° (`attribute visionProfundidad360 : Boolean`) y `CamaraTermicaNocturna` con identificación de puntos calientes (`attribute identificaPuntosCalientes : Boolean`).
- Definir `part def CamaraLateralImplementos` para las dos cámaras laterales (`camaraLateralIzquierda` y `camaraLateralDerecha`) y `part def TransductoresContactoDinamicos` para la supervisión en tiempo real del tren de rodaje (`transductoresRodaje`).
- Crear dentro de `SubsistemaNavegacion` las definiciones `part def SubsistemaCamaras` (`part camaras : SubsistemaCamaras`) y `part def SubsistemaSensores` (`part sensores : SubsistemaSensores`), manteniendo `sistemaVisionComputador`, `moduloDeteccionEvasion` y `odometriaVisualInercialVIO` directamente en `SistemaNavegacion`.
- Conectar `camaras` tanto con `sistemaVisionComputador` (para detección pasiva en navegación autónoma) como con `SistemaComunicacionesEmbarcado` (`c_nav_video_comms` en `PlataformaUGV`) para enviar toda la información de vídeo a Comunicaciones.
- Conectar `transductoresRodaje` (dentro de `sensores`) con `SistemaComunicacionesEmbarcado` (`c_nav_rodaje_comms` en `PlataformaUGV`) para transmitir en tiempo real el estado del tren de rodaje.
- Formalizar `requirement def ReqConcienciaSituacionalVisionSensores` (`RGEN-22`) en `SubsistemaNavegacion` y su `satisfy` en `PlataformaUGV`.
- Actualizar `Modelos/11_vistas.sysml` para exponer `camaras`, `sensores` y las nuevas conexiones con `comunicaciones` y validar con Spec42 (0 errores, 0 avisos).

**Non-Goals:**
- Modelar carcasas o atributos de protección física de cámaras y sensores (descartado explícitamente por el usuario para esta fase).
- Alterar `04_1_control.sysml` o el resto de subsistemas no afectados.

## Decisions

1. **Subparte `SubsistemaCamaras` (`part camaras : SubsistemaCamaras`) en `04_2_navegacion.sysml`**:
   - *Decisión*: Definir `part def SubsistemaCamaras` con:
     - `part camarasOpticas360 : CamarasOpticas360;` (con `attribute visionProfundidad360 : Boolean;`)
     - `part camaraLateralIzquierda : CamaraLateralImplementos;`
     - `part camaraLateralDerecha : CamaraLateralImplementos;`
     - `part camaraTermicaNocturna : CamaraTermicaNocturna;` (con `attribute identificaPuntosCalientes : Boolean;`)
   - *Puertos y conexiones internas de `SubsistemaCamaras`*:
     - Para alimentar a `sistemaVisionComputador` (que permanece fuera de `camaras`), `SubsistemaCamaras` expone `port salidaOptica : PuertoVideoOptico;` y `port salidaTermica : PuertoVideoOptico;`, conectados internamente desde las cámaras ópticas (`camarasOpticas360`, `camaraLateralIzquierda`, `camaraLateralDerecha`) y desde `camaraTermicaNocturna`.
     - Para enviar toda la información de vídeo a `SistemaComunicacionesEmbarcado`, cada cámara dispone de `port salidaVideoComms : DataBusPort;` conectado al puerto de contorno `port salidaVideoTeleoperacion : DataBusPort;` de `SubsistemaCamaras`, el cual se enlaza mediante `binding` al puerto `port salidaVideoTeleoperacion : DataBusPort;` de `SistemaNavegacion` y de ahí mediante `connection c_nav_video_comms` a `comunicaciones.entradaVideoTeleoperacion` en `PlataformaUGV`.

2. **Subparte `SubsistemaSensores` (`part sensores : SubsistemaSensores`) en `04_2_navegacion.sysml`**:
   - *Decisión*: Definir `part def TransductoresContactoDinamicos` con `item def DatosEstadoRodaje` y `port salidaEstadoRodaje : DataBusPort;` (y puerto de datos de estado de rodaje).
   - Definir `part def SubsistemaSensores` agrupando:
     - `part sensoresLidar : SensorLidar;`
     - `part sensoresRadar : SensorRadar;`
     - `part transductoresRodaje : TransductoresContactoDinamicos;`
   - *Puertos y conexiones internas de `SubsistemaSensores`*:
     - Expone `port salidaLidar : PuertoDatosLidar;` (vinculado a `sensoresLidar.puertoLidar`), `port salidaRadar : PuertoDatosRadar;` (vinculado a `sensoresRadar.puertoRadar`), `port controlModoDeteccion : DataBusPort;` (conectado internamente a `sensoresLidar.controlModoDeteccion` y `sensoresRadar.controlModoDeteccion` para `RGEN-09`), y `port salidaEstadoRodaje : DataBusPort;` (vinculado a `transductoresRodaje.salidaEstadoRodaje`).
     - En `SistemaNavegacion`, `sensores.salidaLidar` y `sensores.salidaRadar` se conectan a `moduloDeteccionEvasion.entradaLidar` y `moduloDeteccionEvasion.entradaRadar`; `entradaModoDeteccion` se conecta a `sensores.controlModoDeteccion`; y `sensores.salidaEstadoRodaje` se vincula a `SistemaNavegacion.salidaEstadoRodaje`, que en `PlataformaUGV` se conecta a `comunicaciones.entradaEstadoRodaje` mediante `connection c_nav_rodaje_comms`.

3. **Vistas conjuntas en `11_vistas.sysml`**:
   - *Decisión*: En `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`, exponer únicamente las partes de nivel raíz de la arquitectura conjunta (`control`, `navegacion`, `comunicaciones`) y sus conexiones inter-subsistema (`c_nav_obstaculos_ctrl`, `c_nav_vio_ctrl`, `c_comms_modo_nav`, `c_comms_frenado_ctrl`, `c_nav_video_comms`, `c_nav_rodaje_comms`, `c_bus_comms_control`).
   - *Ajuste tras revisión del usuario*: Se eliminaron las exposiciones aisladas directas (`computadorAutonomia`, `camaras`, `sensores`). Spec42 trata cada `expose` adicional como una raíz independiente, lo que causaba cajas flotantes duplicadas en la cabecera del diagrama. Al exponer únicamente las partes contenedoras (`control`, `navegacion`, `comunicaciones`), todas las subpartes (`camaras` con sus 4 cámaras, `sensores` con sus 3 sensores, y `computadorAutonomia` con sus 3 nodos ROS 2) se dibujan estricta y limpiamente anidadas dentro de sus respectivos contenedores padres.
   - *Renderizado visual y artefactos*: Se exportaron los diagramas SVG con profundidad completa (`--depth 2`) a `Vistas graficas/vistaConexionesNavegacionControl.svg` y `Vistas graficas/vistaEstructuraNavegacionControl.svg` para consulta gráfica directa e inspección en navegadores y visor interactivo.

## Risks / Trade-offs

- **[Risk] Profundidad de despliegue en visor interactivo de Spec42** → **Mitigation**: Mantener la jerarquía limpia sin duplicados en el modelo SysML v2 y proveer las exportaciones gráficas a profundidad 2 en `Vistas graficas/` para visualización inmediata con todos los componentes interiores y conexiones visibles.
