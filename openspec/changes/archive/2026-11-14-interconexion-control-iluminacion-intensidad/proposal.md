# Proposal

## Why

Para implementar el control de iluminación perimetral 360° conforme a los modos de operación del UGV ([ROPE-01], [ROPE-02], [RGEN-20]), es necesario establecer una vía única, coherente y no conflictiva de gobierno:
1. En **Modo Autónomo (`NAVEGACION`)**, el computador de autonomía (específicamente `subsistemaPlanificacionEvaluacion`) debe tener el control total para regular y modificar la intensidad lumínica según las necesidades de los sensores y cámaras.
2. En **Modo Teleoperado (`TELEOPERADO`)**, el telemando desde las estaciones de control (PMP/CPT) debe tener el control total de dicha intensidad lumínica.
3. Para evitar conexiones paralelas o colisiones en el puerto de la luminaria, el telemando se canaliza a través del bus de comunicaciones hacia `subsistemaPlanificacionEvaluacion`, el cual, gobernado por la señal de modo de `GobiernoControl`, actúa como pasarela unificada y comanda la iluminación mediante un ítem tipado `Intensidad`.
4. La iluminación se mantiene siempre activada en esta fase (sin ser afectada por el modo sigiloso, y postergando el apagado global al futuro modo fuera de línea).

## What Changes

- **Definición del ítem de datos `Intensidad` y puerto tipado en `SubsistemaIluminacion` (`Modelos/04_3_iluminacion.sysml`)**:
  - Definir `item def Intensidad` con el atributo de nivel lumínico (`valorPorcentaje : Real`).
  - Definir el tipo de puerto `port def PuertoIntensidadIluminacion { out item intensidad : Intensidad; }`.
  - Dotar a `SistemaIluminacion` del puerto receptor `port entradaIntensidad : ~PuertoIntensidadIluminacion;`.
- **Ampliación de puertos y arbitraje en `SubsistemaControl` (`Modelos/04_1_control.sysml`)**:
  - En `SubsistemaPlanificacionEvaluacion`: añadir el puerto `salidaIntensidad : PuertoIntensidadIluminacion;`, integrando la lógica de recepción de órdenes de luces desde `busComunicaciones` gobernadas por `entradaControlModo` (modo teleoperado vs autónomo).
  - En `ComputadorAutonomia`: exponer `salidaIntensidad : PuertoIntensidadIluminacion;` con su respectivo `binding` hacia `subsistemaPlanificacionEvaluacion.salidaIntensidad`.
  - En `SistemaControl`: exponer el puerto de contorno `salidaIntensidad : PuertoIntensidadIluminacion;` enlazado mediante `binding` interno con `computadorAutonomia.salidaIntensidad`.
- **Topología e interconexión en `SistemaUGV` (`Modelos/09_sistema_ugv.sysml`)**:
  - Reemplazar la antigua conexión genérica `c_comms_iluminacion` por `connection c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`.
- **Actualización de Vistas en `Modelos/11_vistas.sysml`**:
  - En las vistas 7 (`vistaEstructuraNavegacionControl`) y 8 (`vistaConexionesNavegacionControl`), sustituir la referencia `SistemaUGV::PlataformaUGV::c_comms_iluminacion` por `SistemaUGV::PlataformaUGV::c_control_iluminacion`.

## Capabilities

### New Capabilities
*(Ninguna)*

### Modified Capabilities
- `subsistema-control`: Incorporación del puerto `salidaIntensidad` en `SubsistemaPlanificacionEvaluacion`, `ComputadorAutonomia` y `SistemaControl` para gobernar la intensidad lumínica transmitiendo el ítem `Intensidad` de acuerdo al modo activo (`TELEOPERADO` comandado por telemando o `NAVEGACION` autónomo).
- `subsistema-iluminacion`: Definición del ítem `Intensidad`, del puerto `PuertoIntensidadIluminacion`, y dotación del puerto `entradaIntensidad` en `SistemaIluminacion`, conectado con `SistemaControl::salidaIntensidad` en `PlataformaUGV`.

## Impact

- **Modelos modificados**:
  - `Modelos/04_3_iluminacion.sysml`: Nuevos `item def Intensidad`, `port def PuertoIntensidadIluminacion` y puerto en `SistemaIluminacion`.
  - `Modelos/04_1_control.sysml`: Puertos `salidaIntensidad` y bindings en `SubsistemaPlanificacionEvaluacion`, `ComputadorAutonomia` y `SistemaControl`.
  - `Modelos/09_sistema_ugv.sysml`: Interconexión `c_control_iluminacion` entre `control` e `iluminacion`.
  - `Modelos/11_vistas.sysml`: Exposición de `c_control_iluminacion` en vistas 7 y 8.
- **Requisitos contractuales**: Cumplimiento de `ROPE-01` (modos teleoperado/autónomo), `ROPE-02` (telemando de luces desde el puesto de mando en teleoperación) y `RGEN-20` (iluminación perimetral 360°).
