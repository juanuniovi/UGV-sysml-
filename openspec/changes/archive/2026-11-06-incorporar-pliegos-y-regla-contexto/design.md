# Design

## Context

Véase `proposal.md` para la motivación y el alcance de este cambio. El repositorio cuenta actualmente con una carpeta `docs/` que aloja la web estática del panel de control de GitHub Pages (`index.html`, `app.js`, etc.), y un archivo normativo `AGENTS.md` en la raíz que rige el comportamiento de todos los agentes de IA en el proyecto. Se incorporan dos documentos oficiales en PDF (~1 MB en conjunto) que constituyen los pliegos de referencia para los requisitos del UGV.

## Goals / Non-Goals

**Goals:**
- Alojar los documentos PDF oficiales de referencia en `docs/` de manera persistente y versionada en Git.
- Establecer en `AGENTS.md` una regla clara, imperativa e inequívoca que impida el consumo innecesario de tokens y la saturación de contexto derivada de la lectura indiscriminada de dichos documentos.
- Definir el protocolo exacto bajo el cual un agente puede proponer o realizar consultas en dichos documentos.

**Non-Goals:**
- No se modificará el código del panel de control web (`docs/app.js`, `docs/index.html`).
- No se modificará ningún modelo SysML v2 en `Modelos/*.sysml`.
- No se extraerán automáticamente textos o tablas completas de los PDF en esta fase.

## Decisions

### Decisión 1: Ubicación física de los documentos en `docs/`
- **Elección**: Copiar los dos archivos PDF directamente a la raíz de `docs/`: `docs/ROBOT_TERRESTRE_Contrato.pdf` y `docs/ROBOT_TERRESTRE_Anexo_I.pdf`.
- **Razón**: Satisface de forma directa la petición del usuario manteniendo los nombres originales del pliego para trazabilidad inmediata.
- **Alternativas consideradas**:
  - `docs/pliegos/`: Añadía un nivel de anidamiento innecesario dado el reducido número de documentos maestros.

### Decisión 2: Estructura y redactado de la regla en `AGENTS.md`
- **Elección**: Crear una sección específica de alto nivel titulada `## Acceso a documentos densos y pliegos de referencia` en `AGENTS.md`.
- **Razón**: Los agentes leen `AGENTS.md` al inicio de cada sesión (como parte de las reglas del proyecto). Al colocarla como regla obligatoria con el mismo nivel de exigencia que la protección de requisitos, se garantiza su cumplimiento sin ambigüedad.
- **Criterio de la regla**:
  1. **Prohibición por defecto**: Queda terminantemente prohibido leer, procesar o volcar en contexto el contenido de `docs/*.pdf` sin autorización previa.
  2. **Vía 1 (Petición directa)**: Si el usuario pide expresamente consultar el pliego o el contrato, el agente puede leer la sección pertinente.
  3. **Vía 2 (Propuesta del agente)**: Si el agente considera que consultar el pliego resolvería una ambigüedad o verificaría un requisito, debe formular una propuesta en el chat (indicando el motivo y la sección necesaria) y esperar la aprobación expresa del usuario antes de ejecutar cualquier herramienta de lectura sobre dichos archivos.

### Decisión 3: Compatibilidad y trazabilidad con requisitos existentes
- **Elección**: No tocar ningún requisito SysML v2 (`RGEN`, `RLT1`, `RNAV`, `ROPE`, `RCOM`). Los PDF actúan como fuente documental externa pero no invalidan las definiciones vigentes en `Modelos/`.

## Risks / Trade-offs

- **[Riesgo] Búsquedas automáticas globales en workspace**: Comandos de búsqueda de texto o herramientas automatizadas podrían intentar indexar o leer los binarios PDF consumiendo tokens.
  - *Mitigación*: La directiva en `AGENTS.md` especifica explícitamente la abstención sobre estos archivos, advirtiendo a las herramientas de inspección excluir lecturas globales de `docs/*.pdf`.
- **[Riesgo] Tamaño del repositorio Git**: La incorporación de ~1 MB en archivos PDF aumentará ligeramente el histórico.
  - *Mitigación*: Se trata de documentos finales e inmutables (versiones oficiales del curso/pliego), por lo que no generarán churn de commits binarios.
