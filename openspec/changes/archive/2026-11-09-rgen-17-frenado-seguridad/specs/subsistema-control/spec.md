# Spec Delta

## ADDED Requirements

### Requirement: Frenado automático progresivo e inhabilitación manual desde Comunicaciones (RGEN-17)
El paquete `SubsistemaControl` SHALL dotar a `ModuloFrenadoSeguridad` de los atributos `frenadoProgresivoActivo : Boolean` y `frenadoAutomaticoHabilitado : Boolean` y del puerto `controlInhabilitacionManual : DataBusPort`, conectado mediante `entradaInhabilitacionFrenado` de `SistemaControl` con `salidaInhabilitacionFrenado : DataBusPort` de `SistemaComunicacionesEmbarcado`, y SHALL formalizar `ReqFrenadoAutomaticoColision` (`RGEN-17`) con su relación `satisfy`.

#### Scenario: Desactivación manual del frenado automático desde Comunicaciones frente a señuelos enemigos
- **WHEN** `PlataformaUGV` conecta `comunicaciones.salidaInhabilitacionFrenado` con `control.entradaInhabilitacionFrenado` y este se enlaza internamente con `moduloFrenadoSeguridad.controlInhabilitacionManual`
- **THEN** el operador puede inhabilitar manualmente la función de frenado automático progresivo ante riesgo de colisión (`RGEN-17`) para evitar el bloqueo del paso del UGV mediante falsos señuelos, quedando satisfecho formalmente `ReqFrenadoAutomaticoColision`
