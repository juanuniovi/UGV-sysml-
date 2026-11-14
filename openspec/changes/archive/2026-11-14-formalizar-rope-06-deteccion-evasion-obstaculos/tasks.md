# Tasks

## 1. Formalización de Requisito y Satisfacción en Subsistema de Navegación

- [x] 1.1 Declarar `requirement def ReqDeteccionEvasionObstaculos` con la cita literal contractual de `ROPE-06` y `subject nav : SistemaNavegacion;` en [Modelos/04_2_navegacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_2_navegacion.sysml).
- [x] 1.2 Añadir la relación `satisfy ReqDeteccionEvasionObstaculos by moduloDeteccionEvasion;` dentro de `SistemaNavegacion` en [Modelos/04_2_navegacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_2_navegacion.sysml).

## 2. Satisfacción a Nivel de Plataforma UGV

- [x] 2.1 Añadir la relación `satisfy requirement : ReqDeteccionEvasionObstaculos by navegacion;` en `PlataformaUGV` de [Modelos/09_sistema_ugv.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/09_sistema_ugv.sysml).

## 3. Validación y Verificación

- [x] 3.1 Comprobar la coherencia sintáctica y resolución de referencias en Spec42 con 0 errores y 0 advertencias.
- [x] 3.2 Verificar que `ReqDeteccionEvasionObstaculos` (`ROPE-06`) queda debidamente trazado y satisfecho en la vista de requisitos y en la arquitectura del sistema.

## Workflow follow-up

- Archivar el cambio OpenSpec tras la aprobación y validación exitosa.
