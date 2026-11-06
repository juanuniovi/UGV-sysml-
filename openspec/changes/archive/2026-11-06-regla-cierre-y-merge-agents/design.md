# Design

## Context

Véase `proposal.md` para la motivación. Actualmente, el flujo obligatorio descrito en `AGENTS.md` abarca de `opsx-propose` a `opsx-archive`. Sin embargo, la integración con la rama principal `main`, el cierre de *issues* en GitHub y la eliminación de la rama de trabajo quedan fuera de la pauta escrita, requiriendo instrucciones ad-hoc del usuario en cada iteración.

## Goals / Non-Goals

**Goals:**
- Formalizar un paso 6 ("Post-archivado e integración") en `AGENTS.md`.
- Exigir una evaluación explícita de buenas prácticas antes de sugerir el merge.
- Estandarizar la consulta al usuario para: (a) resolver el issue asociado, (b) fusionar en `main` y pushear, y (c) podar la rama temporal en local y remoto.

**Non-Goals:**
- No fusionar en `main` de manera silenciosa o automática sin autorización expresa del usuario.
- No modificar el comportamiento de los comandos de la CLI `openspec`.

## Decisions

### Decisión 1: Incorporación como paso numerado en `AGENTS.md`
- **Elección**: Añadir el paso `6. Cierre e integración (opcional con autorización)` en la sección `## Flujo obligatorio` de `AGENTS.md`.
- **Razón**: Los agentes leen secuencialmente el flujo de trabajo. Al figurar como el paso inmediatamente posterior a `opsx-archive`, se garantiza que ningún cambio quede abandonado en una rama secundaria sin que el agente plantee su integración y cierre.

### Decisión 2: Condición de buenas prácticas como filtro previo
- **Elección**: Requerir que el agente valide previamente que la implementación respeta las convenciones del repositorio (sin cambios en requisitos sin autorización, modelos compilables/validados, rama limpia).
- **Razón**: Evita empujar a `main` código o modelos en estado inestable o con defectos de trazabilidad.

## Risks / Trade-offs

- **[Riesgo] Fusión prematura con errores no detectados**:
  - *Mitigación*: El agente nunca ejecuta el merge de forma automática; debe formular la consulta al autor y esperar confirmación explícita.
