# Proposal

## Why

Siguiendo las directrices metodológicas del equipo docente del proyecto, es necesario establecer como estándar permanente del repositorio una política rigurosa sobre el uso de ramas y la granularidad de los commits. 

La fragmentación del historial con micro-commits dispersos y la integración prematura de ajustes sintácticos o parciales en la rama `main` dificulta el seguimiento de la arquitectura y degrada la calidad del repositorio. Se requiere formalizar una forma de trabajo vinculante donde las ramas dedicadas sean el espacio exhaustivo de iteración, depuración y validación con Spec42, consolidando hacia `main` únicamente bloques funcionales completos, coherentes y libres de advertencias.

## What Changes

- Incorporación en `AGENTS.md` (y en `openspec/config.yaml`) de la política vinculante de **Granularidad de commits y trabajo exhaustivo en ramas**:
  - **Uso profundo de ramas:** Todo el ciclo de diseño, modelado, depuración sintáctica y resolución de avisos de Spec42 debe completarse íntegramente dentro de la rama dedicada.
  - **Bloques completos y consolidados:** Los commits deben representar unidades lógicas y funcionales cerradas, evitando micro-commits innecesarios.
  - **Integración limpia en `main`:** Solo se procederá a la fusión en `main` cuando el bloque esté 100% terminado, probado con `spec42 check Modelos` y validado con 0 errores y 0 advertencias.
- Formalización de esta capacidad de metodología de trabajo en las especificaciones del proyecto.

## Capabilities

### New Capabilities
- `politica-git-bloques`: Define las reglas normativas para la granularidad de commits, desarrollo iterativo en ramas y entrega por bloques funcionales completos.

### Modified Capabilities
<!-- No se modifican requisitos previos de otras capacidades. -->

## Impact

- **Archivos normativos**: [`AGENTS.md`](AGENTS.md) y [`openspec/config.yaml`](openspec/config.yaml).
- **Modelos SysML v2**: Ningún archivo en `Modelos/*.sysml` es modificado. No afecta a requisitos técnicos del UGV.
- **Flujo de trabajo**: Afecta transversalmente a cualquier agente o desarrollador que opere en el repositorio a partir de este momento.
