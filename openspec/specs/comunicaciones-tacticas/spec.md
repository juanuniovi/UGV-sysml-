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

### Requirement: Enlace tactico fuera de linea de vista (BLOS) y rele aereo con UAV
El subsistema de comunicaciones embarcado SHALL proporcionar un canal de radiofrecuencia táctico fuera de línea de vista (BLOS) para el mando y control a larga distancia desde el Puesto de Mando Portable (PMP), y SHALL soportar el enlace de relé aéreo a través del transpondedor del UAV cenital embarcado según `RCOM-02`.

#### Scenario: Operacion remota a larga distancia desde PMP
- **WHEN** el vehículo opera fuera de línea de visión directa del Puesto de Mando Portable (PMP)
- **THEN** el transceptor BLOS MUST mantener el enlace de mando y control de misión y telemetría táctica con un alcance nominal mayor o igual a 5 km (`alcanceNominalKm >= 5.0`).

#### Scenario: Reenvio de haz por rele aereo del UAV cenital
- **WHEN** la orografía del terreno interrumpe el haz directo entre el UGV y el PMP
- **THEN** el subsistema de comunicaciones MUST conmutar el flujo táctico hacia el puerto `rfPortRelay` del UAV cenital elevado para retransmitir las órdenes C2 y el vídeo de misión.

### Requirement: Seguridad de comunicaciones COMSEC y proteccion electronica
El subsistema de comunicaciones SHALL implementar cifrado hardware de grado militar punto a punto (COMSEC) y protección contra contramedidas electrónicas y perturbación intencionada (*anti-jamming*) según `RCOM-03`.

#### Scenario: Cifrado integral de flujos salientes y entrantes
- **WHEN** transitan comandos de control, telemetría o flujos de vídeo a través de cualquier transceptor de radio
- **THEN** el módulo de cifrado hardware MUST encriptar y autenticar todas las tramas utilizando algoritmo criptográfico robusto (AES-256 GCM) antes de su modulación de radiofrecuencia.

#### Scenario: Resistencia frente a guerra electronica y modo sigiloso
- **WHEN** se detecta interferencia intencionada o el operador activa el modo SIGILOSO (`RGEN-09`)
- **THEN** el transceptor MUST aplicar técnicas de salto ágil de frecuencia (FHSS) o atenuar la potencia radiada según la directiva del gestor de emisiones.

### Requirement: Protocolos tacticos y calidad de servicio con priorizacion de telemando
El subsistema de comunicaciones SHALL implementar una pila de protocolos tácticos con calidad de servicio (QoS) estricta que priorice de forma no bloqueante las órdenes críticas de guiado y frenado frente a los flujos multimedia de vídeo según `RSW-06`.

#### Scenario: Priorizacion estricta de paquetes de joystick y freno
- **WHEN** concurren en el bus de salida tramas pesadas de vídeo panorámico 360° y consignas de control reactivo de joysticks o frenado
- **THEN** el gestor de colas QoS MUST despachar de inmediato los paquetes de control en la cola de máxima prioridad (*Expedited Forwarding*) con latencia menor a 20 ms.

#### Scenario: Degradacion adaptativa de video ante perdida de ancho de banda
- **WHEN** la tasa de pérdida de paquetes supera el 15% o el canal de radio reduce su ancho de banda útil
- **THEN** el flujo de vídeo MUST reducir adaptativamente su resolución o fotogramas, o apagarse al 100% en canal de radio militar VHF, sin degradar el telemando.

### Requirement: Interconexion y supervision failsafe de enlace con parada de seguridad
El subsistema de comunicaciones SHALL monitorizar continuamente el latido de enlace (*heartbeat*) y SHALL emitir una orden directa de frenado de seguridad hacia el subsistema de control en caso de pérdida total de señal según `RGEN-17`.

#### Scenario: Disparo de frenado automatico por timeout de enlace
- **WHEN** transcurre un tiempo superior a 1.000 ms sin recibir tramas válidas de latido en ninguno de los canales activos (LOS, BLOS, UAV o CNR)
- **THEN** el supervisor watchdog de comunicaciones MUST activar una señal de alarma inmediata por el puerto `salidaInhabilitacionFrenado` hacia `control.moduloFrenadoSeguridad` para detener el vehículo.
