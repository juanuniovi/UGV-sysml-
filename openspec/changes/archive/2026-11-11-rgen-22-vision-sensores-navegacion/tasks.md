# Tasks

## 1. Definición de nuevas cámaras, transductores y subpartes `camaras` y `sensores` en `Modelos/04_2_navegacion.sysml`

- [x] 1.1 Actualizar `CamarasOpticas360` (`RGEN-20`, `RGEN-22`) añadiendo `attribute visionProfundidad360 : Boolean;` y `port salidaVideoComms : DataBusPort;` y actualizando su `doc` para reflejar la visión de profundidad que permite el movimiento en 360°.
- [x] 1.2 Actualizar `CamaraTermicaNocturna` (`RGEN-22`) añadiendo `attribute identificaPuntosCalientes : Boolean;` y `port salidaVideoComms : DataBusPort;` y actualizando su `doc` para indicar expresamente que tiene como objetivo la visión nocturna e identificar puntos calientes.
- [x] 1.3 Definir `part def CamaraLateralImplementos` (`RGEN-22`) con `port puertoVideo : PuertoVideoOptico;` y `port salidaVideoComms : DataBusPort;` para las cámaras laterales independientes que proporcionan información de los implementos y visión lateral del estado del UGV.
- [x] 1.4 Definir `item def DatosEstadoRodaje` y `part def TransductoresContactoDinamicos` (`RGEN-22`) con `port salidaEstadoRodaje : DataBusPort;` para los sensores físicos de contacto y dinámicos que supervisan en tiempo real el estado del tren de rodaje.
- [x] 1.5 Definir `part def SubsistemaCamaras` (`RGEN-20`, `RGEN-22`) agrupando `part camarasOpticas360 : CamarasOpticas360`, `part camaraLateralIzquierda : CamaraLateralImplementos`, `part camaraLateralDerecha : CamaraLateralImplementos` y `part camaraTermicaNocturna : CamaraTermicaNocturna`, con sus puertos de contorno (`salidaOptica : PuertoVideoOptico`, `salidaTermica : PuertoVideoOptico` y `salidaVideoTeleoperacion : DataBusPort`) y sus conexiones internas.
- [x] 1.6 Definir `part def SubsistemaSensores` (`RGEN-09`, `RGEN-22`) agrupando `part sensoresLidar : SensorLidar`, `part sensoresRadar : SensorRadar` y `part transductoresRodaje : TransductoresContactoDinamicos`, con sus puertos de contorno (`salidaLidar : PuertoDatosLidar`, `salidaRadar : PuertoDatosRadar`, `controlModoDeteccion : DataBusPort` y `salidaEstadoRodaje : DataBusPort`) y sus conexiones internas.
- [x] 1.7 Actualizar `SistemaNavegacion` para instanciar `part camaras : SubsistemaCamaras` y `part sensores : SubsistemaSensores` (manteniendo `sistemaVisionComputador`, `moduloDeteccionEvasion` y `odometriaVisualInercialVIO` fuera de `camaras` y `sensores`), exponer `port salidaVideoTeleoperacion : DataBusPort` y `port salidaEstadoRodaje : DataBusPort`, actualizar las conexiones internas y definir `requirement def ReqConcienciaSituacionalVisionSensores` (`RGEN-22`).

## 2. Actualización de puertos e interconexiones con Comunicaciones en `Modelos/05_comunicaciones.sysml` y `Modelos/09_sistema_ugv.sysml`

- [x] 2.1 Añadir en `SistemaComunicacionesEmbarcado` (`Modelos/05_comunicaciones.sysml`) los puertos `port entradaVideoTeleoperacion : DataBusPort;` y `port entradaEstadoRodaje : DataBusPort;`.
- [x] 2.2 Añadir en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`) las conexiones `connection c_nav_video_comms connect navegacion.salidaVideoTeleoperacion to comunicaciones.entradaVideoTeleoperacion;` y `connection c_nav_rodaje_comms connect navegacion.salidaEstadoRodaje to comunicaciones.entradaEstadoRodaje;`, así como la relación `satisfy requirement : ReqConcienciaSituacionalVisionSensores by navegacion;`.

## 3. Actualización de vistas y validación con Spec42

- [x] 3.1 Actualizar `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` en `Modelos/11_vistas.sysml` para exponer `SistemaUGV::PlataformaUGV::c_nav_video_comms` y `SistemaUGV::PlataformaUGV::c_nav_rodaje_comms`, mostrando `camaras` y `sensores` anidadas dentro de `navegacion` sin exponerlas como raíces duplicadas (ajuste tras revisión del usuario; ver `design.md`, decisión 3).
- [x] 3.2 Ejecutar `spec42.exe check Modelos`, `spec42.exe diagram Modelos` y `openspec validate rgen-22-vision-sensores-navegacion` verificando 0 errores y 0 advertencias.
