# Spec Delta

## Purpose
Especificar los requisitos técnicos y estructurales del subsistema de barcaza y chasis del UGV pesado, garantizando la arquitectura común de plataforma, protección balística y contraminas, capacidades de auto-recuperación y compatibilidad con interfaces de remolque STANAG.

## ADDED Requirements

### Requirement: Arquitectura de barcaza y proteccion estructural
El subsistema de barcaza SHALL proveer una estructura resistente común para todas las variantes del UGV (RGEN-02), integrando un chasis inferior con geometría en V diseñado para desviar la onda de choque y proteger contra minas terrestres e IEDs (RGEN-03).

#### Scenario: Blindaje en V contraminas
- **WHEN** se evalúa la resistencia del chasis inferior frente a detonaciones bajo el casco
- **THEN** la geometría en V MUST deflactar lateralmente los efectos de la sobrepresión y fragmentación.

#### Scenario: Plataforma comun modular
- **WHEN** se configuran diferentes variantes operativas del UGV sobre la misma barcaza
- **THEN** la estructura básica de la barcaza MUST permanecer invariable, admitiendo la integración modular de componentes internos y externos.

### Requirement: Sistemas de recuperacion y remolque militar
La barcaza SHALL integrar un cabestrante de auto-recuperación motorizado (RGEN-04) y puntos normalizados de anclaje de remolque conformes a la norma militar STANAG 4101 (RGEN-05).

#### Scenario: Auto-recuperacion mediante cabestrante
- **WHEN** el vehículo queda encallado o requiere asistir a otra unidad en terreno difícil
- **THEN** el cabestrante MUST proporcionar fuerza de arrastre mecánica suficiente para auto-recuperación en pendientes o terreno farragoso.

#### Scenario: Remolque normalizado STANAG 4101
- **WHEN** el UGV deba ser remolcado o precise remolcar un vehículo táctico compatible
- **THEN** el gancho de remolque MUST permitir el enganche directo y seguro bajo la norma STANAG 4101.

### Requirement: Rango de masa en vacio de la plataforma
La masa en vacío o tara de la plataforma con ruedas vinculada a la barcaza SHALL situarse obligatoriamente entre 3.500 kg y 5.000 kg (RLT1-06).

#### Scenario: Verificacion de masa tara
- **WHEN** se totaliza la masa del chasis estructural y componentes base de la plataforma
- **THEN** el valor resultante MUST satisfacer la restricción `masa >= 3500.0 and masa <= 5000.0`.
