# Proposal

## Why

El flujo actual de OpenSpec concluye en la fase de archivo (`opsx-archive`), dejando el repositorio en la rama dedicada sin una pauta explícita para la integración final del trabajo en `main`, la gestión de issues de GitHub vinculados y la limpieza de ramas de trabajo.

Para evitar la acumulación de ramas huérfanas, facilitar la trazabilidad con los *issues* del proyecto y asegurar que cada integración cumple con los estándares de calidad antes de fusionarse, se requiere establecer una directiva obligatoria en `AGENTS.md` que guíe la fase posterior al archivado.

## What Changes

- Incorporación en `AGENTS.md` de un paso final estandarizado tras `opsx-archive`:
  - **Evaluación de buenas prácticas**: El agente debe confirmar que el trabajo realizado respeta las convenciones del proyecto, no altera requisitos sin autorización y mantiene el modelo verificado.
  - **Consulta explícita al usuario**: El agente debe preguntar al autor si desea:
    1. Identificar y cerrar el *issue* de GitHub correspondiente (si existe).
    2. Fusionar (`merge`) la rama de trabajo dedicada en `main` y sincronizar (`push`) con el repositorio remoto.
    3. Eliminar la rama temporal de trabajo tanto en local como en remoto.
- Formalización de esta capacidad normativa en las especificaciones del proyecto.

## Capabilities

### New Capabilities
- `flujo-cierre-y-merge`: Define el protocolo de cierre de tareas, validación de buenas prácticas, integración en `main` y limpieza de ramas temporales tras completar un cambio OpenSpec.

### Modified Capabilities
<!-- No se modifican requisitos previos de otras capacidades. -->

## Impact

- **Archivos afectados**:
  - `AGENTS.md`: adición del protocolo de post-archivado e integración.
  - `openspec/specs/flujo-cierre-y-merge/spec.md`: especificación formal del comportamiento.
- **Modelos SysML v2**: Ningún archivo en `Modelos/*.sysml` es modificado; no hay impacto en requisitos técnicos (`RGEN`, `RLT1`, `RNAV`, `ROPE`, `RCOM`).
