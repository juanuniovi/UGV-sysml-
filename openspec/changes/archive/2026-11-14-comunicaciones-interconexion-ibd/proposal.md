# Proposal: Interconexión Integral de Comunicaciones y Topología IBD

## Why

El subsistema de comunicaciones en `Modelos/05_comunicaciones.sysml` únicamente formaliza de manera preliminar el enlace de corto alcance LOS (`RCOM-01`), manteniendo como marcadores (*stubs*) vacíos los componentes de largo alcance BLOS, el relé aéreo y la ciberseguridad COMSEC.

Para garantizar la operación completa del UGV según el pliego del CDTI y responder a la necesidad técnica de interconexión con las estaciones externas (Puesto de Mando PMP, Consola CPT y UAV cenital) y los subsistemas de a bordo (cámaras de navegación, buses de control y frenado de emergencia), es necesario formalizar la descomposición estructural completa en SysML v2, definir los requisitos del pliego pendientes (`RCOM-02`, `RCOM-03`, `RSW-06`) y generar la vista de interconexión arquitectónica (IBD) que modele el flujo de joysticks, vídeo y seguridad.

## What Changes

- **En `Modelos/05_comunicaciones.sysml`**:
  - Modelado formal de las partes específicas:
    - `RadioEnlaceTacticoBLOS`: Transceptor MANET táctico para enlace a larga distancia con PMP y relé con UAV (`RCOM-02`).
    - `RadioTacticaMilitarCNR`: Transceptor VHF de combate militar (PR4G / SDR ESSOR) para respaldo táctico y red BMS-ET.
    - `ModuloCifradoCOMSEC`: Procesador criptográfico hardware (AES-256 GCM) y salto ágil de frecuencia FHSS (`RCOM-03`).
    - `GestorRedundanciaYQoS`: Controlador de calidad de servicio para priorización estricta de paquetes (joysticks/frenado sobre vídeo) según `RSW-06`.
    - `SupervisorEnlaceWatchdog`: Monitorización de latido (*heartbeat* cada 200 ms) y disparo de frenado por *timeout* > 1.000 ms (`RGEN-17`).
    - `SistemaAntenasEmbarcado`: Conjunto de antenas exteriores de techo rugerizadas MIL-STD-810H y estancas al vadeo (`RLT1-10`).
  - Formalización de requisitos contractuales:
    - `ReqEnlaceTacticoBLOS` (`RCOM-02`).
    - `ReqSeguridadComunicacionesCOMSEC` (`RCOM-03`).
    - `ReqProtocolosTacticosYQoS` (`RSW-06`).
  - Relaciones `satisfy` correspondientes en `SistemaComunicacionesEmbarcado`.
  - Definición completa de puertos tipados internos y de frontera.
- **En `Modelos/09_sistema_ugv.sysml`**:
  - Verificación y consolidación de los enlaces RF externos (`c_rf_los`, `c_rf_blos`, `c_rf_uav`).
  - Consolidación de los enlaces internos del UGV (`c_nav_video_comms`, `c_bus_comms_control`, `c_comms_frenado_ctrl`, `c_comms_modo_nav`).
- **En `Modelos/11_vistas.sysml`**:
  - Actualización de `vistaConexionesComunicaciones` para exponer la topología completa IBD entre estaciones externas, comunicaciones, cámaras de navegación y frenado de control.

## Capabilities

### New Capabilities
<!-- Ninguna capability completamente nueva; se evoluciona la existente de comunicaciones tácticas. -->

### Modified Capabilities
- `comunicaciones-tacticas`: Se añaden formalmente los requisitos `RCOM-02` (enlace táctico BLOS y relé aéreo UAV), `RCOM-03` (seguridad COMSEC y protección EW/jamming) y `RSW-06` (protocolos tácticos y colas QoS con prioridad de telemando frente a vídeo), garantizando la interconexión con las cámaras de navegación y el módulo de frenado de control.

## Impact

- **Archivos de modelo afectados**:
  - `Modelos/05_comunicaciones.sysml` (desarrollo estructural y requisitos completos).
  - `Modelos/09_sistema_ugv.sysml` (conexiones entre subsistemas consolidadas).
  - `Modelos/11_vistas.sysml` (vista IBD de comunicaciones actualizada).
- **Trazabilidad de requisitos**:
  - Incorpora formalmente `RCOM-02`, `RCOM-03` y `RSW-06`.
  - Mantiene intacta la trazabilidad con `RCOM-01`, `RGEN-01`, `RGEN-04`, `RGEN-09`, `RGEN-17`, `RGEN-20`, `RGEN-22`, `RLT1-08`, `RLT1-10` y `ROPE-01..03`.
- **Verificación**:
  - Coherencia tipada con `TiposBase` y directivas `private import`.
  - Cero errores y cero avisos en Spec42.
