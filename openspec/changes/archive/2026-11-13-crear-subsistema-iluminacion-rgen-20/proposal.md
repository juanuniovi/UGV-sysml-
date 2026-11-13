# Proposal: Crear Subsistema 4.3 de Iluminación con Subparte 360° y Conexión con Comunicaciones (RGEN-20)

## Why

El requisito **RGEN-20** del pliego técnico y la operabilidad del UGV pesado exigen mantener una consciencia situacional completa del entorno en 360°, facilitando tanto el movimiento como la teleoperación desde el Puesto de Mando en condiciones de visibilidad degradada o nocturna. Actualmente, el modelo SysML v2 del UGV dispone de los subsistemas **4.1 Control** (`Modelos/04_1_control.sysml`) y **4.2 Navegación** (`Modelos/04_2_navegacion.sysml`), pero carece de un modelo formal para la iluminación perimetral activa.

Incorporar la iluminación como un subsistema dedicado **4.3 Iluminación** (`SubsistemaIluminacion` en `Modelos/04_3_iluminacion.sysml`) permite modelar de forma simple y desacoplada la subparte de iluminación en 360 grados (`iluminacion360 : Iluminacion360`), enlazada directamente con el subsistema de **Comunicaciones** (`comunicaciones.dataBus`), con la acción de iluminar en 360 grados y trazabilidad formal con el requisito `RGEN-20`, sin introducir sobrecargas innecesarias de tipos ni puertos direccionales complejos.

## What Changes

- **Crear `Modelos/04_3_iluminacion.sysml` (`package SubsistemaIluminacion`)**:
  - Definición de la subparte `iluminacion360 : Iluminacion360`:
    - Atributos cuantitativos básicos: `anguloCoberturaDeg = 360.0`, `potenciaConsumoWatts` y `alcanceEfectivoMetros`.
  - Definición de la acción de comportamiento: `Iluminar360Grados` (activa la emisión lumínica perimetral en 360 grados).
  - Bloque principal `part def SistemaIluminacion`:
    - Puertos de contorno: `chassisMount : MechanicalMountPort`, `powerInput : ElectricalPowerPort` y `dataBus : DataBusPort` (para enlace con comunicaciones).
    - Contiene `part iluminacion360 : Iluminacion360`.
    - Realiza la acción `iluminar360Grados : Iluminar360Grados`.
  - Requisito trazable formal: `requirement def ReqConscienciaSituacionalIluminacion360` (`RGEN-20`) con `subject ilum : SistemaIluminacion` y su respectiva relación `satisfy ... by iluminacion360;`.
- **Actualizar `Modelos/09_sistema_ugv.sysml` (`package SistemaUGV`)**:
  - Importar `SubsistemaIluminacion::*`.
  - Añadir en `PlataformaUGV` la parte `part iluminacion : SistemaIluminacion;`.
  - Establecer las conexiones de plataforma:
    - Montaje estructural: `c_barcaza_iluminacion connect barcaza.avionicaMount to iluminacion.chassisMount;`
    - Potencia eléctrica: `c_power_iluminacion connect plantaMotriz.powerOutputAvionics to iluminacion.powerInput;`
    - Conexión con comunicaciones: `c_comms_iluminacion connect comunicaciones.dataBus to iluminacion.dataBus;`
    - Satisfacción de requisito general: `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;`
- **Actualizar `Modelos/11_vistas.sysml` (`package VistasUGV`)**:
  - Importar `SubsistemaIluminacion::*`.
  - Añadir `expose SubsistemaIluminacion::*;` en `vistaRequisitos` para asegurar trazabilidad automática completa de `RGEN-20`.
  - Exponer `iluminacion` y su enlace de potencia `c_power_iluminacion` en `vistaConexionesPlantaMotrizSistema`.

## Scope and Out of Scope

- **In Scope**:
  - Modelado simplificado y limpio del subsistema 4.3 de iluminación en `04_3_iluminacion.sysml`.
  - Subparte `Iluminacion360`, acción `Iluminar360Grados` y trazabilidad con `RGEN-20`.
  - Conexión directa con Comunicaciones (`c_comms_iluminacion`).
  - Integración en `PlataformaUGV` y vistas arquitectónicas.
- **Out of Scope**:
  - Puertos de control complejos o enumeraciones de sectores direccionales.
  - Modificar la estructura de `04_1_control.sysml` o `04_2_navegacion.sysml`.
