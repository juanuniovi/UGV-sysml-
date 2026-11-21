# Spec Delta

## MODIFIED Requirements

### Requirement: Protocolos tacticos y calidad de servicio con priorizacion de telemando
El subsistema de comunicaciones SHALL implementar una pila de protocolos tácticos con calidad de servicio (QoS) estricta estructurada en una cadena jerárquica de conmutación ante fallos de 5 órdenes (Plan PACE), priorizando de forma no bloqueante las órdenes críticas de guiado y frenado frente a los flujos multimedia de vídeo según `RSW-06`.

#### Scenario: Priorizacion estricta de paquetes de joystick y freno
- **WHEN** concurren en el bus de salida tramas pesadas de vídeo panorámico 360° y consignas de control reactivo de joysticks o frenado
- **THEN** el gestor de colas QoS MUST despachar de inmediato los paquetes de control en la cola de máxima prioridad (*Expedited Forwarding*) con latencia menor a 20 ms.

#### Scenario: Degradacion adaptativa de video ante perdida de ancho de banda
- **WHEN** la tasa de pérdida de paquetes supera el 15% o el canal de radio reduce su ancho de banda útil
- **THEN** el flujo de vídeo MUST reducir adaptativamente su resolución o fotogramas, o apagarse al 100% en canal de radio militar VHF, sin degradar el telemando.

#### Scenario: Conmutacion ordenada del Plan PACE (1º al 4º orden)
- **WHEN** el canal activo sufre atenuación orográfica, alcance excesivo o degradación severa (pérdida de paquetes > 15% o RSSI < -85 dBm)
- **THEN** el gestor de comunicaciones MUST conmutar de forma secuencial y limpia entre los niveles disponibles: 1º Orden LOS (CPT), 2º Orden BLOS (PMP), 3º Orden Relé UAV (`RCOM-02`) y 4º Orden Radio Militar CNR (VHF).

#### Scenario: Politica de degradacion y corte de video en respaldo militar
- **WHEN** la comunicación conmuta al 4º Orden (Radio Militar de Combate CNR en VHF)
- **THEN** el subsistema de comunicaciones MUST apagar el flujo de vídeo al 100% (0 Mbps) para reservar el canal íntegramente a las consignas de telemando y trazas C2.

#### Scenario: Histeresis de retorno para evitar oscilaciones
- **WHEN** un enlace de orden superior recupera su señal y estabilidad
- **THEN** el gestor de comunicaciones MUST exigir un tiempo de estabilización mínimo de 3 segundos continuos sin fluctuaciones antes de retornar al orden superior.

#### Scenario: Disparo de 5º orden (Failsafe critico) por perdida total de latido
- **WHEN** transcurren más de 1.000 ms sin recibir tramas válidas de latido (*heartbeat*) en ninguno de los canales activos
- **THEN** el subsistema de comunicaciones MUST activar de inmediato el 5º Orden emitiendo orden directa de frenado de emergencia hacia el subsistema de control (`RGEN-17`).
