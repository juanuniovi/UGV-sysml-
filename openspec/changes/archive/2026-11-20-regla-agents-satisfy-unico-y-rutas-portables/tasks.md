# Tasks

## 1. Actualización de AGENTS.md

- [x] 1.1 Añadir al final de `AGENTS.md` la sección "Lecciones aprendidas y reglas preventivas" con el texto de la Decisión 2 de `design.md`, sin modificar las secciones existentes.

## 2. Verificación

- [x] 2.1 Comprobar con `git diff` que `AGENTS.md` solo recibe la nueva sección.
- [x] 2.2 Comprobar que el modelo actual cumple las reglas nuevas: ningún requisito con más de una cláusula `satisfy`, ninguna ruta absoluta en `.vscode/`, `spec42 check` con 0 errores y 0 avisos, y todas las vistas renderizadas.
- [x] 2.3 Ejecutar `openspec validate --strict` sobre el cambio.

## Workflow follow-up

- Ejecutar opsx-archive para consolidar la especificación y archivar el cambio.
- Confirmar con el usuario el estado del bloque funcional y la integración en la rama.
