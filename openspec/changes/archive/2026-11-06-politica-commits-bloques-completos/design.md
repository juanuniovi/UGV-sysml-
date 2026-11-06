# Design

## Context

Véase `proposal.md` para la motivación. Actualmente, las reglas de Git en `AGENTS.md` y `openspec/config.yaml` prohíben trabajar directamente en `main` y exigen ramas dedicadas, pero no explicitaban la política de granularidad de los commits ni la prohibición de micro-commits en la rama principal.

## Goals / Non-Goals

**Goals:**
- Formalizar en `AGENTS.md` y `openspec/config.yaml` el principio de trabajo en ramas y entrega por bloques completos.
- Exigir que la iteración, depuración y validación con `spec42 check Modelos` ocurran dentro de la rama antes de fusionar.
- Establecer como estándar permanente del repositorio un historial limpio y profesional.

**Non-Goals:**
- No alterar los flujos de OpenSpec ya establecidos.
- No impedir que en la rama de trabajo el colaborador haga pruebas intermedias si lo necesita, siempre que la integración final hacia `main` sea un bloque limpio y consolidado.

## Decisions

### Decisión 1: Integración en `AGENTS.md`
- **Elección**: Actualizar la sección `## Antes de actuar` y el paso 6 de `## Flujo obligatorio` en `AGENTS.md` para explicitar:
  1. *Desarrollo exhaustivo en rama*: todo ajuste, compilación y corrección se realiza antes de mergear.
  2. *Bloques funcionales completos*: commits que abarcan unidades lógicas completas y cierre de issue en un solo bloque.

### Decisión 2: Sincronización en `openspec/config.yaml`
- **Elección**: Añadir la directiva de granularidad a la sección `REGLAS OBLIGATORIAS DE GIT` en `openspec/config.yaml`.
- **Razón**: Los agentes leen `openspec/config.yaml` al iniciar cada instrucción; asegurar la coherencia en ambos documentos garantiza su cumplimiento estricto.

## Risks / Trade-offs

- **[Riesgo] Retraso en integraciones intermedias**:
  - *Mitigación*: Fomenta ramas de duración adecuada por cada issue o bloque funcional, garantizando que cuando algo llega a `main` es 100% estable y no requiere commits de parches inmediatos.
