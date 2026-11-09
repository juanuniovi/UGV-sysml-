# Design

## Context

El requisito **RGEN-17** establece que el UGV debe incorporar una función de frenado automático ante riesgo de colisión que actúe de forma progresiva siempre que sea posible y que pueda ser inhabilitada manualmente para evitar bloqueos por falsos señuelos enemigos. Siguiendo el mismo patrón de interfaz directa desde Comunicaciones acordado para `RGEN-09`, el usuario solicita añadir un puerto directo en `SistemaComunicacionesEmbarcado` (`Modelos/05_comunicaciones.sysml`) y conectarlo hasta `ModuloFrenadoSeguridad` (`Modelos/04_1_control.sysml`) a través de `SistemaControl` y `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`).

## Goals / Non-Goals

**Goals:**
- Añadir en `SistemaComunicacionesEmbarcado` (`Modelos/05_comunicaciones.sysml`) el puerto `salidaInhabilitacionFrenado : DataBusPort`.
- Añadir en `ModuloFrenadoSeguridad` (`Modelos/04_1_control.sysml`) los atributos `frenadoProgresivoActivo : Boolean` y `frenadoAutomaticoHabilitado : Boolean` y el puerto `controlInhabilitacionManual : DataBusPort`.
- Añadir en `SistemaControl` (`Modelos/04_1_control.sysml`) el puerto de contorno `entradaInhabilitacionFrenado : DataBusPort` y la conexión interna `connection c_inhabilitacion_frenado connect entradaInhabilitacionFrenado to moduloFrenadoSeguridad.controlInhabilitacionManual;`.
- Definir en `SubsistemaControl` (`Modelos/04_1_control.sysml`) el requisito `requirement def ReqFrenadoAutomaticoColision` (`RGEN-17`) con `subject ctrl : SistemaControl` y añadir `satisfy requirement : ReqFrenadoAutomaticoColision by control;` en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`).
- Conectar en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`) `connection c_comms_frenado_ctrl connect comunicaciones.salidaInhabilitacionFrenado to control.entradaInhabilitacionFrenado;` y exponerlo en las vistas conjuntas de `Modelos/11_vistas.sysml`.

**Non-Goals:**
- Modificar `04_2_navegacion.sysml` (cuyo alcance `RGEN-09` ya ha quedado cerrado y archivado) ni ningún otro subsistema fuera de Comunicaciones, Control, SistemaUGV y VistasUGV.

## Decisions

1. **Puerto directo en `SistemaComunicacionesEmbarcado` (`Modelos/05_comunicaciones.sysml`)**:
   - *Decisión*: Declarar `port salidaInhabilitacionFrenado : DataBusPort;` reutilizando `TiposBase::DataBusPort`, de forma idéntica al patrón empleado con `salidaModoDeteccion`, para mantener `05_comunicaciones.sysml` desacoplado y sencillo hasta que más adelante se aborde el subsistema de Comunicaciones en detalle.
2. **Conexión hacia `ModuloFrenadoSeguridad` en `SistemaControl` (`Modelos/04_1_control.sysml`)**:
   - *Decisión*: Exponer en `SistemaControl` el puerto `port entradaInhabilitacionFrenado : DataBusPort;` y conectarlo internamente con `moduloFrenadoSeguridad.controlInhabilitacionManual` mediante `connection c_inhabilitacion_frenado connect entradaInhabilitacionFrenado to moduloFrenadoSeguridad.controlInhabilitacionManual;`. Así se visualiza la línea de mando manual desde Comunicaciones hasta `moduloFrenadoSeguridad` sin pasar por `computadorAutonomia`.
3. **Formalización de `ReqFrenadoAutomaticoColision` (`RGEN-17`)**:
   - *Decisión*: Declarar `requirement def ReqFrenadoAutomaticoColision` en `SubsistemaControl` con `subject ctrl : SistemaControl;` y satisfacerlo en `PlataformaUGV` mediante `satisfy requirement : ReqFrenadoAutomaticoColision by control;`, de modo que `vistaRequisitos` lo recoja automáticamente.

## Risks / Trade-offs

- **[Risk] Claridad visual en `vistaConexionesNavegacionControl`** → **Mitigation**: Exponer `SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` y verificar el diagrama SVG con `spec42.exe check Modelos` y `spec42.exe diagram Modelos`.
