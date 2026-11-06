# Spec Delta

## Purpose
Especificar los requisitos técnicos, estructurales y funcionales del subsistema de tren de rodaje del UGV pesado, garantizando tracción directa e independiente por rueda (RLT1-01, RLT1-04), configuraciones multirrueda 4x4 a 8x8 (RLT1-02), suspensión neumática retráctil y regulable con despeje >= 350 mm (RLT1-05), y altas prestaciones de movilidad y maniobrabilidad (RLT1-03).

## ADDED Requirements

### Requirement: Traccion directa e independiente por rueda
El subsistema de tren de rodaje SHALL implementar tracción a ruedas (RLT1-01) con accionamiento directo e independiente en cada conjunto de rueda (RLT1-04), admitiendo arquitecturas multirrueda configurables en 4x4, 6x6 u 8x8 (RLT1-02).

#### Scenario: Accionamiento directo por rueda
- **WHEN** se transmite par motriz a las ruedas de la plataforma
- **THEN** cada rueda MUST recibir potencia de tracción de forma directa e independiente sin diferenciales centrales.

#### Scenario: Configuracion multirrueda admisible
- **WHEN** se instancia la plataforma UGV para una misión determinada
- **THEN** el número de ruedas del tren de rodaje MUST satisfacer la multiplicidad `numeroRuedas >= 4 and numeroRuedas <= 8`.

### Requirement: Suspension neumatica regulable y retractil
El tren de rodaje SHALL integrar un sistema de suspensión neumática independiente en cada brazo de rueda (RLT1-05), capaz de alternar entre un modo de transporte retráctil y un modo de operación con altura libre al suelo de al menos 350 mm.

#### Scenario: Modo transporte con retraccion
- **WHEN** el vehículo se acondiciona para transporte en bodega o estiba
- **THEN** la suspensión neumática MUST retraerse para reducir la altura total del UGV.

#### Scenario: Modo operacion todoterreno
- **WHEN** la plataforma opera en entorno táctico de movilidad campo a través
- **THEN** la suspensión MUST mantener una altura libre al suelo `alturaLibreSueloMm >= 350.0`.

### Requirement: Prestaciones de movilidad y servodireccion
La plataforma UGV SHALL incorporar servodirección activa y alcanzar las prestaciones de movilidad táctica estipuladas en el pliego (RLT1-03), incluyendo velocidades mínimas de 75 km/h en carretera y 50 km/h campo a través, y capacidad de superación de pendientes de hasta 60%.

#### Scenario: Prestaciones de velocidad todoterreno
- **WHEN** el vehículo se desplaza en condiciones operativas estándar
- **THEN** la velocidad máxima alcanzable MUST ser `>= 75.0 km/h` en carretera y `>= 50.0 km/h` en campo a través.

#### Scenario: Capacidad de maniobra y giro
- **WHEN** se ejecutan maniobras en espacios confinados o entornos de alta exigencia
- **THEN** la servodirección multieje MUST coordinar el ángulo o sentido de giro de las ruedas para permitir giros cerrados y pivote sobre su eje.
