# Design

## Context

Véase `proposal.md`. Las incidencias de origen están documentadas en el commit `e37c750` (ruta de `spec42.serverPath`) y en el cambio archivado `2026-11-20-eliminar-satisfy-duplicado-rgen20-plataforma` (satisfacción duplicada de `RGEN-20`).

## Goals / Non-Goals

**Goals:**
- Dejar por escrito en `AGENTS.md` la causa de ambos fallos y la regla que los previene.
- Ampliar la validación Spec42 obligatoria para que detecte defectos que solo aparecen al renderizar.

**Non-Goals:**
- No reescribir ni reordenar el resto de `AGENTS.md`.
- No unificar el estilo de satisfacción entre subsistemas (interno o con `by`); solo se prohíbe la duplicidad.

## Decisions

### Decisión 1: Nueva sección al final de `AGENTS.md`
- **Elección**: Añadir la sección tras "Convenciones del proyecto", sin alterar las existentes.
- **Justificación**: Mantiene intactas las reglas vigentes y agrupa las lecciones aprendidas en un lugar ampliable.

### Decisión 2: Texto propuesto

```markdown
## Lecciones aprendidas y reglas preventivas

### Satisfacción única de requisitos
Cada requisito se satisface en un único nivel jerárquico. Si una definición de parte ya satisface un requisito internamente (`satisfy requirement : Req;`), no se repite en el contenedor con `satisfy requirement : Req by <parte>;`, y viceversa. Antes de añadir un `satisfy`, busca el requisito en `Modelos/*.sysml` y comprueba que no esté ya satisfecho.

*Origen (2026-11-20)*: `RGEN-20` estaba satisfecho dentro de `SistemaIluminacion` y otra vez en `PlataformaUGV` (`by iluminacion`). `spec42 check` no daba errores, pero las vistas que exponían la plataforma completa no se renderizaban (`diagram occurrence is outside the projected node set`).

### Validación de vistas con Spec42
La validación con Spec42 no termina en `spec42 check Modelos`: renderiza también todas las vistas (`spec42 diagram Modelos` para listarlas y `spec42 diagram Modelos --view <vista>` para cada una). Un cambio no está validado si alguna vista no se renderiza.

### Configuración compartida portable
Los archivos versionados (`.vscode/`, `openspec/config.yaml`, scripts) no contienen rutas absolutas ni dependientes de un usuario o equipo (por ejemplo, `C:\Users\<usuario>\...`). Las rutas locales van en la configuración de usuario del editor, fuera del repositorio.

*Origen (2026-11-20)*: `.vscode/settings.json` fijaba `spec42.serverPath` al perfil `Usuario` de un solo equipo; en el resto, Spec42 no arrancaba (`spawn ... ENOENT`). La extensión localiza su propio servidor sin necesidad de esa clave.
```

## Risks / Trade-offs

- **Riesgo**: Renderizar todas las vistas alarga la validación.
  - **Mitigación**: Son 12 vistas y el proceso tarda segundos con la CLI de Spec42.
