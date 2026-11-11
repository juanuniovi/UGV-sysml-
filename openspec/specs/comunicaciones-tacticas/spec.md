# comunicaciones-tacticas Specification

## Purpose
Especificar los requisitos técnicos, estructurales y funcionales del enlace táctico en línea de vista (LOS) del subsistema de comunicaciones del UGV pesado dual, garantizando conectividad directa con la Consola Portable de Operador (CPT), latencia ultrabaja para telemando suave y transmisión de vídeo en tiempo real según el requisito RCOM-01 del pliego del CDTI.

## Requirements

### Requirement: Enlace tactico en linea de vista (LOS) para telemando directo
El subsistema de comunicaciones embarcado SHALL proporcionar un canal de radiofrecuencia táctico en línea de vista (LOS) para el telemando y la supervisión del UGV desde la Consola Portable de Operador (CPT) según el requisito `RCOM-01`.

#### Scenario: Operacion de telemando con baja latencia
- **WHEN** el operador desmontado ejecuta maniobras de telemando directo mediante los joysticks tácticos de la Consola CPT
- **THEN** la latencia máxima de transmisión extremo a extremo del enlace táctico LOS MUST ser menor o igual a 100 ms (`latenciaMaximaMs <= 100.0`).

#### Scenario: Alcance nominal de linea de vista
- **WHEN** el vehículo opera en proximidad del operador sin obstáculos orográficos
- **THEN** el alcance operativo nominal en línea de vista MUST ser de al menos 1,0 km (`alcanceNominalKm >= 1.0`).

#### Scenario: Transmision de video y telemetria directa
- **WHEN** el vehículo se desplaza en modo teleoperado desde la Consola CPT
- **THEN** el transceptor LOS MUST transmitir vídeo de conducción diurna y telemetría de plataforma en tiempo real hacia la pantalla de la consola.
