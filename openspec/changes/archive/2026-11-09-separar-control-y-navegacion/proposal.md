# Proposal

## Why

Actualmente, las capacidades de **Control** (computador de autonomía/guiado, gestión de modos y frenado de seguridad hacia *drive-by-wire*) y de **Navegación** (sensores radiantes LiDAR y radar, visión por computador, cámaras ópticas/térmicas, fusión/detección de obstáculos y odometría VIO) están acopladas en un único archivo y bloque monolítico (`Modelos/04_navegacion_control.sysml` / `SistemaNavegacionControl`). Separar **4.1 Control** y **4.2 Navegación** en dos subsistemas y archivos independientes (`Modelos/04_1_control.sysml` y `Modelos/04_2_navegacion.sysml`), eliminando `navegacionControl`, permite desacoplar claramente la percepción/posicionamiento de la lógica de mando/actuación, haciendo explícitos los flujos de interfaz entre ambos a nivel de `PlataformaUGV`.

## What Changes

- **BREAKING**: Eliminar `Modelos/04_navegacion_control.sysml` (`package SubsistemaNavegacionControl`, `part def SistemaNavegacionControl` y `part navegacionControl` en `PlataformaUGV`).
- Crear `Modelos/04_1_control.sysml` (`package SubsistemaControl` y `part def SistemaControl` / `part subsistemaControl : SistemaControl`):
  - **Partes internas**:
    - `computadorAutonomia : ComputadorAutonomia` (waypoints y Follow-Me `ROPE-05` a partir del mapa de obstáculos, odometría y comandos de misión).
    - `moduloFrenadoSeguridad : ModuloFrenadoSeguridad` (frenado automático de emergencia con override manual `RGEN-17`).
  - **Puertos de contorno de `SistemaControl`**:
    - Montaje y energía: `chassisMount : MechanicalMountPort`, `powerInput : ElectricalPowerPort`.
    - Buses de plataforma: `dataBus : DataBusPort` (hacia Comunicaciones, Planta Motriz y Carga de Pago) y `driveByWireOutput : DataBusPort` (hacia Tren de Rodaje).
    - Interfaz con `SistemaNavegacion`: `entradaObstaculos : ~PuertoMapaObstaculos` y `entradaOdometria : ~PuertoOdometriaVIO`.
  - **Conexiones internas y acciones de control**: enlace de `dataBus`, `entradaObstaculos` y `entradaOdometria` con `computadorAutonomia`, y de `computadorAutonomia.salidaConsigna` con `moduloFrenadoSeguridad.entradaConsigna` hacia `driveByWireOutput`.
- Crear `Modelos/04_2_navegacion.sysml` (`package SubsistemaNavegacion` y `part def SistemaNavegacion` / `part subsistemaNavegacion : SistemaNavegacion`):
  - **Partes internas**:
    - Sensores radiantes (`RGEN-09`): `sensoresLidar : SensorLidar`, `sensoresRadar : SensorRadar` (con puerto de apagado/control de modo sigiloso).
    - Sensores no radiantes (`RGEN-09`, `RGEN-20`, `RGEN-22`): `sistemaVisionComputador : SistemaVisionComputador`, `camarasOpticas360 : CamarasOpticas360`, `camaraTermicaNocturna : CamaraTermicaNocturna`.
    - Fusión y posicionamiento (`RGEN-09`, `ROPE-06`, `RNAV-01`): `moduloDeteccionEvasion : ModuloDeteccionEvasion`, `odometriaVisualInercialVIO : OdometriaVisualInercialVIO`.
  - **Puertos de contorno de `SistemaNavegacion`**:
    - Montaje y energía: `chassisMount : MechanicalMountPort`, `powerInput : ElectricalPowerPort`.
    - Interfaz con `SistemaControl`: `salidaObstaculos : PuertoMapaObstaculos` y `salidaOdometria : PuertoOdometriaVIO`.
    - Interfaz con `SistemaComunicacionesEmbarcado` (`RGEN-09`): `entradaModoDeteccion : DataBusPort` conectado internamente a `sensoresLidar` y `sensoresRadar` para ejecutar el apagado/encendido de ambos desde la orden recibida por Comunicaciones.
  - **Conexiones internas y acciones de navegación/detección**: conexiones entre LiDAR, radar, cámaras 360/térmica y visión por computador hacia `moduloDeteccionEvasion`, conexión de `entradaModoDeteccion` hacia `sensoresLidar` y `sensoresRadar`, y exposición de `salidaObstaculos` y `salidaOdometria` en el contorno de `SistemaNavegacion`.
- Añadir en `Modelos/05_comunicaciones.sysml` (`SistemaComunicacionesEmbarcado`) un puerto simple `salidaModoDeteccion : DataBusPort` para encaminar hacia `navegacion` la orden de apagado de LiDAR y radar en modo sigiloso (`RGEN-09`).
- Actualizar `Modelos/09_sistema_ugv.sysml` (`package SistemaUGV`):
  - Sustituir `private import SubsistemaNavegacionControl::*;` por `private import SubsistemaControl::*;` y `private import SubsistemaNavegacion::*;`.
  - En `PlataformaUGV`, reemplazar `part navegacionControl : SistemaNavegacionControl;` por `part control : SistemaControl;` y `part navegacion : SistemaNavegacion;`.
  - Conectar `control` y `navegacion` a la barcaza (`avionicaMount`), planta motriz (`powerOutputAvionics`), comunicaciones (`dataBus` hacia `control` y `salidaModoDeteccion` hacia `navegacion.entradaModoDeteccion`), tren de rodaje (`driveByWireOutput`), carga de pago (`c_payload_data`) y entre sí (`c_nav_obstaculos_ctrl`, `c_nav_vio_ctrl`).
- Actualizar `Modelos/11_vistas.sysml` (`package VistasUGV`):
  - Reemplazar la importación y exposición de `SubsistemaNavegacionControl` por `SubsistemaControl` y `SubsistemaNavegacion` en `vistaRequisitos`.
  - Mantener vistas conjuntas `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView` en las que estén representadas juntas ambas partes (**4.1 Control** y **4.2 Navegación**) y su relación directa.
- **Autorización explícita sobre requisitos existentes**:
  - El usuario ha autorizado explícitamente reasignar el `subject` y las relaciones `satisfy` de `ReqNavegacionGNSSDenegado` (`RNAV-01`) y `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) —que apuntaban al extinto `SistemaNavegacionControl`— hacia `SistemaNavegacion` (y el requisito de conmutación de modos compartido con `SistemaControl`), conservando íntegramente el texto, las condiciones técnicas y los identificadores del pliego.
- **Fuera de alcance**:
  - Modificar `01_barcaza.sysml`, `02_tren_rodaje.sysml`, `03_planta_motriz.sysml`, `05_comunicaciones.sysml`, `06_estaciones_control.sysml`, `07_uav_cenital.sysml`, `08_cargas_pago.sysml` o `10_comportamiento.sysml`.

## Capabilities

### New Capabilities
- `subsistema-control`: Arquitectura interna, puertos, conexiones y acciones del subsistema 4.1 de Control (`SubsistemaControl` en `Modelos/04_1_control.sysml`), incluyendo `ComputadorAutonomia` y `ModuloFrenadoSeguridad` y sus vistas dedicadas.
- `subsistema-navegacion`: Arquitectura interna, puertos, conexiones, acciones y requisitos de percepción/posicionamiento del subsistema 4.2 de Navegación (`SubsistemaNavegacion` en `Modelos/04_2_navegacion.sysml`), incluyendo sensores radiantes (`SensorLidar`, `SensorRadar`), no radiantes (`SistemaVisionComputador`, `CamarasOpticas360`, `CamaraTermicaNocturna`), `ModuloDeteccionEvasion` y `OdometriaVisualInercialVIO`, su interconexión con `SistemaControl` en `PlataformaUGV` y sus vistas dedicadas.

### Modified Capabilities
<!-- Ninguna especificación consolidada en openspec/specs/ ve modificados sus requisitos normativos. -->

## Impact

- **Archivos afectados**:
  - `Modelos/04_navegacion_control.sysml` (eliminado).
  - `Modelos/04_1_control.sysml` (nuevo archivo: `package SubsistemaControl`).
  - `Modelos/04_2_navegacion.sysml` (nuevo archivo: `package SubsistemaNavegacion`).
  - `Modelos/09_sistema_ugv.sysml` (sustitución de `navegacionControl` por `control` y `navegacion` e interconexión entre ambos en `PlataformaUGV` y `SistemaUGVPesadoDual`).
  - `Modelos/11_vistas.sysml` (actualización de `vistaRequisitos` y desglose de vistas de estructura e interconexiones para Control y Navegación).
- **Subsistemas afectados**:
  - `SubsistemaControl` (nuevo, 4.1), `SubsistemaNavegacion` (nuevo, 4.2), `SistemaUGV` y `VistasUGV`.
- **Requisitos del pliego relacionados y trazabilidad**:
  - `RNAV-01` (`ReqNavegacionGNSSDenegado`) y `RGEN-09` (`ReqDeteccionObstaculosModoSigiloso`): reasignación de `subject`/`satisfy` autorizada explícitamente por el usuario debido a la eliminación de `SistemaNavegacionControl`, manteniendo intacta la especificación funcional.
  - `ROPE-05`, `ROPE-06`, `RGEN-17`, `RGEN-20`, `RGEN-22`: preservados en sus respectivos módulos dentro de `SubsistemaControl` y `SubsistemaNavegacion`.
