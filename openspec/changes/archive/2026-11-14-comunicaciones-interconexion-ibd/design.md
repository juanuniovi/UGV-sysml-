# Design: Interconexión Integral de Comunicaciones y Topología IBD

## Context

El archivo `Modelos/05_comunicaciones.sysml` poseía únicamente formalizada la parte `RadioEnlaceTacticoLOS` (`RCOM-01`), mientras que el resto de componentes figuraban como declaraciones genéricas sin tipar. Por otra parte, en `Modelos/09_sistema_ugv.sysml` y `Modelos/11_vistas.sysml` ya existían puertos de interfaz definidos por Navegación (`c_nav_video_comms`) y Control (`c_bus_comms_control`, `c_comms_frenado_ctrl`). Se requiere consolidar la arquitectura completa del subsistema de comunicaciones tácticas para satisfacer `RCOM-02`, `RCOM-03` y `RSW-06`, permitiendo generar la vista de interconexión (IBD) en Spec42.

## Goals / Non-Goals

**Goals:**
- Descomponer `SistemaComunicacionesEmbarcado` en todas sus partes funcionales y físicas tipadas.
- Formalizar los requisitos `RCOM-02`, `RCOM-03` y `RSW-06` con bloques `requirement def` y cláusulas `satisfy`.
- Modelar los puertos internos de radiofrecuencia, buses de datos, vídeo y disparo de frenado de seguridad.
- Modelar los ítems de flujo tipados de mando, telemetría y latido (*heartbeat*).
- Actualizar `vistaConexionesComunicaciones` en `11_vistas.sysml` para generar la vista IBD de interconexión con estaciones de mando y subsistemas de a bordo.
- Garantizar 0 errores y 0 avisos en la validación sintáctica.

**Non-Goals:**
- No se modifican los subsistemas mecánicos (Barcaza, Tren de Rodaje ni Planta Motriz).
- No se alteran los requisitos vigentes ni sus identificadores contractuales.
- No se tocan las implementaciones internas de visión por computador ni la fusión sensorial de GNC.

## Decisions

### 1. Descomposición Modular de Comunicaciones
* **Decisión**: Modelar 6 partes específicas dentro de `SistemaComunicacionesEmbarcado`:
  - `radioEnlaceTacticoLOS : RadioEnlaceTacticoLOS` (Canal 1º Orden, CPT).
  - `radioEnlaceTacticoBLOS : RadioEnlaceTacticoBLOS` (Canal 2º Orden PMP / 3º Orden Relé UAV).
  - `radioTacticaMilitarCNR : RadioTacticaMilitarCNR` (Canal 4º Orden Respaldo / C4I).
  - `moduloCifradoCOMSEC : ModuloCifradoCOMSEC` (Criptoprocesador AES-256 GCM).
  - `gestorRedundanciaYQoS : GestorRedundanciaYQoS` (Planificador de colas QoS).
  - `supervisorEnlaceWatchdog : SupervisorEnlaceWatchdog` (Temporizador de latido 200 ms).
  - `sistemaAntenas : SistemaAntenasEmbarcado` (Conjunto de antenas en techo).
* **Alternativa descartada**: Mantener un único transceptor genérico monopuesto. Se descarta porque violaría la doctrina de redundancia ante fallo y la interoperabilidad OTAN.

### 2. Pila de Protocolos Tipada y Calidad de Servicio (`RSW-06`)
* **Decisión**: Formalizar ítems de datos específicos (`ComandoControlBLOS`, `TrazaTacticaBMS`, `HeartbeatEnlace`) y definir atributos de prioridad en el gestor de colas:
  - Prioridad 1: Telemando y Frenado (latencia < 20 ms).
  - Prioridad 2: Waypoints C2 y Odometría VIO.
  - Prioridad 3: Trazas BMS-ET de batallón.
  - Prioridad 4: Vídeo H.265 (canal degenerable o desconectable en radio CNR).

### 3. Trazabilidad Contractual Rigurosa
* **Decisión**: Cada requisito formal se modela con bloque `requirement def` dedicado y se vincula mediante `satisfy requirement : Req... by ...;` a su respectivo componente.

### 4. Vista de Interconexión en `11_vistas.sysml`
* **Decisión**: Configurar la vista `vistaConexionesComunicaciones : InterconnectionView` para exponer `SubsistemaComunicaciones::SistemaComunicacionesEmbarcado` y los enlaces clave con las cámaras de navegación y el módulo de frenado de control.

## Risks / Trade-offs

- **[Riesgo de saturación por vídeo 360°]** $\rightarrow$ **Mitigación**: El gestor QoS asigna prioridad baja (*Best Effort*) al puerto `entradaVideoTeleoperacion` y garantiza derecho de paso absoluto al bus de telemando (`dataBus`).
- **[Riesgo de corte prolongado de radio]** $\rightarrow$ **Mitigación**: El `SupervisorEnlaceWatchdog` actúa de forma autónoma disparando por `salidaInhabilitacionFrenado` si transcurren más de 1.000 ms sin latido, forzando la retención activa de frenos en GNC (`RGEN-17`).
