# Tasks

## 1. Tipado de Submodos y Comando de Autonomía en Subsistema de Control

- [x] 1.1 Definir `enum def SubmodoNavegacionAutonoma` con los cinco submodos del pliego (`PUNTOS_PASO`, `PUNTO_DESTINO`, `REGRESO_ORIGEN`, `SEGUIMIENTO_FOLLOW_ME`, `SHUTTLE_LANZADERA`) en [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml).
- [x] 1.2 Definir `item def ComandoSubmodoAutonomia` y añadir el atributo `submodoActivo` en `ComputadorAutonomia` y `submodoAutonomiaComandado` en `SistemaControl` de [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml).

## 2. Formalización del Requisito ROPE-05 y Satisfacción en Control y Plataforma

- [x] 2.1 Declarar `requirement def ReqSubmodosNavegacionAutonoma` con `subject ctrl : SistemaControl;` y la cita contractual de `ROPE-05` en [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml).
- [x] 2.2 Añadir la relación `satisfy ReqSubmodosNavegacionAutonoma by computadorAutonomia;` en `SistemaControl` de [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml).
- [x] 2.3 Añadir la relación `satisfy requirement : ReqSubmodosNavegacionAutonoma by control;` en `PlataformaUGV` de [Modelos/09_sistema_ugv.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/09_sistema_ugv.sysml).

## 3. Validación y Verificación

- [x] 3.1 Comprobar la coherencia sintáctica y resolución de referencias en Spec42 con 0 errores y 0 advertencias.
- [x] 3.2 Verificar que `ReqSubmodosNavegacionAutonoma` (`ROPE-05`) queda debidamente trazado y satisfecho en la vista de requisitos y en la arquitectura del sistema.

## Workflow follow-up

- Archivar el cambio OpenSpec tras la aprobación y validación exitosa.
