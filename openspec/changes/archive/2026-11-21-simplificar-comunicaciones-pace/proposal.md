# Proposal

## Why

El modelo actual del subsistema de comunicaciones (`Modelos/05_comunicaciones.sysml`) y sus vistas asociadas en `Modelos/11_vistas.sysml` acumularon una complejidad excesiva (demasiados micro-conectores punto a punto, tipos de datos fragmentados y vistas IBD sobrecargadas). Esto dificulta visualizar de manera rápida e intuitiva lo que el equipo acordó formalmente en `Modelos/definicion_protocolos_principales.md`: los **5 protocolos y niveles de conmutación por fallo (Plan PACE)** ante degradación del enlace en el UGV pesado dual.

Esta propuesta simplifica y reestructura el código del modelo para hacerlo mucho más legible y directo, disminuye y enfoca las vistas de interconexión para Spec42, y preserva con rigor todos los requisitos contractuales del pliego (`RCOM-01`, `RCOM-02`, `RCOM-03`, `RSW-06`, `RGEN-09`, `RGEN-17`, `RLT1-10`).

## What Changes

- **Simplificación del modelo SysML v2 (`Modelos/05_comunicaciones.sysml`)**:
  - Modelar de forma limpia, directa y estructurada los **5 órdenes del Plan PACE** definidos por el equipo:
    1. **1º Orden (Principal)**: Radio Táctica LOS 2.4 GHz (`UDP + micro-DDS con FEC`) con Consola Ligera (CPT).
    2. **2º Orden (Alternativo)**: Red Táctica MANET / SDR BLOS (`STANAG 4586 / JAUS`) con Puesto de Mando (PMP).
    3. **3º Orden (Contingencia)**: Relé Aéreo con UAV Cenital Embarcado (`STANAG 4586`, `RCOM-02`).
    4. **4º Orden (Respaldo Militar)**: Radio Táctica Militar CNR VHF 30–88 MHz (`Telegramas BMS-ET / C2`, vídeo apagado al 100%).
    5. **5º Orden (Failsafe Crítico)**: Parada Automática de Emergencia por timeout de heartbeat > 1.000 ms (`RGEN-17`).
  - Reducir la maraña de conectores internos secundarios y tipos de datos fragmentados, agrupando los canales de radio en torno al gestor de redundancia PACE y el bus principal.
  - Mantener los bloques normativos `requirement def` y las relaciones `satisfy` con regla de nivel único.

- **Disminución y enfoque de las vistas de conexiones (`Modelos/11_vistas.sysml`)**:
  - Simplificar `vistaConexionesComunicaciones` para exponer únicamente los componentes clave de la interconexión (CPT, PMP, UAV, UGV) y sus puertos principales de RF, datos y vídeo, eliminando la sobrecarga visual de micro-conectores.
  - Refactorizar `vistaInternaComunicaciones` para que muestre claramente la cadena de fallo PACE sin duplicidades ni saturación en Spec42.

## Capabilities

### Modified Capabilities
- `comunicaciones-tacticas`: Se actualiza la especificación delta para recoger la simplificación arquitectónica de la conmutación en 5 órdenes PACE, la política de failover y la reducción de sobrecarga en las vistas de interconexión, manteniendo intactos todos los requisitos contractuales y umbrales numéricos.

## Impact

- **Archivos de modelo afectados**:
  - `Modelos/05_comunicaciones.sysml` (simplificación de partes, items de flujo y conectores internos).
  - `Modelos/11_vistas.sysml` (simplificación de `vistaConexionesComunicaciones` y `vistaInternaComunicaciones`).
- **Subsistemas interconectados**: Sin impacto negativo en interfaces externas. Se preservan intactos los puertos exteriores hacia la plataforma (`dataBus`, `powerInput`, `chassisMount`, `rfPortLOS`, `rfPortBLOS`, `rfPortCNR`, `salidaInhabilitacionFrenado`, `salidaModoDeteccion`, `entradaVideoTeleoperacion`).
- **Trazabilidad y requisitos**: Se auditan y mantienen al 100% los identificadores `RCOM-01`, `RCOM-02`, `RCOM-03`, `RSW-06`, `RGEN-09`, `RGEN-17` y `RLT1-10`.
