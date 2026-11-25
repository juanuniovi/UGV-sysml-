# Proposal

## Why

El cambio archivado `2026-11-19-planta-motriz-caja-negra` (commit `0b9c268`) añadió a `Modelos/03_planta_motriz.sysml` el subpaquete `CajaNegraPlantaMotriz`, con 585 líneas de análisis de caja negra (Fase 0 del Issue #4). Tras consultarlo con el profesor, el autor confirma que **ese análisis no se requiere en el trabajo y estorba**: casi cuadruplica el tamaño del archivo (de 143 a 728 líneas), mezcla un segundo modelo de la planta con la caja blanca que sí se usa y deja pendiente una reconciliación entre ambos que ya no tiene sentido hacer.

## What Changes

- **BREAKING (dentro del archivo del autor)**: se elimina de `Modelos/03_planta_motriz.sysml` el subpaquete `CajaNegraPlantaMotriz` completo y el comentario de cabecera de su sección «4. FASE 0 - ANALISIS DE CAJA NEGRA». Desaparecen:
  - 4 partes interesadas: `OperadorMision`, `MantenedorPrimerEscalon`, `LogisticaCombustible` y `ClienteContratante`.
  - 12 necesidades `requirement def Nec…`.
  - 9 `item def` de flujo, 4 `port def`, el bloque `PlantaMotrizCajaNegra`, 11 bloques de sistemas externos y entorno, y `ContextoPlantaMotriz`.
  - Los casos de uso `UC1`…`UC8` y las 3 secuencias de contexto.
  - `MoEsPlantaMotriz` y 6 `requirement def Umbral…`.
- El archivo vuelve a contener solo la caja blanca: secciones 1 a 3, puertos, `part def`, `PlantaMotrizHibrida` con sus conexiones, `ReqPotenciaMinimaPlataforma` y `ReqExportacionEnergia`. **No se toca ni una línea de esa parte.**
- Se retira la especificación consolidada `openspec/specs/planta-motriz-caja-negra/` (sus 10 requisitos pasan a REMOVED).
- En `Modelos/plan_desarrollo_planta_motriz.md` (documento personal del autor) se quitan la Fase 0 y las referencias a la caja negra. **Se conserva** la información de la auditoría del pliego del 2026-11-19, porque es válida al margen de la caja negra: RGEN‑19 y RGEN‑18 son opcionales, RGEN‑14 y RGEN‑15 son disyuntivos («o»), el remolque es RGEN‑10 y el comentario de `packBateriasTraccion` debería citar RGEN‑15.

## Autorización de eliminación de requisitos

Según `AGENTS.md` (Protección de requisitos) y `openspec/config.yaml`, eliminar requisitos vigentes exige una confirmación explícita del usuario. Queda registrada aquí:

- **Requisitos afectados**:
  - En el modelo: las 12 `Nec…` (`NecMovilidadHibridaBiocombustible`, `NecRecargaAutonomaBaterias`, `NecOperacionSigilosa`, `NecAutonomiaMision`, `NecPotenciaMovilidadYArrastre`, `NecAlimentacionEquiposEmbarcados`, `NecExportacionEnergia`, `NecRecargaEnchufable`, `NecRepostajeYMantenimientoSencillo`, `NecRobustezAmbientalYVadeo`, `NecRemolcadoConPlantaInactiva`, `NecContencionMasa`) y las 6 `Umbral…` (`UmbralPotenciaPropulsion`, `UmbralAutonomiaTotal`, `UmbralAutonomiaElectrica`, `UmbralBiocombustible`, `UmbralRecargaPorMotorYRegeneracion`, `UmbralProfundidadVadeo`).
  - En OpenSpec: los 10 requisitos de `openspec/specs/planta-motriz-caja-negra/spec.md`.
- **Origen**: cambio `2026-11-19-planta-motriz-caja-negra`, del propio autor. Son necesidades y MoEs de un análisis de caja negra, no cláusulas del pliego: el pliego no se modifica.
- **Condición actual**: definidos, pero no satisfechos por ningún elemento (`satisfy`) y no usados por ninguna vista ni por ningún archivo de otro compañero.
- **Cambio solicitado**: eliminación completa, sin sustitución.
- **Confirmación**: el autor (César) lo pidió de forma explícita el 2026-11-25: «quiero deshacerme de ello, hablé con el profesor y no se requiere y estorba, pero siguiendo el proceso especificado en el repo».
- **Justificación**: indicación del profesor de que la Fase 0 de caja negra no forma parte del alcance exigido.

## Impacto en la trazabilidad con el pliego

No se toca ningún requisito con identificador del pliego definido fuera de la caja negra (`ReqPotenciaMinimaPlataforma` RLT1‑09, `ReqExportacionEnergia` RGEN‑19 y los requisitos de `09_sistema_ugv.sysml`). La mayoría de las cláusulas citadas en la caja negra siguen trazadas en otros puntos del modelo:

| Cláusula | Dónde sigue trazada tras el cambio |
| :--- | :--- |
| RGEN‑06, RGEN‑14, RGEN‑15, RGEN‑16, RLT1‑08 | `09_sistema_ugv.sysml` |
| RGEN‑10 | `01_barcaza.sysml`, `09_sistema_ugv.sysml` |
| RGEN‑11, RGEN‑13, RGEN‑19, RLT1‑09 | caja blanca de `03_planta_motriz.sysml` y `11_vistas.sysml` |
| RLT1‑04 | `02_tren_rodaje.sysml` |
| RLT1‑10 | `09_sistema_ugv.sysml`, `11_vistas.sysml` |
| **RGEN‑12** (recarga por motor y por frenada) | **Ningún sitio.** Solo estaba en la caja negra |
| **RGEN‑18** (recarga enchufable, OPCIONAL) | **Ningún sitio.** Solo estaba en la caja negra |

Antes del 2026-11-19 RGEN‑12 y RGEN‑18 tampoco estaban en el modelo, así que el cambio devuelve la trazabilidad a como estaba. Volver a modelarlos, si hace falta, corresponde a la Fase 2 de la caja blanca, en un cambio propio. Queda anotado como pendiente en el plan de desarrollo.

No hace falta volver a consultar el pliego (`docs/`): el cambio no formaliza, modifica ni consolida ningún valor contractual. Solo retira elementos.

## Capabilities

### New Capabilities
- Ninguna.

### Modified Capabilities
- `planta-motriz-caja-negra`: se eliminan sus 10 requisitos (REMOVED). Al archivar, la capacidad desaparece de `openspec/specs/`.

La especificación `planta-motriz` (caja blanca) no cambia.

## Impact

- `Modelos/03_planta_motriz.sysml`: se borran las líneas 143 a 727 (una línea en blanco de separación, el comentario de cabecera y el subpaquete). Se conservan las líneas 1 a 142 y la llave de cierre del paquete `SubsistemaPlantaMotriz`. Ya se ha comprobado que el resultado es idéntico byte a byte al archivo en el commit `44d3656`, el estado aprobado y archivado de la caja blanca.
- Vistas: ninguna de las 12 vistas actuales muestra elementos de la caja negra. Los `expose SubsistemaPlantaMotriz::*` de `11_vistas.sysml` no son recursivos y no entran en el subpaquete. Línea base del 2026-11-25 en esta rama: `spec42 check Modelos` da 0 errores y 0 avisos, y las 12 vistas se renderizan.
- `Modelos/plan_desarrollo_planta_motriz.md`: se quitan la Fase 0 y las referencias a la caja negra y se mantiene la auditoría.
- `openspec/specs/planta-motriz-caja-negra/`: se retira al archivar.
- Sin cambios: `11_vistas.sysml` (ninguna vista expone la caja negra), `09_sistema_ugv.sysml`, `10_comportamiento.sysml`, `00_tipos_base.sysml`, los archivos de otros compañeros y el cambio archivado `2026-11-19-planta-motriz-caja-negra`, que se conserva como historial.
- Validación: con el binario de Spec42 que incluye la extensión de VS Code (`spec42 check Modelos`, `spec42 diagram Modelos` y `--view` para cada vista).
