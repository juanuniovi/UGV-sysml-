# Proposal

## Why

Tres vistas de interconexión de `Modelos/11_vistas.sysml` (`vistaConexionesSoI`, `vistaConexionesPlataforma` y `vistaConexionesComunicaciones`) no se renderizan en Spec42 0.61.1, que devuelve el aviso `diagram occurrence is outside the projected node set`. El modelo es sintácticamente válido (`spec42 check Modelos`: 0 errores, 0 avisos); el fallo se produce únicamente al proyectar el diagrama.

La causa, aislada mediante bisección sobre una copia temporal del modelo, es que el requisito `ReqConscienciaSituacionalIluminacion360` (`RGEN-20`) se satisface **dos veces** sobre el mismo elemento:

1. `Modelos/04_3_iluminacion.sysml:47`, dentro de `part def SistemaIluminacion`: `satisfy requirement : ReqConscienciaSituacionalIluminacion360;`
2. `Modelos/09_sistema_ugv.sysml:150`, dentro de `part def PlataformaUGV`: `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;`

Toda vista que exponga `PlataformaUGV` completa (directamente o a través de `SistemaUGVPesadoDual::vehiculo`) proyecta ambas ocurrencias de satisfacción sobre `iluminacion`, y el renderizador no puede ubicar una de ellas en el conjunto de nodos proyectados. Eliminar cualquiera de las dos líneas resuelve las tres vistas; ningún otro requisito del modelo presenta esta doble satisfacción.

## What Changes

- **`Modelos/09_sistema_ugv.sysml`**: eliminar la línea `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;` de `PlataformaUGV`.
- **Se conserva** la satisfacción directa dentro de `SistemaIluminacion` (`Modelos/04_3_iluminacion.sysml:47`), que es la que exige expresamente la especificación vigente `subsistema-iluminacion` ("relación formal de satisfacción directa dentro de `SistemaIluminacion`") y la que concuerda con `subject ilum : SistemaIluminacion`.
- Se deja constancia en la especificación de que `RGEN-20` se satisface una única vez, para evitar que vuelva a duplicarse.

Esta elección revierte parcialmente la Decisión 2 del cambio archivado `2026-11-14-eliminar-duplicado-iluminacion360`, que mantenía ambas satisfacciones; entonces no se conocía su efecto sobre el renderizado.

## Protección de requisitos

- **No se modifica, relaja, sustituye ni elimina ningún requisito.** `ReqConscienciaSituacionalIluminacion360` (`RGEN-20`), su `subject`, su texto y su identificador permanecen intactos.
- La trazabilidad no se pierde: el requisito sigue satisfecho formalmente por `SistemaIluminacion`, y `PlataformaUGV` contiene `part iluminacion : SistemaIluminacion`, por lo que la satisfacción se hereda en la plataforma y en el SoI.
- No se requiere auditoría contra el pliego en `docs/`: no se formaliza ni altera ningún valor ni cita contractual.

## Autorización

- El cambio afecta a archivos de otro miembro del equipo (autor de `RGEN-20` e iluminación, Eloy Suárez Costales). El usuario (César) ha consultado al autor, que ha dado su conformidad explícita ("pa lante, si así lo arregla"), y ha solicitado la corrección el 2026-11-20.

## Capabilities

### New Capabilities
*(Ninguna)*

### Modified Capabilities
- `subsistema-iluminacion`: se precisa que la satisfacción de `RGEN-20` es única y reside en `SistemaIluminacion`, sin repetirse en `PlataformaUGV`.

## Impact

- `Modelos/09_sistema_ugv.sysml`: una línea eliminada en `PlataformaUGV`.
- `Modelos/04_3_iluminacion.sysml`: sin cambios.
- `Modelos/11_vistas.sysml`: sin cambios; `vistaConexionesSoI`, `vistaConexionesPlataforma` y `vistaConexionesComunicaciones` vuelven a renderizarse.
- `vistaRequisitos`: `ReqConscienciaSituacionalIluminacion360` sigue apareciendo como satisfecho.
