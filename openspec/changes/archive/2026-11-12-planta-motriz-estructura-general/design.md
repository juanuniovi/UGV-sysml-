# Design: Estructura general de la Planta Motriz Híbrida

## Context

Ver `proposal.md` (Why). Estado actual de `Modelos/03_planta_motriz.sysml`:

- `PlantaMotrizHibrida` declara 6 partes **sin tipo** (`motorCombustionBiocombustible`, `generadorElectrico`, `packBateriasTraccion`, `motoresElectricosTraccion[1..*]`, `gestionEnergiaPMS`, `moduloExportacionPotencia`).
- Sus 5 puertos de contorno ya están conectados desde `09_sistema_ugv.sysml` y no deben cambiar.
- `TiposBase` solo ofrece `MechanicalMountPort`, `ElectricalPowerPort`, `DataBusPort` y `RFPort`. No hay puertos para combustible ni para ejes mecánicos.
- Patrón del proyecto (ver `04_1_control.sysml`): `part def` con puertos, partes internas tipadas, `connection ... connect a to b` entre partes internas y `binding ... bind contorno = parte.puerto` hacia los puertos de contorno.

## Goals / Non-Goals

**Goals:**
- Un esquema (IBD) en el que se vea de un vistazo cómo circulan el combustible, el giro mecánico, la electricidad y los datos de gestión dentro de la planta.
- Bloques con nombre, documentación y puertos, listos para recibir atributos en la fase de detalle sin tener que reestructurar.

**Non-Goals:**
- Dirección de flujo tipada (`item def` / `in` / `out`) en los puertos: se deja para la fase de detalle.
- Redundancias, protecciones eléctricas, refrigeración o cableado de baja tensión interno.

## Decisions

### 1. Esquema general de bloques y flujos

```
                         controlBus (desde Control)
                              │ binding
                     ┌────────┴─────────┐
                     │ gestionEnergiaPMS│── datos ──► depósito, motor, generador,
                     └──────────────────┘            baterías, distribución,
                                                     convertidor, exportación
 ┌──────────┐ combustible ┌─────────┐  eje   ┌───────────┐  eléctrica  ┌──────────────────────┐
 │ deposito │────────────►│ motor   │───────►│ generador │────────────►│                      │── binding ──► powerOutputTraction
 │Combust.  │             │ HVO     │        │ eléctrico │             │ distribucionPotencia │                (rodaje, regeneración)
 └──────────┘             └─────────┘        └───────────┘             │   (bus alta tensión) │
                                                  ┌──────────┐ ◄──────►│                      │
                                                  │ baterías │ (carga/ └───┬──────────────┬───┘
                                                  │ tracción │ descarga)   │              │
                                                  └──────────┘             ▼              ▼
                                                              ┌─────────────────┐ ┌──────────────────┐
                                                              │ convertidor     │ │ moduloExportacion│
                                                              │ baja tensión    │ │ Potencia         │
                                                              └────────┬────────┘ └────────┬─────────┘
                                                                       │ binding           │ binding
                                                                       ▼                   ▼
                                                              powerOutputAvionics   powerOutputPayload
                                                         (control, navegación, comms) (cargas de pago, UAV, externos)
```

### 2. Bloques (`part def`) y puertos

| `part def` | Uso en `PlantaMotrizHibrida` | Puertos | Trazabilidad |
| :--- | :--- | :--- | :--- |
| `DepositoCombustible` | `depositoCombustible` *(nueva)* | `salidaCombustible : PuertoCombustible`, `datosGestion : DataBusPort` | `RGEN-11` |
| `MotorCombustionBiocombustible` | `motorCombustionBiocombustible` | `entradaCombustible : ~PuertoCombustible`, `ejeSalida : PuertoEjeMecanico`, `datosGestion : DataBusPort` | `RGEN-11` |
| `GeneradorElectrico` | `generadorElectrico` | `ejeEntrada : ~PuertoEjeMecanico`, `salidaPotencia : ElectricalPowerPort`, `datosGestion : DataBusPort` | `RGEN-11` |
| `PackBateriasTraccion` | `packBateriasTraccion` | `puertoPotencia : ElectricalPowerPort` (carga y descarga), `datosGestion : DataBusPort` (BMS) | `RGEN-13` |
| `UnidadDistribucionPotencia` | `distribucionPotencia` *(nueva)* | `entradaGenerador`, `puertoBaterias`, `salidaTraccion`, `salidaBajaTension`, `salidaExportacion` (todos `ElectricalPowerPort`), `datosGestion : DataBusPort` | `RLT1-09` |
| `ConvertidorBajaTension` | `convertidorBajaTension` *(nueva)* | `entradaAltaTension`, `salidaBajaTension` (`ElectricalPowerPort`), `datosGestion : DataBusPort` | — |
| `GestionEnergiaPMS` | `gestionEnergiaPMS` | `busExterno`, `enlaceDeposito`, `enlaceMotor`, `enlaceGenerador`, `enlaceBaterias`, `enlaceDistribucion`, `enlaceConvertidor`, `enlaceExportacion` (todos `DataBusPort`) | `RGEN-09`, `RGEN-13` |
| `ModuloExportacionPotencia` | `moduloExportacionPotencia` | `entradaPotencia`, `salidaPotencia` (`ElectricalPowerPort`), `datosGestion : DataBusPort` | `RGEN-19` |

**Por qué un PMS con un puerto por bloque**, en vez de un único bus compartido: SysML v2 conecta puertos de dos en dos, y un puerto por enlace hace que el diagrama muestre explícitamente qué gobierna el PMS. *Alternativa descartada*: una parte «bus CAN» intermedia, que añade un bloque sin aportar información en esta fase.

**Por qué una unidad de distribución explícita**: es el nodo donde se juntan generador y baterías. Sin ella habría que conectar el generador directamente a tres salidas y las baterías a otras tres, y el esquema perdería claridad. *Alternativa descartada*: conectar el generador a `powerOutputTraction`, que impediría representar el modo solo baterías.

**Por qué un convertidor de baja tensión**: la aviónica (control, navegación y comunicaciones) se alimenta a baja tensión (24/28 V CC, ver plan de comunicaciones), mientras que la tracción usa el bus de alta tensión. *Alternativa descartada*: sacar la aviónica directamente del bus, que sería eléctricamente incorrecto.

### 3. Puertos locales nuevos

`PuertoCombustible` y `PuertoEjeMecanico` se definen **dentro de `SubsistemaPlantaMotriz`**, no en `TiposBase`: solo los usa este subsistema, y así no se toca un archivo compartido. Si otro subsistema los necesitara, se moverían a `TiposBase` en un cambio aparte. Los extremos receptores usan el puerto conjugado (`~`), como en `04_1_control.sysml`, para que el sentido del flujo se lea en el diagrama.

### 4. Conexiones y enlaces

- **Conexiones internas (`connection`)**: `c_deposito_motor`, `c_motor_generador`, `c_generador_distribucion`, `c_baterias_distribucion`, `c_distribucion_convertidor`, `c_distribucion_exportacion` y `c_pms_deposito`, `c_pms_motor`, `c_pms_generador`, `c_pms_baterias`, `c_pms_distribucion`, `c_pms_convertidor`, `c_pms_exportacion`.
- **Enlaces con el contorno (`binding`)**: `b_salida_traccion` (`powerOutputTraction = distribucionPotencia.salidaTraccion`), `b_salida_avionica` (`powerOutputAvionics = convertidorBajaTension.salidaBajaTension`), `b_salida_carga` (`powerOutputPayload = moduloExportacionPotencia.salidaPotencia`), `b_bus_control` (`controlBus = gestionEnergiaPMS.busExterno`).
- `chassisMount` se mantiene como única bancada del conjunto. El montaje individual de cada bloque queda fuera de esta fase.
- **Frenada regenerativa**: `ElectricalPowerPort` no tiene dirección, así que la misma conexión `powerOutputTraction` ↔ `rodaje.powerInput` representa la energía que vuelve de las ruedas al frenar. Se documentará en el `doc` de `UnidadDistribucionPotencia`.

### 5. Eliminación de `motoresElectricosTraccion`

El tren de rodaje ya modela la tracción directa por rueda con motor eléctrico (`RuedaTraccionIndependiente`, `RLT1-01`, `RLT1-04`). Mantener `motoresElectricosTraccion` en la planta duplicaría el componente. No es un requisito, ninguna otra parte del repositorio lo referencia y no cambia ningún puerto de contorno. **Requiere la confirmación explícita del autor en la revisión de esta propuesta**, que quedará registrada en `tasks.md` antes de aplicar.

### 6. Vistas

En `11_vistas.sysml`, siguiendo la numeración existente:
- **Vista 10** `vistaConexionesPlantaMotriz : InterconnectionView` → `expose SubsistemaPlantaMotriz::PlantaMotrizHibrida;`
- **Vista 11** `vistaEstructuraPlantaMotriz : GeneralView` → `expose SubsistemaPlantaMotriz::*;` con filtro de partes y puertos (definiciones y usos).

- **Vista 12** `vistaConexionesPlantaMotrizSistema : InterconnectionView`, que sigue el patrón de las Vistas 7 y 8 (exponer partes y conexiones concretas):
  - Partes de `SistemaUGV::PlataformaUGV`: `plantaMotriz`, `control`, `navegacion`, `comunicaciones`.
  - Conexiones de `SistemaUGV::PlataformaUGV`: `c_power_control`, `c_power_navegacion`, `c_power_comms`, `c_pms_control`.
  - **Ajuste tras la verificación visual**: al exponer `barcaza` y `rodaje`, Spec42 dibuja todas sus piezas internas (ruedas, suspensiones, servodirecciones, chasis, ganchos…) como cajas sueltas, y el diagrama deja de ser legible. Se excluyen de esta vista. `c_barcaza_powertrain` y `c_power_traction` siguen visibles en la Vista 4 (`vistaConexionesPlataforma`), sin modificar los archivos de esos subsistemas.
  - Partes y conexiones de `SistemaUGV::SistemaUGVPesadoDual`: `cargaPagoMision`, `uavCenital`, `c_payload_power`, `c_uav_power`.

`vistaRequisitos` ya expone `SubsistemaPlantaMotriz::*` y no necesita cambios.

## Risks / Trade-offs

- [Spec42 no admite una conexión entre un puerto y su conjugado de la misma definición sin ítems] → Usar puertos no conjugados en ambos extremos, como en las conexiones de `09_sistema_ugv.sysml`.
- [El `binding` de un puerto de contorno con varias conexiones externas, por ejemplo `powerOutputAvionics` hacia tres subsistemas, genera avisos] → Es el patrón que ya usa el proyecto. Si Spec42 avisa, se documenta y se resuelve antes de cerrar.
- [La Vista 12 mezcla elementos de dos niveles (`PlataformaUGV` y `SistemaUGVPesadoDual`) y Spec42 podría representar la carga de pago y el UAV fuera del contexto de la plataforma] → Comprobarlo al aplicar. Si el diagrama no es legible, exponer desde `SistemaUGVPesadoDual` (con `vehiculo.plantaMotriz`) o dejar carga de pago y UAV en la Vista 3, ya existente, y documentar la decisión en `tasks.md`.
- [Bloques sin atributos pueden parecer «vacíos»] → Es intencionado. El plan de desarrollo fija la fase de detalle a continuación.

## Migration Plan

Cambio aditivo salvo la eliminación de `motoresElectricosTraccion`. Para deshacerlo basta con revertir el commit de la rama `feat/planta-motriz-estructura-general`. No hay datos que migrar.
