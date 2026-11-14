# Tasks: Interconexión Integral de Comunicaciones y Topología IBD

## 1. Descomposición Estructural y Tipos de Datos en `05_comunicaciones.sysml`

- [x] 1.1 Declarar los ítems de flujo tipados de información: `ComandoControlBLOS` (órdenes C2 STANAG 4586), `TrazaTacticaBMS` (mensajería Blue Force Tracking) y `HeartbeatEnlace` (trama periódica de sincronización).
- [x] 1.2 Definir las partes transceptoras y criptográficas: `RadioEnlaceTacticoBLOS` (SDR táctico para enlace de larga distancia y relé UAV), `RadioTacticaMilitarCNR` (VHF de combate para respaldo militar y red de batallón), `ModuloCifradoCOMSEC` (chip criptográfico hardware AES-256 GCM) y `SistemaAntenasEmbarcado`.
- [x] 1.3 Definir los módulos de gestión de tráfico y seguridad: `GestorRedundanciaYQoS` (planificador de colas prioritarias P1 a P4) y `SupervisorEnlaceWatchdog` (temporizador de latido 200 ms con salida de disparo hacia frenado).

## 2. Formalización de Requisitos del Pliego y Trazabilidad `satisfy`

- [x] 2.1 Formalizar el requisito contractual `ReqEnlaceTacticoBLOS` (`RCOM-02`) para control a larga distancia y compatibilidad de relé aéreo con el UAV cenital.
- [x] 2.2 Formalizar el requisito contractual `ReqSeguridadComunicacionesCOMSEC` (`RCOM-03`) para cifrado hardware, protección EW/anti-jamming y salto ágil de frecuencia (FHSS).
- [x] 2.3 Formalizar el requisito contractual `ReqProtocolosTacticosYQoS` (`RSW-06`) para serialización robusta y priorización estricta de joysticks/frenado frente a vídeo.
- [x] 2.4 Incorporar las partes tipadas dentro de `SistemaComunicacionesEmbarcado` y vincular formalmente las cláusulas de trazabilidad `satisfy requirement`.

## 3. Consolidación de Interconexiones y Vista IBD

- [x] 3.1 Verificar y consolidar las conexiones de radiofrecuencia externas (`c_rf_los`, `c_rf_blos`, `c_rf_uav`) y los enlaces internos de vídeo (`c_nav_video_comms`), bus de control (`c_bus_comms_control`), frenado prioritario (`c_comms_frenado_ctrl`) y modo sigiloso (`c_comms_modo_nav`) en `Modelos/09_sistema_ugv.sysml`.
- [x] 3.2 Actualizar y verificar la vista `vistaConexionesComunicaciones : InterconnectionView` en `Modelos/11_vistas.sysml` para exponer la topología completa IBD.

## 4. Validación y Cierre

- [x] 4.1 Comprobar la coherencia sintáctica SysML v2 y registrar el resultado de validación.
- [x] 4.2 Validar el cambio de OpenSpec mediante `openspec validate comunicaciones-interconexion-ibd`.
