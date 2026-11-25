# Tasks

## 1. Comprobaciones previas

- [x] 1.1 Confirmar que la propuesta está aprobada por el autor y que se trabaja en la rama `refactor/retirar-caja-negra-planta-motriz` con el árbol limpio, salvo este cambio (`git status --short --branch`).
- [x] 1.2 Repetir la búsqueda de referencias externas: `grep -rn "CajaNegraPlantaMotriz\|PlantaMotrizCajaNegra" Modelos --include=*.sysml` y `git grep` sobre `origin/main` (tras `git fetch`). Fuera de `03_planta_motriz.sysml` no debe aparecer ningún resultado.

## 2. Modelo SysML

- [x] 2.1 Borrar las líneas 143 a 727 de `Modelos/03_planta_motriz.sysml` (línea en blanco, comentario de la sección 4 y subpaquete `CajaNegraPlantaMotriz`), conservando la `}` final de `SubsistemaPlantaMotriz`. Se verifica con `git diff --no-index <(git show 44d3656:Modelos/03_planta_motriz.sysml) Modelos/03_planta_motriz.sysml`, que no debe dar ninguna diferencia, y con `wc -l` igual a 143.
- [x] 2.2 Comprobar la trazabilidad: `ReqPotenciaMinimaPlataforma` y `ReqExportacionEnergia` mantienen su texto y sus restricciones. `git diff main -- Modelos/` solo debe mostrar `03_planta_motriz.sysml` y `plan_desarrollo_planta_motriz.md`.

## 3. Documentación del autor

- [x] 3.1 Editar `Modelos/plan_desarrollo_planta_motriz.md` según la decisión D3 de `design.md`. Se verifica con `grep -n -i "caja negra\|CajaNegra\|UC[1-8]\|Fase 0"`, que no debe dar ningún resultado salvo una nota de que se retiró. La nota de auditoría del pliego y la matriz corregida deben seguir presentes, y RGEN‑12 y RGEN‑18 deben figurar como «Pendiente (Fase 2)».

## 4. Validación con Spec42

- [x] 4.1 Ejecutar `spec42 check Modelos` (binario de la extensión de VS Code). Resultado exigido: 0 errores y 0 avisos.
- [x] 4.2 Ejecutar `spec42 diagram Modelos` y confirmar que aparecen las mismas 12 vistas que en la línea base. Renderizar cada una con `spec42 diagram Modelos --view <vista>`: todas deben generarse sin error.
- [x] 4.3 Comparar la salida de `vistaEstructuraPlantaMotriz`, `vistaConexionesPlantaMotriz` y `vistaConexionesPlantaMotrizSistema` con la línea base guardada en la fase de propuesta. Debe ser idéntica. Si no lo es, documentar la diferencia y justificarla.

## 5. Consolidación

- [x] 5.1 Ejecutar `openspec validate retirar-caja-negra-planta-motriz` sin errores.
- [x] 5.2 Hacer un único commit funcional en la rama, sin coautor y sin `push` (lo hace el autor), con el modelo, el plan y los artefactos del cambio. Se verifica con `git log -1 --stat`.

## Workflow follow-up

- Archivar con `opsx-archive` cuando el autor apruebe la implementación. Si queda `openspec/specs/planta-motriz-caja-negra/` sin requisitos, borrar el directorio (decisión D2) y comprobar con `openspec list --specs` y `openspec validate --all`.
- Cierre: confirmar 0 errores y 0 avisos en Spec42 y consultar al autor si quiere comentar o cerrar el Issue #4 (la caja blanca sigue abierta), fusionar en `main` y hacer `push`, y borrar la rama local y la remota.

## Registro de validación (2026-11-25)

- `03_planta_motriz.sysml`: 143 líneas, idéntico byte a byte a `git show 44d3656:Modelos/03_planta_motriz.sysml` (`cmp` sin diferencias).
- `spec42 check Modelos` (elan8.spec42 0.61.1, binario de la extensión): `Checked 14 document(s): 0 error(s), 0 warning(s), 0 info(s)`.
- `spec42 diagram Modelos`: las mismas 12 vistas que en la línea base. Las 12 se renderizan y su salida es **idéntica** a la línea base anterior al cambio.
- Ninguna referencia a `CajaNegraPlantaMotriz` ni a `PlantaMotrizCajaNegra` fuera del archivo, ni en local ni en `origin/main` (`9f71e72`).
- Archivo: `openspec archive` rechazó al principio dejar una especificación sin requisitos. Siguiendo la indicación del propio CLI, se añadió `retire_capabilities: true` a `.openspec.yaml` y el archivo retiró `openspec/specs/planta-motriz-caja-negra/` (10 requisitos eliminados). No hizo falta borrarla a mano (decisión D2). `openspec validate --all`: 13 correctos y 0 fallidos.
