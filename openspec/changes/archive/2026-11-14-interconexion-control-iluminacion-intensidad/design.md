# Design

## Context

Actualmente, el subsistema de iluminación (`SistemaIluminacion`) contaba con un puerto genérico `dataBus : DataBusPort` enlazado con Comunicaciones (`c_comms_iluminacion`). Sin embargo, para cumplir con el control funcional de la iluminación —donde el computador de abordo debe regular la intensidad lumínica para apoyar la visión de las cámaras en modo autónomo, mientras que en modo teleoperado el operador desde el puesto de mando gobierna la intensidad— es necesario unificar la emisión de comandos hacia la luminaria. Véase `proposal.md` para la justificación.

## Goals / Non-Goals

**Goals:**
- Tipar explícitamente el flujo de datos de intensidad lumínica mediante `item def Intensidad` y `port def PuertoIntensidadIluminacion`.
- Establecer una salida única de control de iluminación desde `SubsistemaPlanificacionEvaluacion` (en `ComputadorAutonomia` y `SistemaControl`) hacia `SistemaIluminacion`.
- Canalizar las órdenes de telemando del operador a través de `busComunicaciones` hacia `subsistemaPlanificacionEvaluacion`, permitiendo que en modo `TELEOPERADO` (indicado por `GobiernoControl`) la intensidad obedezca directamente a las consignas del operador.
- Mantener la iluminación siempre activada sin que el modo sigiloso apague las luces perimetrales (postergando el apagado total al futuro modo fuera de línea).
- Actualizar la topología en `PlataformaUGV` (`c_control_iluminacion`) y las vistas conjuntas en `Modelos/11_vistas.sysml`.

**Non-Goals:**
- No implementar todavía el modo fuera de línea (*offline*).
- No modificar el suministro eléctrico de aviónica (`c_power_iluminacion`) ni el soporte en barcaza (`c_barcaza_iluminacion`).

## Decisions

### Decisión 1: Definición de ítem tipado `Intensidad` y `PuertoIntensidadIluminacion`
- **Elección**: Definir en `SubsistemaIluminacion`:
  ```sysml
  item def Intensidad {
      doc /* Consigna de intensidad luminica perimetral (0.0 a 100.0 %) */
      attribute nivelPorcentaje : Real;
  }

  port def PuertoIntensidadIluminacion {
      doc /* Puerto de envio de consigna de intensidad luminica */
      out item intensidad : Intensidad;
  }
  ```
- **Justificación**: Aporta semántica estricta de SysML v2 al flujo de datos, diferenciándolo de un bus de datos genérico y garantizando trazabilidad con el requerimiento del usuario.

### Decisión 2: Canalización del telemando a través de Planificación y Evaluación
- **Elección**: El bloque `SubsistemaPlanificacionEvaluacion` recibe el estado de modo desde `gobiernoControl` (`entradaControlModo`) y los comandos de telemando desde `busComunicaciones`.
  - En `TELEOPERADO`: La intensidad transmitida por `salidaIntensidad` es gobernada directamente por las órdenes del operador.
  - En `NAVEGACION`: La intensidad es calculada y modulada por los algoritmos de visión y soporte sensorial del computador.
- **Justificación**: Elimina el peligro de colisiones en la luminaria al existir un único emisor de consigna física hacia `SistemaIluminacion`.

### Decisión 3: Interconexión directa en PlataformaUGV
- **Elección**: Sustituir la conexión `c_comms_iluminacion` por `connection c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`.
- **Justificación**: La luminaria es un actuador comandado por el sistema de control; reflejar esta conexión explicita la arquitectura funcional en los diagramas de Spec42 (vistas 7 y 8).

## Risks / Trade-offs

- **Riesgo**: Dependencia de paquetes SysML v2 entre `SubsistemaControl` y `SubsistemaIluminacion`.
  - **Mitigación**: `SubsistemaIluminacion` es un paquete base que no depende de `SubsistemaControl`. `SubsistemaControl` realiza `private import SubsistemaIluminacion::*;` de manera limpia, sin incurrir en dependencias circulares.
