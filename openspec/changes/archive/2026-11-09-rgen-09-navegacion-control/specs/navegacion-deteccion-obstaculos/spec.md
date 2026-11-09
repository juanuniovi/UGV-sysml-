# Spec Delta

## Purpose

Especifica la arquitectura interna de partes, puertos con flujo de ítems, conexiones y acciones del subsistema de Navegación y Control (`SubsistemaNavegacionControl`) para detectar obstáculos estáticos y dinámicos mediante sensores radiantes (LiDAR, radar) y no radiantes (visión por computador), su conmutación entre los modos `NORMAL` y `SIGILOSO` desde los Equipos de Control (`RGEN-09`) y sus vistas arquitectónicas dedicadas.

## ADDED Requirements

### Requirement: Partes tipadas de sensores y computación en Navegación y Control (RGEN-09)
El paquete `SubsistemaNavegacionControl` SHALL definir bloques tipados (`part def`) para los sensores radiantes (`SensorLidar`, `SensorRadar`), el sistema no radiante (`SistemaVisionComputador`), el módulo de detección y evasión (`ModuloDeteccionEvasion`) y el computador de autonomía (`ComputadorAutonomia`), instanciándolos dentro de `SistemaNavegacionControl`.

#### Scenario: Instanciación de partes tipadas dentro de SistemaNavegacionControl
- **WHEN** se inspecciona la estructura de `SistemaNavegacionControl`
- **THEN** las partes `sensoresLidar`, `sensoresRadar`, `sistemaVisionComputador`, `moduloDeteccionEvasion` y `computadorAutonomia` están tipadas por sus respectivas definiciones `part def` y exponen puertos de datos y control

### Requirement: Puertos con flujo de ítems e interconexiones internas en Navegación y Control (RGEN-09)
El subsistema `SistemaNavegacionControl` SHALL definir puertos (`port def`) que transporten como `item`s los datos sensoriales (`DatosLidar`, `DatosRadar`, `DatosVisionComputador`), el mapa de obstáculos (`MapaObstaculosDetectados`), el control de emisión radiante (`ControlEmisionRadiante`) y el comando de modo (`ComandoModoDeteccion`), conectando mediante `connection` los sensores con el módulo de detección/evasión y el computador de autonomía.

#### Scenario: Conexión de sensores LiDAR, radar y visión por computador al módulo de detección
- **WHEN** se evalúan las conexiones internas de `SistemaNavegacionControl`
- **THEN** existen conexiones explícitas entre `sensoresLidar.puertoLidar` y `moduloDeteccionEvasion.entradaLidar`, entre `sensoresRadar.puertoRadar` y `moduloDeteccionEvasion.entradaRadar`, y entre `sistemaVisionComputador.puertoVision` y `moduloDeteccionEvasion.entradaVision`

#### Scenario: Conexión entre módulo de detección, computador de autonomía y buses del UGV
- **WHEN** el módulo de detección procesa los obstáculos y recibe órdenes de modo desde los equipos de control a través del bus de datos (`dataBus`)
- **THEN** `moduloDeteccionEvasion.salidaObstaculos` se conecta a `computadorAutonomia.entradaObstaculos`, `computadorAutonomia.salidaModoDeteccion` se conecta a `moduloDeteccionEvasion.entradaModoDeteccion`, y `computadorAutonomia` se enlaza con `dataBus` y `driveByWireOutput`

### Requirement: Conmutación de modo de detección NORMAL y SIGILOSO desde Equipos de Control (RGEN-09)
El sistema UGV MUST encontrarse siempre en uno de los modos de detección `NORMAL` o `SIGILOSO`, permitiendo cambiar de modo desde todos los Equipos de Control (`PuestoMandoPortable` y `ConsolaPortableCPT`) para activar o desactivar las tecnologías radiantes (`sensoresLidar` y `sensoresRadar`).

#### Scenario: Cambio de modo de detección desde los Equipos de Control
- **WHEN** un operador en `PuestoMandoPortable` o `ConsolaPortableCPT` selecciona el modo `SIGILOSO` o `NORMAL`
- **THEN** la orden se transmite por el enlace RF y el bus de datos hasta `SistemaNavegacionControl`, donde se activa o desactiva la emisión radiante de `sensoresLidar` y `sensoresRadar` mediante `ControlEmisionRadiante`

### Requirement: Vistas dedicadas de estructura e interconexiones de Navegación y Control
El paquete `VistasUGV` en `Modelos/11_vistas.sysml` SHALL incluir una vista estructural (`vistaEstructuraNavegacionControl : GeneralView`) y una vista de interconexiones (`vistaConexionesNavegacionControl : InterconnectionView`) enfocadas exclusivamente en `SubsistemaNavegacionControl`.

#### Scenario: Visualización de partes, puertos y conexiones internas en Spec42
- **WHEN** se renderizan `VistasUGV::vistaEstructuraNavegacionControl` y `VistasUGV::vistaConexionesNavegacionControl` en Spec42
- **THEN** se muestran los bloques de LiDAR, radar, visión por computador, detección/evasión y computador de autonomía junto con sus puertos e interconexiones internas
