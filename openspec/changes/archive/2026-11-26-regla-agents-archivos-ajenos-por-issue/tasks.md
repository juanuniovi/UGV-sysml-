# Tasks

## 1. Actualización de AGENTS.md

- [x] 1.1 Insertar en `AGENTS.md`, tras la sección "Protección de requisitos", la sección "Coordinación entre responsables de subsistema" con el texto de la Decisión 4 de `design.md`, sin modificar las secciones existentes.

## 2. Verificación

- [x] 2.1 Comprobar con `git diff` que `AGENTS.md` solo recibe la nueva sección.
- [x] 2.2 Comprobar que no hay cambios en `Modelos/*.sysml` y que `spec42 check Modelos` sigue con 0 errores y 0 avisos y las 12 vistas se renderizan (estado de referencia sin regresiones).
- [x] 2.3 Ejecutar `openspec validate regla-agents-archivos-ajenos-por-issue --strict`.

## 3. Acuerdo del equipo

- [ ] 3.1 Antes de integrar en `main`, comunicar la regla al equipo (por ejemplo, mediante un *issue* o en el grupo) y obtener su conformidad, ya que `AGENTS.md` es un archivo compartido.
  - *Excepción documentada (2026-11-26)*: pendiente de que el autor comunique la regla al equipo antes de la fusión en `main`; no bloquea el archivado. Verificación realizada: `git diff` con 18 inserciones y 0 borrados solo en `AGENTS.md`; sin cambios en `Modelos/`; `spec42 check Modelos` con 0 errores y 0 avisos; 12/12 vistas renderizadas; `openspec validate --strict` válido.

## Workflow follow-up

- Ejecutar opsx-archive para consolidar la especificación y archivar el cambio.
- Confirmar con el usuario el estado del bloque funcional y la integración en la rama.
