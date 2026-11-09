# Proposal

## Why

El requisito **RGEN-09** del pliego técnico establece que el UGV llevará incorporado un sistema de detección de obstáculos estáticos y dinámicos basado en tecnologías radiantes (LiDAR, radar) y no radiantes (visión por computador), pudiendo activar o desactivar las tecnologías radiantes para conmutar entre los modos de detección `NORMAL` y `SIGILOSO` desde todos los Equipos de Control y en cualquiera de los Modos de Operación. Actualmente, `Modelos/04_navegacion_control.sysml` declara partes sin tipos (`part def`), sin puertos tipados mediante `item`s de datos, y sin conexiones internas (`connection ... connect ... to ...`) que modelen cómo el LiDAR, el radar y la visión por computador entregan su información al módulo de detección/evasión y al computador de navegación autónoma, ni cómo se relacionan con los equipos de control y vistas arquitectónicas.

## What Changes

- Modelar en `Modelos/04_navegacion_control.sysml` (`package SubsistemaNavegacionControl`):
  - **Enumeración (`enum def`)**: `ModoDeteccionObstaculos` (`NORMAL`, `SIGILOSO`).
  - **Ítems de flujo (`item def`)**:
    - `DatosLidar`: nube de puntos y distancias de sensores LiDAR (tecnología radiante).
    - `DatosRadar`: ecos de distancia y velocidad radial de sensores radar (tecnología radiante).
    - `DatosVisionComputador`: detección pasiva e imágenes procesadas por visión por computador (tecnología no radiante).
    - `MapaObstaculosDetectados`: obstáculos estáticos y dinámicos fusionados para navegación autónoma.
    - `ComandoModoDeteccion`: orden de conmutación entre modo `NORMAL` y `SIGILOSO` desde los Equipos de Control.
    - `ControlEmisionRadiante`: señal de activación/desactivación de emisión hacia los sensores radiantes (LiDAR y radar).
    - `ConsignaNavegacionAutonoma`: consignas de guiado y control hacia el tren de rodaje (`driveByWireOutput`) y frenado de seguridad.
  - **Definiciones de puertos (`port def`) basados en `item`s**:
    - `PuertoDatosLidar`, `PuertoDatosRadar`, `PuertoDatosVision`, `PuertoMapaObstaculos`, `PuertoComandoModoDeteccion`, `PuertoConsignaAutonomia`.
  - **Definiciones de partes (`part def`) con sus puertos**:
    - `SensorLidar` (`sensoresLidar`), `SensorRadar` (`sensoresRadar`), `SistemaVisionComputador` (`sistemaVisionComputador`), `ModuloDeteccionEvasion` (`moduloDeteccionEvasion`), `ComputadorAutonomia` (`computadorAutonomia`), además de tipar `OdometriaVisualInercialVIO`, `ModuloFrenadoSeguridad`, `CamarasOpticas360` y `CamaraTermicaNocturna`.
  - **Conexiones internas (`connection ... connect ... to ...`) en `SistemaNavegacionControl`**:
    - Conexiones desde `sensoresLidar`, `sensoresRadar` y `sistemaVisionComputador` hacia `moduloDeteccionEvasion` transportando `DatosLidar`, `DatosRadar`, `DatosVisionComputador` y `ControlEmisionRadiante`.
    - Conexión de `moduloDeteccionEvasion` a `computadorAutonomia` transportando `MapaObstaculosDetectados`.
    - Conexión de `computadorAutonomia` a `moduloDeteccionEvasion` transportando `ComandoModoDeteccion`.
    - Conexiones internas con cámaras ópticas/térmicas, odometría VIO, módulo de frenado y los puertos externos `dataBus` (hacia Comunicaciones / Equipos de Control) y `driveByWireOutput` (hacia Tren de Rodaje).
  - **Acciones (`action def`) y Requisito (`requirement def` / `satisfy`)**:
    - Acciones `ConfigurarModoDeteccion`, `DetectarObstaculosNavegacion` y `NavegarAutonomamenteConDeteccion`.
    - Requisito `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) y su relación `satisfy`, preservando intacto `ReqNavegacionGNSSDenegado` (`RNAV-01`).
- Actualizar `Modelos/06_estaciones_control.sysml` (`package SubsistemaEstacionesControl`) para reflejar en `PuestoMandoPortable` y `ConsolaPortableCPT` el mando de selección del modo de detección (`NORMAL` / `SIGILOSO`, `RGEN-09`) sin alterar ningún elemento existente.
- Añadir en `Modelos/11_vistas.sysml` (`package VistasUGV`) dos vistas dedicadas para Navegación y Control:
  - `vistaEstructuraNavegacionControl : GeneralView` (BDD de partes, puertos, ítems y requisitos de `SubsistemaNavegacionControl`).
  - `vistaConexionesNavegacionControl : InterconnectionView` (IBD de las partes internas, puertos e interconexiones dentro de `SistemaNavegacionControl`).

## Capabilities

### New Capabilities
- `navegacion-deteccion-obstaculos`: Arquitectura interna de Navegación y Control (`SubsistemaNavegacionControl`) para detección de obstáculos estáticos y dinámicos (`RGEN-09`), incluyendo `part def`s de LiDAR, radar, visión por computador, módulo de detección/evasión y computador de autonomía, `port def`s con flujo de `item`s, conexiones internas (`connection`), integración con estaciones de control y vistas dedicadas (`GeneralView` e `InterconnectionView`).

### Modified Capabilities
<!-- Ninguna capacidad existente se modifica. -->

## Impact

- **Archivos afectados**:
  - `Modelos/04_navegacion_control.sysml` (definición de ítems, puertos, `part def`s, conexiones internas, acciones y requisito `RGEN-09`).
  - `Modelos/06_estaciones_control.sysml` (incorporación aditiva del selector de modo de detección `NORMAL`/`SIGILOSO` en PMP y CPT según `RGEN-09`).
  - `Modelos/11_vistas.sysml` (vistas `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`).
- **Subsistemas afectados**:
  - `SubsistemaNavegacionControl`, `SubsistemaEstacionesControl` y `VistasUGV`.
  - Compatibilidad preservada al 100% con `Modelos/09_sistema_ugv.sysml` (se conservan intactos los puertos `chassisMount`, `powerInput`, `dataBus` y `driveByWireOutput` de `SistemaNavegacionControl` y los puertos `rfPortBLOS` / `rfPortLOS` de las estaciones de control).
- **Requisitos del pliego relacionados**:
  - `RGEN-09` (nuevo requisito formalizado), `ROPE-05`, `ROPE-06`, `RNAV-01`, `RGEN-17`, `RGEN-20`, `RGEN-22` (conservados íntegramente sin modificación).
