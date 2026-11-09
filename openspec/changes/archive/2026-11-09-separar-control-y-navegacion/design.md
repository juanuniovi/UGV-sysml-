# Design

## Context

El usuario solicita un cambio arquitectónico estructural: dividir el actual subsistema unificado `SubsistemaNavegacionControl` (`Modelos/04_navegacion_control.sysml`) en dos subsistemas y archivos independientes:
- **4.1 Control** (`Modelos/04_1_control.sysml` → `package SubsistemaControl`, `part def SistemaControl`).
- **4.2 Navegación** (`Modelos/04_2_navegacion.sysml` → `package SubsistemaNavegacion`, `part def SistemaNavegacion`).
Eliminando por completo el archivo `Modelos/04_navegacion_control.sysml` y la parte `navegacionControl` en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`).

Asimismo, el usuario ha confirmado explícitamente:
1. Dos archivos separados (`Modelos/04_1_control.sysml` y `Modelos/04_2_navegacion.sysml`), eliminando `Modelos/04_navegacion_control.sysml`.
2. El reparto de componentes:
   - **4.1 Control**: `ComputadorAutonomia` + `ModuloFrenadoSeguridad`.
   - **4.2 Navegación**: Sensores (`SensorLidar`, `SensorRadar`, `SistemaVisionComputador`, `CamarasOpticas360`, `CamaraTermicaNocturna`) + `ModuloDeteccionEvasion` + `OdometriaVisualInercialVIO`.
3. La autorización explícita para actualizar el `subject`/`satisfy` de `ReqNavegacionGNSSDenegado` (`RNAV-01`) y `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) a las nuevas partes sin alterar el contenido normativo del requisito.

## Goals / Non-Goals

**Goals:**
- Crear `Modelos/04_1_control.sysml` (`package SubsistemaControl`) con `ComputadorAutonomia`, `ModuloFrenadoSeguridad`, `SistemaControl`, sus puertos, ítems/conexiones de control y acciones asociadas.
- Crear `Modelos/04_2_navegacion.sysml` (`package SubsistemaNavegacion`) con `SensorLidar`, `SensorRadar`, `SistemaVisionComputador`, `CamarasOpticas360`, `CamaraTermicaNocturna`, `ModuloDeteccionEvasion`, `OdometriaVisualInercialVIO`, `SistemaNavegacion`, sus puertos, ítems/conexiones sensoriales, acciones de detección y los requisitos `RNAV-01` y `RGEN-09`.
- Eliminar `Modelos/04_navegacion_control.sysml`.
- Actualizar `Modelos/09_sistema_ugv.sysml` (`PlataformaUGV` y `SistemaUGVPesadoDual`) para sustituir `navegacionControl` por `control : SistemaControl` y `navegacion : SistemaNavegacion`, conectándolos entre sí y con el resto de la plataforma.
- Actualizar `Modelos/11_vistas.sysml` para exponer `SubsistemaControl` y `SubsistemaNavegacion` en `vistaRequisitos` y ofrecer vistas `GeneralView` e `InterconnectionView` independientes para 4.1 Control y 4.2 Navegación.

**Non-Goals:**
- Modificar el contenido técnico de los requisitos del pliego (`RNAV-01`, `RGEN-09`, `ROPE-05`, `ROPE-06`, `RGEN-17`, `RGEN-20`, `RGEN-22`).
- Alterar los demás subsistemas (`01_barcaza`, `02_tren_rodaje`, `03_planta_motriz`, `05_comunicaciones`, `06_estaciones_control`, `07_uav_cenital`, `08_cargas_pago`, `10_comportamiento`).

## Decisions

1. **Tipos e interfaces compartidas entre `04_1_control.sysml` y `04_2_navegacion.sysml`**:
   - *Decisión*: Definir en `TiposBase` (`Modelos/00_tipos_base.sysml`) o compartir mediante `private import` entre `SubsistemaNavegacion` y `SubsistemaControl` la enumeración `ModoDeteccionObstaculos` (`NORMAL`, `SIGILOSO`), los ítems de interfaz entre ambos (`MapaObstaculosDetectados`, `ComandoModoDeteccion`) y los puertos de frontera entre Navegación y Control (`PuertoMapaObstaculos`, `PuertoOdometriaVIO`, `PuertoComandoModoDeteccion`). En concreto, definir `ModoDeteccionObstaculos`, `MapaObstaculosDetectados`, `ComandoModoDeteccion`, `PuertoMapaObstaculos`, `PuertoOdometriaVIO` y `PuertoComandoModoDeteccion` en `SubsistemaNavegacion` (o en `00_tipos_base.sysml`) e importarlos con `private import` evita cualquier dependencia circular y mantiene limpia la separación entre `04_1_control.sysml` y `04_2_navegacion.sysml`.
   - *Alternativa óptima sin tocar `00_tipos_base.sysml`*: `SubsistemaControl` define `ModoDeteccionObstaculos`, `ComandoModoDeteccion`, `PuertoComandoModoDeteccion`, `ConsignaNavegacionAutonoma`, `PuertoConsignaAutonomia`, `MapaObstaculosDetectados`, `PuertoMapaObstaculos` y `PuertoOdometriaVIO` (o `SubsistemaControl` importa `SubsistemaNavegacion` / viceversa en un solo sentido). Si `SubsistemaControl` importa `SubsistemaNavegacion::*` (unidireccional: `04_2_navegacion.sysml` no importa `04_1_control.sysml`), todos los tipos sensoriales y de modo residen en `SubsistemaNavegacion` y `SubsistemaControl` los reutiliza mediante `private import SubsistemaNavegacion::*;` sin ciclos ni duplicación.

2. **Arquitectura interna de `SubsistemaControl` (`Modelos/04_1_control.sysml`)**:
   - *Partes internas de `SistemaControl`*:
     - `computadorAutonomia : ComputadorAutonomia`
     - `moduloFrenadoSeguridad : ModuloFrenadoSeguridad`
   - *Puertos de contorno de `SistemaControl`*:
     - `chassisMount : MechanicalMountPort`
     - `powerInput : ElectricalPowerPort`
     - `dataBus : DataBusPort`
     - `driveByWireOutput : DataBusPort`
     - `entradaObstaculos : ~PuertoMapaObstaculos`
     - `entradaOdometria : ~PuertoOdometriaVIO`
   - *Conexiones internas de `SistemaControl`*:
     - `connection c_bus_comunicaciones connect dataBus to computadorAutonomia.busComunicaciones;`
     - `binding c_entrada_obstaculos bind entradaObstaculos = computadorAutonomia.entradaObstaculos;`
     - `binding c_entrada_vio bind entradaOdometria = computadorAutonomia.entradaOdometria;`
     - `connection c_autonomia_frenado connect computadorAutonomia.salidaConsigna to moduloFrenadoSeguridad.entradaConsigna;`
     - `connection c_frenado_dbw connect moduloFrenadoSeguridad.salidaActuacion to driveByWireOutput;`

3. **Arquitectura interna de `SubsistemaNavegacion` (`Modelos/04_2_navegacion.sysml`) y puerto en `SubsistemaComunicaciones` (`Modelos/05_comunicaciones.sysml`)**:
   - *Puerto simple en `SistemaComunicacionesEmbarcado`*:
     - `port salidaModoDeteccion : DataBusPort;`
   - *Partes internas de `SistemaNavegacion`*:
     - `sensoresLidar : SensorLidar` (con `port controlModoDeteccion : DataBusPort;` para su apagado/encendido)
     - `sensoresRadar : SensorRadar` (con `port controlModoDeteccion : DataBusPort;` para su apagado/encendido)
     - `sistemaVisionComputador : SistemaVisionComputador`
     - `camarasOpticas360 : CamarasOpticas360`
     - `camaraTermicaNocturna : CamaraTermicaNocturna`
     - `moduloDeteccionEvasion : ModuloDeteccionEvasion`
     - `odometriaVisualInercialVIO : OdometriaVisualInercialVIO`
   - *Puertos de contorno de `SistemaNavegacion`*:
     - `chassisMount : MechanicalMountPort`
     - `powerInput : ElectricalPowerPort`
     - `salidaObstaculos : PuertoMapaObstaculos`
     - `salidaOdometria : PuertoOdometriaVIO`
     - `entradaModoDeteccion : DataBusPort`
   - *Conexiones internas de `SistemaNavegacion`*:
     - `connection c_lidar_deteccion connect sensoresLidar.puertoLidar to moduloDeteccionEvasion.entradaLidar;`
     - `connection c_radar_deteccion connect sensoresRadar.puertoRadar to moduloDeteccionEvasion.entradaRadar;`
     - `connection c_vision_deteccion connect sistemaVisionComputador.puertoVision to moduloDeteccionEvasion.entradaVision;`
     - `connection c_camaras360_vision connect camarasOpticas360.puertoVideo to sistemaVisionComputador.entradaOptica;`
     - `connection c_termica_vision connect camaraTermicaNocturna.puertoVideo to sistemaVisionComputador.entradaTermica;`
     - `connection c_modo_lidar connect entradaModoDeteccion to sensoresLidar.controlModoDeteccion;`
     - `connection c_modo_radar connect entradaModoDeteccion to sensoresRadar.controlModoDeteccion;`
     - `binding c_salida_obstaculos_interno bind moduloDeteccionEvasion.salidaObstaculos = salidaObstaculos;`
     - `binding c_salida_vio_interno bind odometriaVisualInercialVIO.puertoOdometria = salidaOdometria;`

4. **Integración en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`)**:
   - Se elimina `part navegacionControl : SistemaNavegacionControl;` y se declaran:
     - `part control : SistemaControl;`
     - `part navegacion : SistemaNavegacion;`
   - Conexiones estructurales y de potencia para ambos subsistemas:
     - `c_barcaza_control` (`barcaza.avionicaMount` → `control.chassisMount`) y `c_barcaza_navegacion` (`barcaza.avionicaMount` → `navegacion.chassisMount`).
     - `c_power_control` (`plantaMotriz.powerOutputAvionics` → `control.powerInput`) y `c_power_navegacion` (`plantaMotriz.powerOutputAvionics` → `navegacion.powerInput`).
   - Conexiones de bus y actuación hacia `control`:
     - `c_bus_comms_control` (`comunicaciones.dataBus` → `control.dataBus`)
     - `c_drive_by_wire` (`control.driveByWireOutput` → `rodaje.controlBus`)
     - `c_pms_control` (`control.dataBus` → `plantaMotriz.controlBus`)
     - En `SistemaUGVPesadoDual`: `c_payload_data` (`vehiculo.control.dataBus` → `cargaPagoMision.dataBus`)
   - Conexión desde `comunicaciones` hacia `navegacion` para apagar LiDAR y radar (`RGEN-09`) y conexiones directas de `navegacion` a `control`:
     - `connection c_comms_modo_nav connect comunicaciones.salidaModoDeteccion to navegacion.entradaModoDeteccion;`
     - `connection c_nav_obstaculos_ctrl connect navegacion.salidaObstaculos to control.entradaObstaculos;`
     - `connection c_nav_vio_ctrl connect navegacion.salidaOdometria to control.entradaOdometria;`

5. **Vistas conjuntas en `Modelos/11_vistas.sysml`**:
   - Actualizar `vistaRequisitos` para exponer `SubsistemaControl::*` y `SubsistemaNavegacion::*`.
   - Mantener `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView` exponiendo conjuntamente `SubsistemaControl` y `SubsistemaNavegacion` (así como las partes `control` y `navegacion` y las conexiones entre ellas) para representar ambas partes relacionadas en una sola vista.

## Risks / Trade-offs

- **[Risk] Referencias residuales a `SubsistemaNavegacionControl` o `navegacionControl`** → **Mitigation**: Revisar todas las importaciones en `Modelos/*.sysml` y validar con `spec42.exe check Modelos` y `spec42.exe diagram Modelos` que existen 0 errores y 0 advertencias.
