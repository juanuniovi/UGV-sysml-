# Tasks

## 1. Definición de ítems, puertos y subsistemas internos de `ComputadorAutonomia` (`Modelos/04_1_control.sysml`)

- [x] 1.1 Declarar en `SubsistemaControl` (`Modelos/04_1_control.sysml`) los ítems `item def MapaEstadoUnificado`, `item def LatidoSaludAutonomia` e `item def ConsignaFrenado`, y los puertos `port def PuertoMapaEstadoUnificado`, `port def PuertoLatidoSalud` y actualizar `PuertoConsignaAutonomia` para incluir `out item consignaFrenado : ConsignaFrenado;`.
- [x] 1.2 Definir en `SubsistemaControl` los bloques `part def SubsistemaFusionEstado`, `part def SubsistemaPlanificacionEvaluacion` y `part def SupervisorSeguridad` con sus puertos tipados.
- [x] 1.3 Instanciar dentro de `part def ComputadorAutonomia` las partes `subsistemaFusionEstado`, `subsistemaPlanificacionEvaluacion` y `supervisorSeguridad`, y establecer los `binding`s con los puertos de contorno (`entradaObstaculos`, `entradaOdometria`, `busComunicaciones`, `salidaConsigna`) y las conexiones internas (`c_fusion_planificacion`, `c_planificacion_watchdog`).
- [x] 1.4 Actualizar `Modelos/11_vistas.sysml` para añadir `expose SubsistemaControl::SistemaControl::computadorAutonomia;` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`, mostrando el interior de `computadorAutonomia` en ambas vistas.

## 2. Verificación con Spec42

- [x] 2.1 Ejecutar `spec42.exe check Modelos` y `spec42.exe diagram Modelos --view "VistasUGV::vistaConexionesNavegacionControl"` para verificar que existen 0 errores y 0 advertencias y que las tres partes internas de `computadorAutonomia` y sus conexiones se renderizan correctamente.
