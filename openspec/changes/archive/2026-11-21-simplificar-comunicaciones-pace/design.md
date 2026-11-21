# Design

## Context

El subsistema de comunicaciones actual implementa la totalidad de la lógica técnica requerida por el pliego, pero adolece de sobrecarga de micro-conexiones, puertos auxiliares y definiciones excesivas en SysML v2.
Véase `proposal.md` para la motivación y el documento de referencia del equipo `Modelos/definicion_protocolos_principales.md` para la definición de la cadena de conmutación.

## Goals / Non-Goals

**Goals:**
- Simplificar el código de `Modelos/05_comunicaciones.sysml` reduciendo la complejidad sintáctica y el número de conectores internos a los estrictamente necesarios.
- Hacer explícitos y directamente legibles los **5 niveles del Plan PACE**:
  1. Radio Directa LOS 2.4 GHz (UDP + micro-DDS) con Consola CPT.
  2. Red Táctica MANET / SDR BLOS (STANAG 4586 / JAUS) con Puesto de Mando PMP.
  3. Relé Aéreo con UAV Cenital Embarcado (STANAG 4586, `RCOM-02`).
  4. Radio Táctica Militar CNR VHF 30–88 MHz (BMS-ET, vídeo apagado 100%).
  5. Parada Automática de Emergencia por timeout de heartbeat > 1.000 ms (`RGEN-17`).
- Reducir y limpiar las vistas de interconexión en `Modelos/11_vistas.sysml` (`vistaConexionesComunicaciones` y `vistaInternaComunicaciones`), de modo que Spec42 renderice diagramas limpios, legibles y sin saturación de elementos.
- Preservar al 100% los requisitos contractuales del pliego y sus relaciones `satisfy` únicas.

**Non-Goals:**
- No se alteran ni eliminan requisitos contractuales vigentes (`RCOM-01`, `RCOM-02`, `RCOM-03`, `RSW-06`, `RGEN-09`, `RGEN-17`, `RLT1-10`).
- No se modifican las interfaces externas de la plataforma UGV (los puertos de contorno hacia la barcaza, planta motriz, GNC y estaciones se mantienen compatibles).
- No se agregan nuevas tecnologías de radio fuera de las contempladas en el pliego y en el documento de trabajo del equipo.

## Decisions

1. **Centralización en el Gestor de Redundancia y PACE (`GestorRedundanciaPACE`)**:
   - *Decisión*: Agrupar la gestión de colas QoS, la supervisión de latido (*heartbeat*) y la máquina de conmutación ante fallos dentro de una parte clara y legible (`gestorPACE`), en lugar de dispersarla en múltiples submódulos y micro-conectores intermediarios.
   - *Alternativa considerada*: Mantener módulos separados para watchdog, colas QoS y conmutación de RF. Descartada porque generaba 16 micro-conectores internos que saturaban el IBD en Spec42.

2. **Tipado directo de flujos de datos (`item def`) asociados a cada nivel**:
   - *Decisión*: Mantener únicamente 4 tipos de datos claros:
     - `FlujoTelemandoLOS`: UDP + micro-DDS con FEC (50 Hz, <20 ms).
     - `FlujoMandoBLOS`: STANAG 4586 / JAUS sobre MANET IP (<150 ms).
     - `FlujoVideoConduccion`: STANAG 4609 / H.265 (adaptativo / apagado en VHF).
     - `TramaHeartbeat`: Sincronización y disparo failsafe (timeout 1.000 ms).
   - *Alternativa considerada*: Tipar cada subprotocolo con atributos secundarios y cabeceras redundantes. Descartada por complejidad innecesaria en el modelo arquitectónico.

3. **Simplificación drástica de las vistas en `Modelos/11_vistas.sysml`**:
   - *Decisión*:
     - `vistaConexionesComunicaciones`: Enfoque a nivel de caja negra / frontera del sistema. Expone las estaciones (CPT, PMP, UAV) y los puertos exteriores de RF y datos del vehículo.
     - `vistaInternaComunicaciones`: Enfoque a nivel de arquitectura interna. Expone únicamente las 4 radios/canales, el gestor PACE, el módulo COMSEC y las antenas, evitando exponer cada conector individual que genera maraña visual en Spec42.
   - *Alternativa considerada*: Conservar todas las exposiciones de micro-conectores individuales. Descartada porque el usuario indicó explícitamente "disminuye las vistas de conexinos".

## Risks / Trade-offs

- **[Riesgo]** Al simplificar conectores internos, Spec42 podría omitir conexiones si no están explícitamente enlazadas en los puertos de contorno.
  - *Mitigación*: Asegurar que los puertos externos del subsistema (`rfPortLOS`, `rfPortBLOS`, `rfPortCNR`, `dataBus`, `salidaInhabilitacionFrenado`, etc.) se conectan directamente a las partes funcionales correspondientes.
- **[Riesgo]** Regresión en la satisfacción de requisitos (`satisfy`).
  - *Mitigación*: Mantener cada `satisfy requirement : Req... by <parte>;` en el bloque principal `SistemaComunicacionesEmbarcado` respetando la regla preventiva de satisfacción única.
