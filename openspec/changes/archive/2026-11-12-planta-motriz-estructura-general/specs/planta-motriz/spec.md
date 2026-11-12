# Spec Delta: planta-motriz

## Purpose

Especificar la arquitectura estructural de la planta motriz híbrida del UGV (Issue #4): sus bloques principales, los flujos internos de combustible, potencia mecánica, potencia eléctrica y datos de gestión, y las vistas que permiten inspeccionarla, como base para el dimensionado posterior de cada componente.

## ADDED Requirements

### Requirement: Bloques generales de la planta motriz híbrida
El bloque `PlantaMotrizHibrida` SHALL componerse de partes tipadas para cada función general: depósito de combustible, motor de combustión de biocombustible (`RGEN-11`), generador eléctrico, pack de baterías de tracción (`RGEN-13`), unidad de distribución de potencia, convertidor de baja tensión, gestión de energía (PMS) y módulo de exportación de potencia (`RGEN-19`).

#### Scenario: Partes tipadas en la planta motriz
- **WHEN** se inspecciona `PlantaMotrizHibrida` en la vista de estructura
- **THEN** cada una de las ocho partes generales MUST estar tipada con su propia `part def` del paquete `SubsistemaPlantaMotriz` y ninguna parte MUST quedar sin tipo.

#### Scenario: Sin dimensionado en esta fase
- **WHEN** se inspeccionan las nuevas `part def` de la planta motriz
- **THEN** solo MUST contener documentación y puertos, sin atributos de dimensionado, que se definirán en una fase posterior.

### Requirement: Arquitectura híbrida serie sin motores de tracción propios
La planta motriz SHALL entregar la potencia de tracción exclusivamente en forma eléctrica por `powerOutputTraction`, y SHALL NOT contener motores eléctricos de tracción, que pertenecen al tren de rodaje (`RLT1-01`, `RLT1-04`). El motor de combustión SHALL accionar únicamente el generador.

#### Scenario: Motor de combustión acoplado solo al generador
- **WHEN** se inspecciona la vista de interconexión de la planta motriz
- **THEN** la salida mecánica del motor de combustión MUST conectarse únicamente con la entrada mecánica del generador eléctrico.

#### Scenario: Tracción en el tren de rodaje
- **WHEN** se busca la parte `motoresElectricosTraccion` en `PlantaMotrizHibrida`
- **THEN** la parte MUST NOT existir y la potencia de tracción MUST salir por `powerOutputTraction` hacia `rodaje.powerInput`.

### Requirement: Flujo interno de energía de la planta motriz
`PlantaMotrizHibrida` SHALL declarar conexiones internas que lleven el combustible del depósito al motor, la potencia eléctrica del generador a la unidad de distribución, un intercambio bidireccional de potencia entre baterías y distribución, y la potencia desde la distribución hacia el convertidor de baja tensión y el módulo de exportación.

#### Scenario: Cadena de generación térmica
- **WHEN** el motor de combustión está en marcha (modo híbrido)
- **THEN** el modelo MUST permitir trazar el camino depósito → motor → generador → unidad de distribución mediante conexiones explícitas.

#### Scenario: Funcionamiento solo con baterías
- **WHEN** el motor de combustión está apagado (modo puramente eléctrico, `RGEN-13`)
- **THEN** el modelo MUST permitir trazar el camino baterías → unidad de distribución → `powerOutputTraction` sin pasar por el motor ni el generador.

### Requirement: Salidas de potencia por los puertos de contorno existentes
La planta motriz SHALL enlazar sus partes internas con sus puertos de contorno: la unidad de distribución con `powerOutputTraction`, el convertidor de baja tensión con `powerOutputAvionics` y el módulo de exportación con `powerOutputPayload`.

#### Scenario: Compatibilidad con la plataforma
- **WHEN** se valida `PlataformaUGV` y `SistemaUGVPesadoDual` en `09_sistema_ugv.sysml`
- **THEN** las conexiones `c_power_traction`, `c_power_control`, `c_power_navegacion`, `c_power_comms`, `c_payload_power` y `c_uav_power` MUST seguir siendo válidas sin modificarlas.

### Requirement: Gestión de energía conectada a todos los bloques
La parte de gestión de energía (PMS) SHALL tener un enlace de datos con el depósito, el motor, el generador, las baterías, la unidad de distribución, el convertidor y el módulo de exportación, y SHALL estar enlazada con el puerto de contorno `controlBus` para recibir órdenes del subsistema de Control (incluido el modo sigiloso, `RGEN-09`).

#### Scenario: Órdenes desde Control
- **WHEN** el subsistema de Control envía una orden por `c_pms_control`
- **THEN** el modelo MUST permitir trazarla desde `controlBus` hasta la gestión de energía y desde esta hasta cada bloque gestionado.

### Requirement: Vistas de la planta motriz
`Modelos/11_vistas.sysml` SHALL incluir una vista de interconexión (`InterconnectionView`) y una vista general (`GeneralView`) dedicadas a `PlantaMotrizHibrida`.

#### Scenario: Esquema de conexiones visible
- **WHEN** se abre la vista de interconexión de la planta motriz en Spec42
- **THEN** MUST mostrarse los bloques generales, sus puertos y las conexiones de combustible, mecánicas, eléctricas y de datos.

### Requirement: Vista de la planta motriz integrada en el sistema
`Modelos/11_vistas.sysml` SHALL incluir una vista de interconexión que muestre la planta motriz junto con los subsistemas alimentados por su potencia de aviónica y de carga de pago, o enlazados por datos (control, navegación, comunicaciones, carga de pago y UAV), y las conexiones existentes entre ellos.

#### Scenario: Alimentación de la aviónica visible desde la planta
- **WHEN** se abre la vista de la planta motriz integrada en el sistema en Spec42
- **THEN** MUST verse `powerOutputAvionics` conectado con `control.powerInput`, `navegacion.powerInput` y `comunicaciones.powerInput`, `powerOutputPayload` con la carga de pago y el UAV, y `controlBus` con `control.dataBus`.

#### Scenario: Montaje y tracción en la vista de plataforma
- **WHEN** se buscan las conexiones de la planta con la barcaza y el tren de rodaje
- **THEN** `c_barcaza_powertrain` y `c_power_traction` MUST seguir visibles en `vistaConexionesPlataforma`.

### Requirement: Preservación de requisitos y contorno existentes
El cambio SHALL conservar intactos los puertos de contorno de `PlantaMotrizHibrida`, sus atributos existentes y el texto y las restricciones de `ReqPotenciaMinimaPlataforma` (`RLT1-09`) y `ReqExportacionEnergia` (`RGEN-19`).

#### Scenario: Validación sin regresiones
- **WHEN** se ejecuta `spec42 check Modelos` tras el cambio
- **THEN** el resultado MUST ser 0 errores y 0 avisos.
