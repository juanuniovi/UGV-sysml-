# barcaza-chasis Specification

## Purpose
Especificar los requisitos técnicos y estructurales del subsistema de barcaza y chasis del UGV pesado, garantizando la arquitectura común de plataforma, protección balística y contraminas, capacidades de auto-recuperación y compatibilidad con interfaces de remolque STANAG.

## Requirements

### Requirement: Arquitectura de barcaza y proteccion estructural
El subsistema de barcaza SHALL proveer una estructura resistente común para todas las variantes del lote del UGV (RGEN-03), integrando un chasis inferior con geometría en V diseñado para desviar la onda de choque y proteger contra minas terrestres e IEDs.

#### Scenario: Blindaje en V contraminas
- **WHEN** se evalúa la resistencia del chasis inferior frente a detonaciones bajo el casco
- **THEN** la geometría en V MUST deflactar lateralmente los efectos de la sobrepresión y fragmentación.

#### Scenario: Plataforma comun modular
- **WHEN** se configuran diferentes variantes operativas del UGV sobre la misma barcaza
- **THEN** la estructura básica de la barcaza MUST permanecer invariable, admitiendo la integración modular de componentes internos y externos según RGEN-03.

### Requirement: Sistemas de recuperacion y remolque militar
La barcaza SHALL integrar un cabestrante motorizado de gran capacidad de autorrecuperación y puntos de anclaje con eslingas (RGEN-23 / RGEN-26), así como puntos normalizados de acoplamiento para arrastre de remolque bajo la norma militar STANAG 4101 (RGEN-10).

#### Scenario: Auto-recuperacion mediante cabestrante
- **WHEN** el vehículo queda encallado o requiere asistir a otra unidad en terreno difícil
- **THEN** el cabestrante MUST proporcionar fuerza de tracción mecánica suficiente para auto-recuperación en pendientes o terreno farragoso según RGEN-23 y RGEN-26.

#### Scenario: Remolque normalizado STANAG 4101
- **WHEN** el UGV deba ser remolcado o precise remolcar un vehículo táctico compatible de al menos 3.000 kg
- **THEN** el gancho de remolque MUST permitir el enganche directo y seguro bajo la norma STANAG 4101 según RGEN-10.

### Requirement: Rango de masa en vacio de la plataforma
La masa en vacío o tara de la plataforma con ruedas vinculada a la barcaza SHALL situarse obligatoriamente entre 3.500 kg y 7.000 kg, conforme a la prescripción contractual del pliego oficial CDTI (Anexo I §3.2.1, RLT1-06).

#### Scenario: Verificacion de masa tara
- **WHEN** se totaliza la masa del chasis estructural y componentes base de la plataforma
- **THEN** el valor resultante MUST satisfacer la restricción `masa >= 3500.0 and masa <= 7000.0`.
