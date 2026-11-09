# Tasks

## 1. Definición de enumeraciones, ítems y puertos con flujo de datos en `04_navegacion_control.sysml`

- [x] 1.1 Definir en `SubsistemaNavegacionControl` la enumeración `enum def ModoDeteccionObstaculos` (`NORMAL`, `SIGILOSO`) y los ítems `DatosLidar`, `DatosRadar`, `DatosVisionComputador`, `MapaObstaculosDetectados`, `ComandoModoDeteccion`, `ControlEmisionRadiante` y `ConsignaNavegacionAutonoma`.
- [x] 1.2 Definir en `SubsistemaNavegacionControl` los puertos tipados (`port def`) que transportan dichos ítems: `PuertoDatosLidar`, `PuertoDatosRadar`, `PuertoDatosVision`, `PuertoVideoOptico`, `PuertoOdometriaVIO`, `PuertoMapaObstaculos`, `PuertoComandoModoDeteccion` y `PuertoConsignaAutonomia`.

## 2. Definición de partes (`part def`) e interconexiones internas en `SistemaNavegacionControl`

- [x] 2.1 Definir en `SubsistemaNavegacionControl` los bloques `part def SensorLidar`, `part def SensorRadar`, `part def SistemaVisionComputador`, `part def CamarasOpticas360`, `part def CamaraTermicaNocturna`, `part def OdometriaVisualInercialVIO`, `part def ModuloDeteccionEvasion`, `part def ComputadorAutonomia` y `part def ModuloFrenadoSeguridad` con sus respectivos puertos.
- [x] 2.2 Tipar las partes internas de `part def SistemaNavegacionControl` (`sensoresLidar : SensorLidar`, `sensoresRadar : SensorRadar`, `sistemaVisionComputador : SistemaVisionComputador`, `moduloDeteccionEvasion : ModuloDeteccionEvasion`, `computadorAutonomia : ComputadorAutonomia`, etc.) y declarar todas las conexiones internas (`connection ... connect ... to ...`) entre sensores, detección/evasión, computador de autonomía, frenado y los puertos externos `dataBus` y `driveByWireOutput`.
- [x] 2.3 Mantener las acciones `ConfigurarModoDeteccion`, `DetectarObstaculosNavegacion` y `NavegarAutonomamenteConDeteccion` y los requisitos `ReqNavegacionGNSSDenegado` (`RNAV-01`) y `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) con su relación `satisfy`.

## 3. Relación con Equipos de Control (`06_estaciones_control.sysml`) y Vistas (`11_vistas.sysml`)

- [x] 3.1 Añadir en `Modelos/06_estaciones_control.sysml` (`PuestoMandoPortable` y `ConsolaPortableCPT`) la parte `selectorModoDeteccionSigiloso` para reflejar el cambio entre modo `NORMAL` y `SIGILOSO` desde todos los Equipos de Control (`RGEN-09`).
- [x] 3.2 Definir en `Modelos/11_vistas.sysml` (`package VistasUGV`) las vistas `vistaEstructuraNavegacionControl : GeneralView` (BDD) y `vistaConexionesNavegacionControl : InterconnectionView` (IBD de conexiones internas de `SistemaNavegacionControl`).

## 4. Verificación y validación con Spec42

- [x] 4.1 Ejecutar `spec42.exe check Modelos` para verificar que los 12 documentos `.sysml` compilan con 0 errores y 0 advertencias.
- [x] 4.2 Ejecutar `spec42.exe diagram Modelos` para comprobar el renderizado de `VistasUGV::vistaEstructuraNavegacionControl` y `VistasUGV::vistaConexionesNavegacionControl` junto con el resto de vistas del sistema.
