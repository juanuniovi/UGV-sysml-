# Design: Formalización y Trazabilidad de ROPE-06 (Detect & Avoid)

## Context

En el modelo de ingeniería de sistemas del UGV, la capacidad de *Sense & Avoid* (detección y evasión de obstáculos) está repartida entre:
1. **Percepción y Detección (`SubsistemaNavegacion`)**: Sensores radiantes (LiDAR, radar) y no radiantes (cámaras 360°, térmica, visión por computador) fusionados en `moduloDeteccionEvasion : ModuloDeteccionEvasion`, el cual genera y emite `PuertoMapaObstaculos`.
2. **Evaluación y Evasión (`SubsistemaControl`)**: `ComputadorAutonomia::subsistemaPlanificacionEvaluacion` recibe el mapa y planifica la trayectoria de evasión o comanda parada de seguridad a través de `moduloFrenadoSeguridad` (`RGEN-17`).

En el pliego de prescripciones técnicas (`docs/ROBOT_TERRESTRE_Anexo_I.pdf`, sección 3.4, página 114), el requisito `ROPE-06` establece:
> *"El sistema en su modo AUTÓNOMO deberá tener la capacidad de “Detectar y Evadir” obstáculos estáticos y dinámicos, que se interpongan en la trayectoria del UGV, y lo deberá realizar independientemente de si se encuentra en Modo de Detección NORMAL o SIGILOSO. Esto incluye recalcular trayectorias, dar marcha atrás, volverse y buscar otras alternativas, etc."*

Actualmente, `ROPE-06` se menciona en múltiples *docstrings*, pero carece de un bloque formal `requirement def` y de su relación `satisfy` en los modelos SysML v2.

## Goals / Non-Goals

**Goals:**
- Formalizar `requirement def ReqDeteccionEvasionObstaculos` en `Modelos/04_2_navegacion.sysml` incorporando la cita literal auditada de `ROPE-06`.
- Establecer `subject nav : SistemaNavegacion;` manteniendo el patrón homogéneo de requisitos de navegación (`ReqNavegacionGNSSDenegado`, `ReqDeteccionObstaculosModoSigiloso`, `ReqConcienciaSituacionalVisionSensores`).
- Declarar la satisfacción interna en `SistemaNavegacion` mediante `satisfy ReqDeteccionEvasionObstaculos by moduloDeteccionEvasion;`.
- Declarar la satisfacción a nivel de plataforma en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`) mediante `satisfy requirement : ReqDeteccionEvasionObstaculos by navegacion;`.
- Asegurar 0 errores y 0 advertencias en Spec42 y plena trazabilidad hacia la matriz de requisitos.

**Non-Goals:**
- No se modifican ni relajan los requisitos vigentes (`RNAV-01`, `RGEN-09`, `RGEN-17`, `RGEN-20`, `RGEN-22`, `ROPE-01`).
- No se altera la estructura interna de subpartes (`camaras`, `sensores`, `moduloDeteccionEvasion`) ni las interfaces de conexión.

## Decisions

### 1. Ubicación y Sujeto de `ReqDeteccionEvasionObstaculos`
- **Decisión**: Formalizar `ReqDeteccionEvasionObstaculos` en `Modelos/04_2_navegacion.sysml` con `subject nav : SistemaNavegacion;`.
- **Justificación**: En la arquitectura del UGV, `moduloDeteccionEvasion` reside en `SistemaNavegacion` y es el componente encargado de la detección y generación del mapa de obstáculos en tiempo real tanto en modo NORMAL como SIGILOSO. La satisfacción a nivel de sistema se delega a `navegacion` en `PlataformaUGV`, análogamente a `ReqNavegacionGNSSDenegado` y `ReqDeteccionObstaculosModoSigiloso`.

### 2. Sintaxis Canónica de `satisfy`
- **Decisión**:
  - En `SistemaNavegacion`:
    ```sysml
    satisfy ReqDeteccionEvasionObstaculos by moduloDeteccionEvasion;
    ```
  - En `PlataformaUGV` (`09_sistema_ugv.sysml`):
    ```sysml
    satisfy requirement : ReqDeteccionEvasionObstaculos by navegacion;
    ```
- **Justificación**: Sigue la sintaxis canónica de Spec42 (`satisfy requirement : <ReqDef> by <part>;` o `satisfy <ReqDef> by <part>;`) aplicada en `09_sistema_ugv.sysml` y `04_1_control.sysml`.

## Risks / Trade-offs

- **[Riesgo]**: Posible colisión de nombres si se utilizara un identificador genérico.
  - *Mitigación*: Se utiliza el nombre explícito `ReqDeteccionEvasionObstaculos`, alineado con la nomenclatura del proyecto (`ReqDeteccionObstaculosModoSigiloso`, `ReqFrenadoAutomaticoColision`).
