# subsistema-iluminacion Specification

## Purpose

Especifica la arquitectura interna, bloques tipados, puertos, conexiones, acciones, requisitos y vistas del subsistema **4.3 Iluminación** (`SubsistemaIluminacion` en `Modelos/04_3_iluminacion.sysml`), encargado de proporcionar soporte lumínico perimetral en 360 grados (`Iluminacion360`) para garantizar la consciencia situacional nocturna y en baja visibilidad (`RGEN-20`), conectado con el subsistema de Comunicaciones e integrado en `PlataformaUGV`.

## Requirements

### Requirement: Estructura del Subsistema 4.3 de Iluminación y subparte de iluminación 360° (RGEN-20)
El modelo SHALL definir en `Modelos/04_3_iluminacion.sysml` el paquete `SubsistemaIluminacion` con el bloque principal `SistemaIluminacion`, integrando la subparte `iluminacion360 : Iluminacion360` con cobertura de 360 grados, con puertos de potencia (`powerInput : ElectricalPowerPort`), fijación mecánica (`chassisMount : MechanicalMountPort`) y enlace con comunicaciones (`dataBus : DataBusPort`).

#### Scenario: Composición interna de SistemaIluminacion
- **WHEN** se inspecciona la estructura de `SubsistemaIluminacion::SistemaIluminacion`
- **THEN** contiene la subparte `part iluminacion360 : Iluminacion360`, expone los puertos `chassisMount`, `powerInput` y `dataBus`

### Requirement: Acción de iluminación 360 grados
El bloque `SistemaIluminacion` SHALL ejecutar la acción `Iluminar360Grados` (`iluminar360Grados`), la cual comanda y activa la emisión lumínica perimetral en 360 grados de la subparte `iluminacion360`.

#### Scenario: Activación de la iluminación 360 grados
- **WHEN** se ejecuta la acción `iluminar360Grados`
- **THEN** se modula la salida de emisión perimetral activa en 360 grados para dar apoyo visual al UGV

### Requirement: Trazabilidad formal del requisito RGEN-20 y satisfacción por SistemaIluminacion
El paquete `SubsistemaIluminacion` SHALL definir el requisito trazable `ReqConscienciaSituacionalIluminacion360` (`RGEN-20`), estableciendo `subject ilum : SistemaIluminacion` y una relación formal `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion360;`.

#### Scenario: Verificación de trazabilidad del requisito RGEN-20
- **WHEN** se examinan los requisitos del subsistema de iluminación en Spec42 o en `vistaRequisitos`
- **THEN** `ReqConscienciaSituacionalIluminacion360` aparece vinculado y satisfecho formalmente por el subsistema de iluminación bajo la referencia `RGEN-20`

### Requirement: Integración de SistemaIluminacion en PlataformaUGV con enlace a Comunicaciones
El modelo SHALL integrar `part iluminacion : SistemaIluminacion;` dentro de `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`), conectando sus puertos con la barcaza (`c_barcaza_iluminacion`), la planta motriz para suministro de energía (`c_power_iluminacion`) y directamente con el bus de comunicaciones (`c_comms_iluminacion connect comunicaciones.dataBus to iluminacion.dataBus;`), y exponiendo el paquete `SubsistemaIluminacion` en `Modelos/11_vistas.sysml` dentro de `vistaRequisitos` y `vistaConexionesPlantaMotrizSistema`.

#### Scenario: Conexión con comunicaciones y planta motriz en PlataformaUGV
- **WHEN** se instancia `PlataformaUGV` en `SistemaUGV`
- **THEN** `iluminacion.dataBus` está conectado a `comunicaciones.dataBus` (`c_comms_iluminacion`), `iluminacion.powerInput` a `plantaMotriz.powerOutputAvionics` (`c_power_iluminacion`) y `iluminacion.chassisMount` a `barcaza.avionicaMount` (`c_barcaza_iluminacion`)
