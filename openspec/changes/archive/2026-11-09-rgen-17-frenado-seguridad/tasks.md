# Tasks

## 1. Puertos e inhabilitación manual del frenado desde Comunicaciones (`RGEN-17`)

- [x] 1.1 Añadir en `Modelos/05_comunicaciones.sysml` (`SistemaComunicacionesEmbarcado`) el puerto `salidaInhabilitacionFrenado : DataBusPort`.
- [x] 1.2 Actualizar `Modelos/04_1_control.sysml` para añadir en `ModuloFrenadoSeguridad` los atributos `frenadoProgresivoActivo : Boolean` y `frenadoAutomaticoHabilitado : Boolean` y el puerto `controlInhabilitacionManual : DataBusPort`, y en `SistemaControl` el puerto `entradaInhabilitacionFrenado : DataBusPort` y la conexión `c_inhabilitacion_frenado` hacia `moduloFrenadoSeguridad.controlInhabilitacionManual`.

## 2. Requisito formal `RGEN-17`, integración en plataforma y vistas

- [x] 2.1 Definir en `Modelos/04_1_control.sysml` (`SubsistemaControl`) el requisito `requirement def ReqFrenadoAutomaticoColision` (`RGEN-17`) con `subject ctrl : SistemaControl`.
- [x] 2.2 Actualizar `Modelos/09_sistema_ugv.sysml` (`PlataformaUGV`) para añadir la conexión `connection c_comms_frenado_ctrl connect comunicaciones.salidaInhabilitacionFrenado to control.entradaInhabilitacionFrenado;` y la satisfacción `satisfy requirement : ReqFrenadoAutomaticoColision by control;`.
- [x] 2.3 Actualizar `Modelos/11_vistas.sysml` (`VistasUGV`) para exponer `SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`.

## 3. Verificación con Spec42

- [x] 3.1 Ejecutar `spec42.exe check Modelos` y `spec42.exe diagram Modelos --view "VistasUGV::vistaConexionesNavegacionControl"` para comprobar que existen 0 errores y 0 advertencias.
