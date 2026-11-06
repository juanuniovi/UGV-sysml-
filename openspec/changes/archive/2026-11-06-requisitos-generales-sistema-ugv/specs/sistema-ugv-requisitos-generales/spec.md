## ADDED Requirements

### Requirement: Limites globales de masa en orden de mision y capacidad de carga de plataforma
El sistema de nivel plataforma (`PlataformaUGV`) SHALL limitar su masa total en orden de misión a un máximo de 9.000 kg (`RLT1-08`) y SHALL proporcionar una capacidad nominal de carga útil sobre la plataforma de al menos 2.000 kg (`RLT1-07`), empleando el tipo `TiposBase::Masa` expresado en kilogramos.

#### Scenario: Verificacion de masa maxima en orden de mision
- **WHEN** se evalúa la masa total del UGV en orden de misión (`masaOrdenMisionKg`) con sus subsistemas y carga de misión embarcada
- **THEN** el valor resultante MUST satisfacer la restricción `masaOrdenMisionKg <= 9000.0` (`RLT1-08`).

#### Scenario: Verificacion de capacidad minima de carga util de plataforma
- **WHEN** se evalúa la capacidad de carga útil disponible sobre la plataforma de ruedas (`capacidadCargaUtilKg`)
- **THEN** el valor nominal MUST satisfacer la restricción `capacidadCargaUtilKg >= 2000.0` (`RLT1-07`).

### Requirement: Capacidad de arrastre de remolque, remolcado pasivo y vadeo
La plataforma terrestre (`PlataformaUGV`) SHALL ser capaz de arrastrar un remolque trasero de al menos 3.000 kg (`RGEN-10`, `RLT1-14`), SHALL admitir ser remolcada pasivamente por otros vehículos a una velocidad de al menos 65 km/h (`RGEN-16`) y SHALL ofrecer una capacidad de vadeo sin preparación de al menos 0,75 m en agua dulce o salada (`RLT1-10`).

#### Scenario: Arrastre de remolque militar de 3000 kg
- **WHEN** se acopla un remolque en el punto de interfaz trasero compatible con STANAG 4101
- **THEN** la capacidad de arrastre de la plataforma MUST satisfacer `capacidadArrastreRemolqueKg >= 3000.0` (`RGEN-10`, `RLT1-14`).

#### Scenario: Remolcado pasivo en convoy a 65 km/h
- **WHEN** el UGV es remolcado por otro vehículo de la unidad en desplazamientos tácticos o logísticos
- **THEN** la velocidad máxima admisible de remolcado MUST satisfacer `velocidadRemolcadoKmh >= 65.0` (`RGEN-16`).

#### Scenario: Vadeo sin preparacion previa
- **WHEN** la plataforma atraviesa un cauce de agua dulce o salada sin preparación previa
- **THEN** la profundidad máxima de vadeo admisible MUST satisfacer `profundidadVadeoM >= 0.75` (`RLT1-10`).

### Requirement: Autonomia energetica global e hibrida silenciosa a nivel plataforma
La plataforma UGV (`PlataformaUGV`) SHALL garantizar una autonomía operativa total de al menos 8 horas o 400 km (`RGEN-14`) y una autonomía en modo puramente eléctrico (sigiloso, con firma térmica y acústica reducida) de al menos 2 horas o 100 km (`RGEN-15`).

#### Scenario: Autonomia total en mision combinada
- **WHEN** el UGV opera utilizando su sistema de propulsión híbrido completo
- **THEN** la plataforma MUST satisfacer `autonomiaTotalHoras >= 8.0 and autonomiaTotalKm >= 400.0` (`RGEN-14`).

#### Scenario: Autonomia en modo puramente electrico sigiloso
- **WHEN** el UGV opera exclusivamente con tracción eléctrica y baterías sin motor de combustión (`RGEN-13`, `RGEN-15`)
- **THEN** la plataforma MUST satisfacer `autonomiaElectricaHoras >= 2.0 and autonomiaElectricaKm >= 100.0` (`RGEN-15`).

### Requirement: Condiciones generales de concepcion nativa, resistencia ambiental, estiba y estabilidad
El sistema UGV (`SistemaUGVPesadoDual` y `PlataformaUGV`) SHALL cumplir las condiciones generales del Anexo I: concepción nativa no tripulada gobernada desde el PMP (`RGEN-01`, `RGEN-04`), resistencia ambiental (`RGEN-06`), estiba para transporte aéreo STANAG 3400 y terrestre UNE-EN 12195 (`RGEN-24`, `RGEN-25`), e invariancia de estabilidad con o sin cargas acopladas (`RGEN-28`, `RGEN-29`).

#### Scenario: Concepcion nativa sin habitaculo de tripulacion y gobierno remoto
- **WHEN** se verifica la arquitectura del sistema de interés (`SistemaUGVPesadoDual`) y de la plataforma (`PlataformaUGV`)
- **THEN** el sistema MUST reflejar su diseño nativo no tripulado (`RGEN-04`) gobernado remotamente desde el Puesto de Mando Portable (`RGEN-01`) mediante relación formal `satisfy requirement`.

#### Scenario: Resistencia ambiental, estiba normativa y estabilidad en puntos de interfaz
- **WHEN** se inspecciona la trazabilidad de requisitos generales de `PlataformaUGV` en la vista `VistasUGV::vistaRequisitos`
- **THEN** el bloque `PlataformaUGV` MUST satisfacer formalmente `ReqResistenciaAmbiental` (`RGEN-06`), `ReqEstibaTransporteEstrategico` (`RGEN-24`, `RGEN-25`) y `ReqEstabilidadPuntosInterfaz` (`RGEN-28`, `RGEN-29`).
