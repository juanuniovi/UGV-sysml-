# Proposal

## Why

El Issue #2 asignado en el repositorio exige desarrollar el subsistema de la Barcaza Estructural y el Chasis del vehículo UGV. Actualmente, [`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml) contiene un modelo preliminar esquemático que carece de definiciones tipadas para sus partes estructurales y no formaliza los requisitos del pliego `RGEN-02`, `RGEN-03`, `RGEN-04` y `RGEN-05`.

Para establecer la base física del UGV de forma limpia, modular y rigurosa, es necesario estructurar los componentes de la barcaza y formalizar la trazabilidad directa con las exigencias contractuales de protección, auto-recuperación y remolque.

## What Changes

- Modelado de las definiciones de partes (`part def`) integrantes de la barcaza:
  - `ChasisProtegidoEnV`: Blindaje estructural y geometría deflectora en V contra minas e IEDs.
  - `CabestranteAutoRecuperacion`: Sistema de tracción mecánica para auto-rescate y recuperación.
  - `GanchoRemolqueSTANAG`: Dispositivo de arrastre y remolque militar normalizado.
- Formalización de los requisitos técnicos del pliego:
  - `ReqBarcazaComun` (`RGEN-02`): Arquitectura de barcaza unificada y modular.
  - `ReqProteccionCascoEnV` (`RGEN-03`): Deflexión de explosiones inferiores.
  - `ReqCabestranteAutoRecuperacion` (`RGEN-04`): Fuerza de tiro autónoma.
  - `ReqGanchoSTANAG4101` (`RGEN-05`): Compatibilidad de acoplamiento de remolque.
  - Preservación íntegra de `ReqMasaTaraPlataforma` (`RLT1-06`, 3.500 - 5.000 kg).
- Inclusión de relaciones de satisfacción (`satisfy`) entre las partes y sus requisitos.

## Capabilities

### New Capabilities
- `barcaza-chasis`: Define la arquitectura estructural, componentes de protección y anclaje, y requisitos normativos de la barcaza del UGV.

### Modified Capabilities
<!-- No se modifican requisitos previos de otras capacidades. -->

## Impact

- **Archivos de modelo**: [`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml) se enriquece de forma modular.
- **Interfaces externas**: Todos los puertos preexistentes (`rodajeMount`, `powertrainMount`, `avionicaMount`, interfaces de carga) permanecen intactos, asegurando total compatibilidad con [`Modelos/09_sistema_ugv.sysml`](Modelos/09_sistema_ugv.sysml).
- **Otros subsistemas**: Ningún archivo ajeno (`02_tren_rodaje.sysml`, `03_planta_motriz.sysml`, etc.) resulta alterado.
