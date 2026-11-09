# Tasks

## 1. Creación del Subsistema 4.2 de Navegación (`Modelos/04_2_navegacion.sysml`)

- [x] 1.1 Crear `Modelos/04_2_navegacion.sysml` con `package SubsistemaNavegacion`, declarando la enumeración `ModoDeteccionObstaculos` (`NORMAL`, `SIGILOSO`), los ítems sensoriales y de interfaz (`DatosLidar`, `DatosRadar`, `DatosVisionComputador`, `MapaObstaculosDetectados`, `ComandoModoDeteccion`, `ControlEmisionRadiante`) y los puertos tipados (`PuertoDatosLidar`, `PuertoDatosRadar`, `PuertoDatosVision`, `PuertoVideoOptico`, `PuertoOdometriaVIO`, `PuertoMapaObstaculos`, `PuertoComandoModoDeteccion`).
- [x] 1.2 Definir en `SubsistemaNavegacion` los bloques `part def SensorLidar`, `part def SensorRadar`, `part def SistemaVisionComputador`, `part def CamarasOpticas360`, `part def CamaraTermicaNocturna`, `part def OdometriaVisualInercialVIO` y `part def ModuloDeteccionEvasion` con sus respectivos puertos.
- [x] 1.3 Definir el bloque principal `part def SistemaNavegacion` (e instancia `subsistemaNavegacion : SistemaNavegacion`) con sus partes internas, sus puertos de contorno (`chassisMount`, `powerInput`, `salidaObstaculos`, `salidaOdometria`, `entradaModoDeteccion`), todas las conexiones internas (`connection ... connect ... to ...`), las acciones `ConfigurarModoDeteccion` y `DetectarObstaculosNavegacion`, y los requisitos `ReqNavegacionGNSSDenegado` (`RNAV-01`) y `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) con su relación `satisfy`.

## 2. Creación del Subsistema 4.1 de Control (`Modelos/04_1_control.sysml`) y eliminación de `04_navegacion_control.sysml`

- [x] 2.1 Crear `Modelos/04_1_control.sysml` con `package SubsistemaControl` (`private import SubsistemaNavegacion::*;`), definiendo `item def ConsignaNavegacionAutonoma`, `port def PuertoConsignaAutonomia`, `part def ComputadorAutonomia` y `part def ModuloFrenadoSeguridad`.
- [x] 2.2 Definir el bloque principal `part def SistemaControl` (e instancia `subsistemaControl : SistemaControl`) con las partes `computadorAutonomia : ComputadorAutonomia` y `moduloFrenadoSeguridad : ModuloFrenadoSeguridad`, sus puertos de contorno (`chassisMount`, `powerInput`, `dataBus`, `driveByWireOutput`, `entradaObstaculos`, `entradaOdometria`, `salidaModoDeteccion`), sus conexiones internas y la acción de control `GenerarControlAutonomo`.
- [x] 2.3 Eliminar el archivo antiguo `Modelos/04_navegacion_control.sysml`.

## 3. Integración en `Modelos/09_sistema_ugv.sysml` y actualización de vistas en `Modelos/11_vistas.sysml`

- [x] 3.1 Actualizar `Modelos/09_sistema_ugv.sysml` para importar `SubsistemaControl::*` y `SubsistemaNavegacion::*`, reemplazar `part navegacionControl : SistemaNavegacionControl` por `part control : SistemaControl` y `part navegacion : SistemaNavegacion`, y declarar las conexiones entre `control`, `navegacion`, `barcaza`, `plantaMotriz`, `comunicaciones`, `rodaje` y `cargaPagoMision`.
- [x] 3.2 Actualizar `Modelos/11_vistas.sysml` para importar y exponer `SubsistemaControl` y `SubsistemaNavegacion` en `vistaRequisitos`, y definir una vista conjunta de estructura (`vistaEstructuraNavegacionControl`) y una vista conjunta de interconexiones (`vistaConexionesNavegacionControl`) donde estén representadas las dos partes (`SistemaControl` y `SistemaNavegacion`).

## 4. Verificación y validación con Spec42

- [x] 4.1 Ejecutar `spec42.exe check Modelos` para verificar que todos los archivos `.sysml` compilan con 0 errores y 0 advertencias.
- [x] 4.2 Ejecutar `spec42.exe diagram Modelos` para comprobar el renderizado de todas las vistas (`vistaEstructuraPlataforma`, `vistaConexionesPlataforma`, `vistaRequisitos`, `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`).

## 5. Ajuste del comando de modo sigiloso desde Comunicaciones hacia LiDAR y Radar (`RGEN-09`)

- [x] 5.1 Añadir en `Modelos/05_comunicaciones.sysml` (`SistemaComunicacionesEmbarcado`) el puerto simple `salidaModoDeteccion : DataBusPort` y retirar `salidaModoDeteccion` de `ComputadorAutonomia` y `SistemaControl` en `Modelos/04_1_control.sysml`.
- [x] 5.2 Actualizar `Modelos/04_2_navegacion.sysml` para que `entradaModoDeteccion : DataBusPort` en `SistemaNavegacion` se conecte directamente con `sensoresLidar` y `sensoresRadar` (`controlModoDeteccion : DataBusPort`), ejecutando su apagado/encendido sin pasar por `ComputadorAutonomia` ni `ModuloDeteccionEvasion`.
- [x] 5.3 Actualizar `Modelos/09_sistema_ugv.sysml` y `Modelos/11_vistas.sysml` reemplazando `c_ctrl_modo_nav` por la conexión `c_comms_modo_nav` entre `comunicaciones.salidaModoDeteccion` y `navegacion.entradaModoDeteccion`, y revalidar con `spec42`.
