# Design

## Context

Véase `proposal.md` para la motivación. Spec42 0.61.1 no renderiza las vistas de interconexión que exponen `PlataformaUGV` completa porque `ReqConscienciaSituacionalIluminacion360` (`RGEN-20`) está satisfecho dos veces sobre `iluminacion`: dentro de `SistemaIluminacion` y en `PlataformaUGV` con `by iluminacion`.

### Diagnóstico realizado (sobre copia temporal, sin tocar el repositorio)

1. Listado y renderizado de las 13 vistas con `spec42 diagram`: fallan solo `vistaConexionesSoI`, `vistaConexionesPlataforma` y `vistaConexionesComunicaciones`; aumentar `--depth` no lo corrige.
2. Vistas de prueba exponiendo cada parte y cada conexión de `PlataformaUGV` por separado, y todas juntas: renderizan correctamente. Solo falla `expose PlataformaUGV::*`.
3. Supresión individual de cada atributo y cada `satisfy ... by` de `PlataformaUGV`: únicamente la supresión de la línea 150 (`... Iluminacion360 by iluminacion`) corrige las tres vistas.
4. Contraprueba: conservando la línea 150 y suprimiendo la satisfacción interna de `04_3_iluminacion.sysml:47`, las tres vistas también renderizan. Se confirma que la causa es la duplicidad, no la línea en sí.
5. Ningún otro requisito está satisfecho simultáneamente dentro de la definición del subsistema y en la plataforma.

## Goals / Non-Goals

**Goals:**
- Restaurar el renderizado de las tres vistas de interconexión afectadas.
- Mantener `RGEN-20` satisfecho de forma única y coherente con la especificación vigente.

**Non-Goals:**
- No modificar requisitos, `subject`, puertos, conexiones ni vistas.
- No unificar el estilo de satisfacción del resto de subsistemas (barcaza y rodaje satisfacen internamente; control y navegación con `by` en la plataforma).

## Decisions

### Decisión 1: Conservar la satisfacción interna y eliminar la de la plataforma
- **Elección**: Eliminar `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;` de `PlataformaUGV`.
- **Justificación**: La especificación vigente `subsistema-iluminacion` exige la "relación formal de satisfacción directa dentro de `SistemaIluminacion`"; eliminar la interna contravendría un requisito de especificación. La satisfacción interna concuerda además con `subject ilum : SistemaIluminacion` y se hereda en la plataforma mediante `part iluminacion : SistemaIluminacion`.
- **Alternativa descartada**: Eliminar la satisfacción interna (`04_3_iluminacion.sysml:47`) para alinear con el patrón de control y navegación. Descartada porque obligaría a modificar la especificación vigente de iluminación.
- **Relación con cambios previos**: Revierte parcialmente la Decisión 2 del cambio archivado `2026-11-14-eliminar-duplicado-iluminacion360`.

## Risks / Trade-offs

- **Riesgo**: `vistaRequisitos` deje de mostrar `RGEN-20` como satisfecho a nivel de plataforma.
  - **Mitigación**: La vista filtra `SatisfyRequirementUsage` en todos los paquetes, incluido `SubsistemaIluminacion`; la satisfacción interna sigue presente. Se verificará renderizando `vistaRequisitos`.
- **Riesgo**: Que la duplicidad reaparezca en futuros cambios.
  - **Mitigación**: El delta de especificación prohíbe expresamente la segunda satisfacción y documenta el motivo.
