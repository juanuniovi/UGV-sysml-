# Proposal

## Why

El Issue #3 asignado a José Escobedo requiere modelar en SysML v2 el subsistema de Tren de Rodaje a Ruedas Independientes del UGV Pesado. En su estado actual, [`Modelos/02_tren_rodaje.sysml`](Modelos/02_tren_rodaje.sysml) es un esquema inicial sin definiciones de partes detalladas ni trazabilidad formal para los requisitos contractuales del pliego (CDTI Anexo I: `RLT1-01` a `RLT1-05`).

Tras consultar las especificaciones oficiales del contrato y contrastar los requisitos con el autor, se debe estructurar el subsistema definiendo la tracción directa por rueda, la suspensión neumática regulable/retráctil y la servodirección multieje, incorporando comentarios y referencias normativas continuas en el modelo.

## What Changes

- Modelado de las definiciones de partes (`part def`) integrantes del tren de rodaje:
  - `RuedaTraccionIndependiente`: Conjunto todoterreno con motor eléctrico de tracción directa dedicado por rueda (`RLT1-01`, `RLT1-04`).
  - `SuspensionNeumaticaRegulable`: Brazo neumático independiente con regulación de altura y modo retráctil (`RLT1-05`).
  - `ServodireccionMultieje`: Dirección electromecánica multieje con capacidad de giro pivotante sobre su eje (`RLT1-03`).
  - `SistemaFrenadoServicio`: Frenado de servicio y estacionamiento redundante.
- Formalización de los requisitos del pliego con identificadores exactos y restricciones:
  - `ReqTraccionRuedas` (`RLT1-01`): Plataforma sobre ruedas para altas velocidades off-road y carretera.
  - `ReqConfiguracionMultirrueda` (`RLT1-02`): Arquitectura de tracción multirrueda configurable (4x4, 6x6, 8x8).
  - `ReqPrestacionesMovilidad` (`RLT1-03`): Velocidad en carretera >= 75 km/h, campo a través >= 50 km/h, pendientes (60% frontal, 30% lateral) y superación de escalón >= 30 cm.
  - `ReqTraccionIndependienteRueda` (`RLT1-04`): Tracción directa e independiente por rueda sin diferenciales mecánicos vulnerables.
  - `ReqSuspensionRegulableRetractil` (`RLT1-05`): Altura libre al suelo regulable >= 350 mm y retracción para transporte.
- Inclusión de relaciones de satisfacción canónicas (`satisfy requirement : ...;`) verificadas con Spec42.

## Capabilities

### New Capabilities
- `tren-rodaje`: Define la arquitectura motriz, componentes de suspensión, dirección y ruedas independientes, y la trazabilidad de los requisitos `RLT1-01` al `RLT1-05`.

### Modified Capabilities
<!-- No se modifican requisitos previos de otras capacidades. -->

## Impact

- **Archivos de modelo**: [`Modelos/02_tren_rodaje.sysml`](Modelos/02_tren_rodaje.sysml) se enriquece de forma modular.
- **Interfaces externas**: Los puertos `chassisMount`, `powerInput` y `controlBus` permanecen intactos, asegurando total coherencia con [`Modelos/09_sistema_ugv.sysml`](Modelos/09_sistema_ugv.sysml).
- **Compilador Spec42**: Estricta conformidad sintáctica con 0 errores y 0 advertencias.
