# planta-motriz-caja-negra Specification

## Purpose
Describir la planta motriz híbrida del UGV como caja negra (Fase 0, Issue #4): necesidades de las partes interesadas, frontera y contexto con sus interfaces externas, casos de uso con secuencias de contexto y medidas de efectividad (MoEs) con umbral y objetivo, sin entrar en soluciones técnicas internas.

## Requirements

### Requirement: Separación entre caja negra y caja blanca
El análisis de caja negra SHALL modelarse en un subpaquete propio dentro de `Modelos/03_planta_motriz.sysml`, sin referenciar partes, puertos internos ni conexiones de la estructura interna de `PlantaMotrizHibrida`.

#### Scenario: Solo el archivo del autor y sin vistas
- **WHEN** se ejecuta `git diff main -- Modelos/` tras el cambio
- **THEN** el único `.sysml` modificado MUST ser `03_planta_motriz.sysml` y MUST NOT añadirse ni modificarse ningún `view`.

#### Scenario: Caja blanca intacta
- **WHEN** se compara `03_planta_motriz.sysml` con su versión anterior al cambio
- **THEN** los puertos, bloques, conexiones, atributos y requisitos existentes MUST permanecer idénticos y el contenido nuevo MUST estar dentro del subpaquete de caja negra.

#### Scenario: Sin elementos internos en la caja negra
- **WHEN** se inspecciona el subpaquete de caja negra
- **THEN** MUST NOT aparecer el depósito, el motor, el generador, las baterías, la distribución, el convertidor, el PMS ni el módulo de exportación.

### Requirement: Partes interesadas y necesidades
El subpaquete SHALL declarar las partes interesadas de la planta motriz (operador de misión, mantenedor de primer escalón, logística de combustible y cliente contratante) y una necesidad por cada interés relevante, redactada en lenguaje del usuario y trazada a la cláusula del pliego que la origina.

#### Scenario: Necesidad trazada al pliego
- **WHEN** se inspecciona cualquier necesidad de la planta motriz
- **THEN** su documentación MUST citar al menos un identificador auditado (`RGEN-06`, `RGEN-10..16`, `RGEN-18`, `RGEN-19`, `RLT1-04`, `RLT1-08..10`) y la parte interesada que la expresa.

#### Scenario: Necesidad opcional rotulada
- **WHEN** una necesidad procede de una cláusula marcada como [OPCIONAL] en el pliego (`RGEN-18`, `RGEN-19`)
- **THEN** su documentación MUST indicar expresamente que es opcional.

### Requirement: Frontera del sistema de interés
El modelo SHALL documentar la frontera de la planta motriz: dentro, la generación, el almacenamiento, la gestión y la distribución de energía; fuera, los motores de tracción por rueda (`RLT1-04`), el control de misión, la aviónica, las cargas de pago, el UAV y el entorno.

#### Scenario: Motores de rueda fuera de la frontera
- **WHEN** se consulta la frontera del sistema de interés
- **THEN** los motores de tracción por rueda MUST figurar como sistema externo (tren de rodaje) y la planta MUST intercambiar con ellos solo potencia eléctrica.

### Requirement: Bloque de caja negra con interfaces externas
El subpaquete SHALL definir un único bloque que represente la planta motriz como caja negra, cuyos puertos cubran todo el intercambio de energía, materia e información con el exterior. Cada interfaz SHALL clasificarse como energía, materia o información.

#### Scenario: Interfaces de energía
- **WHEN** se inspeccionan los puertos del bloque de caja negra
- **THEN** MUST existir interfaces para la potencia de tracción con regeneración (bidireccional), la potencia de baja tensión para la aviónica, la potencia para la carga de pago y el UAV, la exportación a consumidores externos (`RGEN-19`, opcional) y la recarga enchufable (`RGEN-18`, opcional).

#### Scenario: Interfaces de materia
- **WHEN** se inspeccionan los puertos del bloque de caja negra
- **THEN** MUST existir interfaces para la entrada de biocombustible (`RGEN-11`), la admisión de aire, la salida de gases de escape y la disipación de calor y ruido hacia el entorno (firma, `RGEN-13`), y la fijación mecánica a la barcaza.

#### Scenario: Interfaces de información
- **WHEN** se inspeccionan los puertos del bloque de caja negra
- **THEN** MUST existir una interfaz de información con el subsistema de Control para recibir órdenes de modo energético y devolver el estado de energía.

### Requirement: Diagrama de contexto
El subpaquete SHALL definir un bloque de contexto con la planta de caja negra como bloque central, rodeada de los actores humanos, los sistemas externos y los elementos de entorno, todos conectados con ella por las interfaces externas.

#### Scenario: Contexto completo visible
- **WHEN** se inspecciona el bloque de contexto de la planta motriz
- **THEN** MUST contener la planta como único bloque central, sin partes internas, conectada con Control, el tren de rodaje, la barcaza, la aviónica, la carga de pago y el UAV, los consumidores externos, el punto de recarga, el suministro de combustible, el mantenedor y el entorno (agentes ambientales, agua de vadeo y atmósfera).

#### Scenario: Toda interfaz conectada
- **WHEN** se revisan los puertos del bloque de caja negra dentro del contexto
- **THEN** cada puerto MUST estar conectado con al menos un actor, sistema externo o elemento de entorno.

### Requirement: Casos de uso de la planta motriz
El subpaquete SHALL definir casos de uso con la planta de caja negra como sujeto: propulsar en modo híbrido, propulsar en modo puramente eléctrico sigiloso, recargar las baterías (motor y regeneración), alimentar la aviónica, alimentar la carga de pago y el UAV, exportar energía (opcional), recarga enchufable (opcional) y repostar y mantener.

#### Scenario: Actores asociados
- **WHEN** se inspecciona cualquier caso de uso de la planta motriz
- **THEN** MUST declarar la planta de caja negra como sujeto y al menos un actor del contexto.

### Requirement: Especificación textual de cada caso de uso
Cada caso de uso SHALL documentar su objetivo, sus precondiciones, sus postcondiciones, su escenario principal y al menos un escenario alternativo o de excepción, siempre desde el punto de vista externo.

#### Scenario: Especificación completa
- **WHEN** se lee la documentación de cualquier caso de uso de la planta
- **THEN** MUST contener los apartados de objetivo, precondiciones, postcondiciones, escenario principal y escenarios alternativos o de excepción.

#### Scenario: Excepción de energía insuficiente en modo sigiloso
- **WHEN** se lee el caso de uso «propulsar en modo puramente eléctrico»
- **THEN** MUST describir como excepción el agotamiento de las baterías y la respuesta observable de la planta hacia Control.

### Requirement: Secuencias de contexto caja negra
El modelo SHALL describir, al menos para propulsar en modo híbrido, propulsar en modo puramente eléctrico y exportar energía, la secuencia ordenada de mensajes y flujos que entran y salen de la planta, con cada mensaje tipado y sin participantes internos.

#### Scenario: Secuencia de paso a modo sigiloso
- **WHEN** se inspecciona la secuencia del caso de uso de modo puramente eléctrico
- **THEN** MUST aparecer, en orden, la orden de modo desde Control, la confirmación o el rechazo de la planta, el suministro de potencia de tracción solo desde baterías y el informe periódico de estado de energía.

### Requirement: Medidas de efectividad con umbral y objetivo
El bloque de caja negra SHALL declarar MoEs, cada una con unidad explícita, valor umbral y valor objetivo. El umbral SHALL coincidir con la cláusula auditada del pliego; el objetivo SHALL proceder del pliego (opción o deseable) o declararse «sin fijar».

#### Scenario: MoEs mínimas
- **WHEN** se inspeccionan las MoEs de la planta motriz
- **THEN** MUST existir como mínimo potencia de propulsión (umbral 140 kW, `RLT1-09`), autonomía total (8 h o 400 km, `RGEN-14`), autonomía eléctrica (2 h o 100 km, `RGEN-15`), biocombustible 100 % (`RGEN-11`), recarga por motor y regeneración (`RGEN-12`), potencia exportable (objetivo 120 kW, `RGEN-19`), recarga enchufable (objetivo, `RGEN-18`) y vadeo sin preparación (0,75 m, `RLT1-10`).

#### Scenario: Valores no inventados
- **WHEN** una MoE no tiene valor en el pliego (por ejemplo, la cuota de masa de la planta dentro de los 9.000 kg de `RLT1-08`, o una disponibilidad o MTBF)
- **THEN** su documentación MUST indicar «sin valor en el pliego; a fijar por el equipo» y MUST NOT llevar una cifra inventada.

#### Scenario: Disyunción del pliego respetada
- **WHEN** se evalúan las MoEs de autonomía
- **THEN** el criterio umbral MUST cumplirse si se alcanza la duración **o** la distancia, tal como dicen `RGEN-14` y `RGEN-15`.

### Requirement: Preservación de requisitos existentes
El cambio SHALL dejar intactos todos los requisitos existentes del modelo, incluidas las discrepancias con el pliego detectadas en la auditoría, que solo se registrarán.

#### Scenario: Validación sin regresiones
- **WHEN** se ejecuta `spec42 check Modelos` tras el cambio
- **THEN** el resultado MUST ser 0 errores y 0 avisos, y `ReqPotenciaMinimaPlataforma`, `ReqExportacionEnergia` y los requisitos de `09_sistema_ugv.sysml` MUST mantener su texto y sus restricciones.
