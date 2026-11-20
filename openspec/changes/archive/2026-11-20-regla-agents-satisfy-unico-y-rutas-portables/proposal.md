# Proposal

## Why

El 2026-11-20 se resolvieron dos fallos que impedían trabajar con Spec42 y que tenían causas evitables:

1. **Ruta absoluta de un equipo concreto en la configuración compartida.** `.vscode/settings.json` (versionado) fijaba `spec42.serverPath` a `C:\Users\Usuario\...\spec42.exe`, la ruta del perfil de Windows de un único miembro del equipo. En cualquier otro equipo el servidor no arrancaba (`spawn ... ENOENT`) y se perdía toda validación Spec42, que `AGENTS.md` exige para cada cambio.
2. **Doble satisfacción de un mismo requisito.** `ReqConscienciaSituacionalIluminacion360` (`RGEN-20`) se satisfacía a la vez dentro de `SistemaIluminacion` y en `PlataformaUGV` (`... by iluminacion`). `spec42 check` no lo detecta (0 errores, 0 avisos), pero el renderizador fallaba con `diagram occurrence is outside the projected node set` en todas las vistas que exponían la plataforma completa.

El segundo fallo pasó inadvertido porque la validación que se exige hoy se limita a `spec42 check`, que no proyecta los diagramas. Hacen falta reglas explícitas que prevengan ambos errores y una verificación que detecte el segundo antes de integrar.

## What Changes

Añadir a `AGENTS.md` una sección **"Lecciones aprendidas y reglas preventivas"** con tres reglas:

- **Satisfacción única de requisitos**: cada requisito se satisface en un solo nivel jerárquico; si una parte ya satisface un requisito dentro de su definición, no se repite con `satisfy ... by <parte>` en el contenedor, y viceversa.
- **Validación de vistas además de sintaxis**: la validación con Spec42 incluye renderizar todas las vistas (`spec42 diagram`), no solo `spec42 check`, porque hay defectos que solo aparecen al proyectar diagramas.
- **Configuración compartida portable**: los archivos versionados (`.vscode/`, `openspec/config.yaml`, scripts) no contienen rutas absolutas ni dependientes de un perfil de usuario; las rutas locales van en la configuración de usuario del editor.

## Capabilities

### New Capabilities
- `buenas-practicas-modelado-entorno`: reglas preventivas de modelado y de configuración del entorno derivadas de incidencias reales.

### Modified Capabilities
*(Ninguna)*

## Protección de requisitos

No se modifica ningún requisito del pliego ni del modelo. El cambio afecta solo a `AGENTS.md` y a OpenSpec.

## Impact

- `AGENTS.md`: nueva sección; el resto del documento queda intacto.
- `openspec/specs/buenas-practicas-modelado-entorno/spec.md`: nueva especificación tras el archivado.
- Sin cambios en `Modelos/*.sysml`.
