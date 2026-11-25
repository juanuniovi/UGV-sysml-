# Design

## Context

Ver `proposal.md` (Why). Estado de partida, comprobado el 2026-11-25 en la rama `refactor/retirar-caja-negra-planta-motriz`, creada desde `main` (`9f71e72`):

- `Modelos/03_planta_motriz.sysml` tiene 728 líneas:
  - Líneas 1 a 142: caja blanca, sin cambios desde `44d3656`.
  - Línea 143: línea en blanco.
  - Líneas 144 a 727: comentario de cabecera de la sección 4 y el subpaquete `CajaNegraPlantaMotriz`, que se cierra en la 727.
  - Línea 728: `}` de cierre de `SubsistemaPlantaMotriz`.
- El subpaquete es autocontenido. Ningún otro `.sysml` lo referencia, ni en local ni en `origin/main`. Sus elementos solo se usan entre ellos.
- Las vistas de `11_vistas.sysml` exponen `SubsistemaPlantaMotriz::*` y `SubsistemaPlantaMotriz::PlantaMotrizHibrida`. Ese `expose` no es recursivo y no entra en el subpaquete. Las 12 vistas renderizadas como línea base no contienen ningún elemento de la caja negra.
- Spec42 está disponible en el binario de la extensión de VS Code (`elan8.spec42`, `server/win32-x64/spec42.exe`). Línea base: `check` con 0 errores y 0 avisos, y 12 de 12 vistas renderizadas.

## Goals / Non-Goals

**Goals:**
- Dejar `03_planta_motriz.sysml` idéntico al estado de la caja blanca aprobado en `44d3656`.
- Retirar la capacidad `planta-motriz-caja-negra` de `openspec/specs/`, conservando el historial en `openspec/changes/archive/`.
- Mantener en el plan de desarrollo los hallazgos de la auditoría del pliego, que siguen siendo válidos.

**Non-Goals:**
- Corregir las discrepancias detectadas el 2026-11-19 (RGEN‑19 opcional sin rotular en `ReqExportacionEnergia`, RGEN‑13/RGEN‑15 en el comentario de `packBateriasTraccion`, `and` en `09_sistema_ugv.sysml`…). Cada una necesita su propio cambio y siguen anotadas en el plan.
- Volver a modelar RGEN‑12 o RGEN‑18 en la caja blanca: es trabajo de la Fase 2.
- Tocar vistas, archivos de otros compañeros o el cambio archivado `2026-11-19-planta-motriz-caja-negra`.

## Decisions

### D1. Borrado del bloque en vez de `git revert 0b9c268`
Se borra el bloque contiguo de líneas 143 a 727 en un commit nuevo y se descarta `git revert`. El revert también desharía los cambios de `0b9c268` en `plan_desarrollo_planta_motriz.md` (perderíamos la auditoría del pliego) y en `tasks.md` del cambio ya archivado, y no retiraría la especificación consolidada, que llegó en `09a423d`. El borrado deja un resultado verificable: se compara con `git show 44d3656:Modelos/03_planta_motriz.sysml` y la diferencia debe ser nula. Esta igualdad ya se ha comprobado en la fase de propuesta, sin editar el archivo.

### D2. Retirada de la especificación con un delta REMOVED
La capacidad se retira con un delta `## REMOVED Requirements` que incluye sus 10 requisitos, cada uno con **Reason** y **Migration**, según el flujo de OpenSpec. Si al archivar, `openspec archive` deja `openspec/specs/planta-motriz-caja-negra/spec.md` sin requisitos (una cabecera y un `Purpose` huérfanos), se borra a mano el directorio `openspec/specs/planta-motriz-caja-negra/` y se comprueba con `openspec validate --all` y `openspec list --specs`. Se descarta borrar la especificación directamente sin delta, porque no dejaría constancia en el cambio archivado de la autorización ni de los motivos.

### D3. Edición quirúrgica del plan de desarrollo
En `Modelos/plan_desarrollo_planta_motriz.md`:
- Se elimina la fila «Caja negra» de la tabla de partida.
- Se quita «Reconciliarlos con los puertos de la caja negra» de la fila de puertos de contorno.
- En la matriz de requisitos, se sustituyen las soluciones de RGEN‑12, RGEN‑16 y RGEN‑18 que remiten a «la caja negra / UC3 / UC6 / UC8» por «Pendiente (Fase 2)».
- Se elimina la Fase 0 del mapa de fases y se borra la sección «⬛ Fase 0 (En curso): Caja Negra».
- Se conservan la nota de auditoría del pliego, los textos corregidos de la matriz y la decisión pendiente 2 (RGEN‑13/RGEN‑15).
- La lista de discrepancias que se iban a comunicar a otros compañeros, que estaba dentro de la sección Fase 0, se mueve a «Decisiones pendientes», porque sigue siendo válida.

### D4. Validación
Se aplica el procedimiento de `AGENTS.md`: `spec42 check Modelos` con 0 errores y 0 avisos, `spec42 diagram Modelos` para listar las vistas y `spec42 diagram Modelos --view <vista>` para cada una. Deben salir las mismas 12 vistas que en la línea base. Además, `vistaEstructuraPlantaMotriz`, `vistaConexionesPlantaMotriz` y `vistaConexionesPlantaMotrizSistema` deben dar una salida idéntica a la de la línea base, porque la caja negra no aparecía en ellas.

## Risks / Trade-offs

- [Se pierde un trabajo de análisis que podría volver a pedirse] → Queda íntegro en el historial: commit `0b9c268` y cambio archivado `2026-11-19-planta-motriz-caja-negra`. Se recupera con `git show 0b9c268:Modelos/03_planta_motriz.sysml`.
- [RGEN‑12 y RGEN‑18 dejan de estar en el modelo] → Antes del 2026-11-19 tampoco estaban. Se anotan como pendientes de la Fase 2 en el plan de desarrollo.
- [`openspec archive` podría rechazar o dejar a medias una capacidad sin requisitos] → La decisión D2 lo resuelve: se borra a mano el directorio y se revalida. Si el CLI no admite el archivo, se documenta en `tasks.md` y se archiva moviendo el cambio a `archive/` con la fecha, como ya se ha hecho en este repositorio.
- [Un compañero empieza a referenciar la caja negra antes de la fusión] → Hoy no hay ninguna referencia en `origin/main`. Antes de fusionar se repite la búsqueda en `origin/main`.
