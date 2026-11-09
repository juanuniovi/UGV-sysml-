# Proposal

## Why

El requisito **RGEN-17** del pliego técnico exige que el UGV disponga de una función de frenado automático ante riesgo de colisión, ejecutada de forma progresiva siempre que sea posible, y que pueda ser inhabilitada manualmente para evitar bloqueos del paso por el enemigo mediante falsos señuelos. Actualmente, `ModuloFrenadoSeguridad` en `Modelos/04_1_control.sysml` carece de un puerto y conexión desde `SistemaComunicacionesEmbarcado` para recibir la orden manual de inhabilitación/desactivación del frenado, de los atributos que reflejen el frenado progresivo y la inhabilitación manual, y de la definición formal del requisito `ReqFrenadoAutomaticoColision` (`RGEN-17`) con su relación `satisfy`.

## What Changes

- Añadir en `Modelos/05_comunicaciones.sysml` (`SistemaComunicacionesEmbarcado`) un puerto directo `salidaInhabilitacionFrenado : DataBusPort` para transmitir la orden manual de desactivación/habilitación del frenado automático de seguridad (`RGEN-17`).
- Actualizar `Modelos/04_1_control.sysml` (`package SubsistemaControl`):
  - En `ModuloFrenadoSeguridad`:
    - Añadir los atributos `frenadoProgresivoActivo : Boolean` y `frenadoAutomaticoHabilitado : Boolean` (para reflejar el frenado progresivo ante riesgo de colisión y la posibilidad de inhabilitación manual frente a señuelos).
    - Añadir el puerto `controlInhabilitacionManual : DataBusPort` para recibir la orden de desactivación manual desde Comunicaciones.
  - En `SistemaControl`:
    - Añadir el puerto de contorno `entradaInhabilitacionFrenado : DataBusPort`.
    - Añadir la conexión interna `connection c_inhabilitacion_frenado connect entradaInhabilitacionFrenado to moduloFrenadoSeguridad.controlInhabilitacionManual;` que enlaza la orden procedente de Comunicaciones directamente con `moduloFrenadoSeguridad`.
  - Definir formalmente `requirement def ReqFrenadoAutomaticoColision` (`RGEN-17`) con `subject ctrl : SistemaControl` y añadir su relación `satisfy requirement : ReqFrenadoAutomaticoColision by control;` en `PlataformaUGV`.
- Actualizar `Modelos/09_sistema_ugv.sysml` (`PlataformaUGV`):
  - Añadir la conexión `connection c_comms_frenado_ctrl connect comunicaciones.salidaInhabilitacionFrenado to control.entradaInhabilitacionFrenado;`.
  - Añadir `satisfy requirement : ReqFrenadoAutomaticoColision by control;`.
- Actualizar `Modelos/11_vistas.sysml` (`VistasUGV`):
  - Exponer `SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`.
- **Fuera de alcance**:
  - Modificar la arquitectura interna de `06_estaciones_control.sysml`, `01_barcaza.sysml`, `02_tren_rodaje.sysml`, `03_planta_motriz.sysml`, `07_uav_cenital.sysml`, `08_cargas_pago.sysml` o `10_comportamiento.sysml`, ni alterar ningún requisito existente.

## Capabilities

### New Capabilities
<!-- Ninguna capacidad nueva; se amplía de forma aditiva la capacidad existente subsistema-control. -->

### Modified Capabilities
- `subsistema-control`: Se añade de forma aditiva el requisito de puerto y conexión de inhabilitación manual del frenado automático desde Comunicaciones hacia `ModuloFrenadoSeguridad`, atributos de frenado progresivo e inhabilitación manual, y la trazabilidad formal `ReqFrenadoAutomaticoColision` (`RGEN-17`), sin modificar ni relajar ningún requisito existente.

## Impact

- **Archivos afectados**:
  - `Modelos/05_comunicaciones.sysml` (nuevo puerto `salidaInhabilitacionFrenado : DataBusPort`).
  - `Modelos/04_1_control.sysml` (puerto `controlInhabilitacionManual` y atributos en `ModuloFrenadoSeguridad`, puerto `entradaInhabilitacionFrenado` y conexión `c_inhabilitacion_frenado` en `SistemaControl`, y `requirement def ReqFrenadoAutomaticoColision`).
  - `Modelos/09_sistema_ugv.sysml` (conexión `c_comms_frenado_ctrl` y `satisfy requirement : ReqFrenadoAutomaticoColision by control`).
  - `Modelos/11_vistas.sysml` (exposición de `c_comms_frenado_ctrl` en las vistas conjuntas de Navegación y Control).
- **Subsistemas afectados**:
  - `SubsistemaComunicaciones`, `SubsistemaControl`, `SistemaUGV` y `VistasUGV`.
- **Requisitos del pliego relacionados y conflictos**:
  - `RGEN-17` (formalizado íntegramente con frenado progresivo e inhabilitación manual desde Comunicaciones).
  - Ningún conflicto con requisitos existentes (`RGEN-09`, `RNAV-01`, `ROPE-05`, `ROPE-06` permanecen intactos).
