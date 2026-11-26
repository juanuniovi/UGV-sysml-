# Design

## Context

Véase `proposal.md`. El reparto actual del trabajo se refleja en la asignación de *issues* de GitHub por subsistema (#2 Barcaza, #3 Tren de rodaje, #4 Planta motriz, #5 Navegación y control, #11/#15 Comunicaciones, #12 Requisitos generales, #19 Iluminación). Un caso que motiva la regla: Comunicaciones (`05_comunicaciones.sysml`) se alimenta de `plantaMotriz.powerOutputAvionics` (`09_sistema_ugv.sysml`), pero ninguno de los dos subsistemas declara consumos ni balance de potencia; resolverlo exige que cada responsable actúe en su propio archivo.

## Goals / Non-Goals

**Goals:**
- Que ningún responsable encuentre en su archivo cambios que no ha decidido.
- Que las necesidades entre subsistemas queden registradas y trazables (en un *issue*), y no implícitas en un `diff`.
- Que la regla sea visible para todo el equipo y para cualquier agente de IA.

**Non-Goals:**
- No reescribir ni reordenar el resto de `AGENTS.md`.
- No fijar en el repositorio quién es responsable de cada archivo (lo fija GitHub).
- No impedir correcciones que el propio responsable pida o autorice.

## Decisions

### Decisión 1: El responsable se identifica por la asignación del *issue* en GitHub
- **Elección**: Responsable = persona asignada al *issue* del subsistema. Si no hay *issue* o no está claro, el agente pregunta al usuario.
- **Alternativa descartada**: Tabla de nombres en `AGENTS.md`. Duplicaría la información de GitHub, se desactualizaría y obligaría a editar un archivo compartido cada vez que cambie el reparto.

### Decisión 2: El agente redacta el *issue*, el usuario lo publica o confirma
- **Elección**: El agente prepara el texto (qué, por qué, requisitos implicados, propuesta orientativa) y solo lo publica con `gh issue create` tras la confirmación del usuario.
- **Justificación**: Publicar un *issue* es una acción visible para todo el equipo y notifica a terceros.

### Decisión 3: Dependencia externa en OpenSpec
- **Elección**: Si la tarea propia depende de un cambio ajeno, `proposal.md` lo lista en "Fuera de alcance" o en una sección de dependencias con el número de *issue*, y `tasks.md` no incluye tareas sobre ese archivo.
- **Justificación**: Mantiene cada cambio OpenSpec dentro de un único ámbito de responsabilidad.

### Decisión 4: Texto propuesto para `AGENTS.md`

Se inserta como nueva sección tras "Protección de requisitos", porque es una regla de alcance general del mismo tipo (qué no se puede tocar sin confirmación):

```markdown
## Coordinación entre responsables de subsistema

Cada archivo de `Modelos/` y su especificación en `openspec/specs/` tienen un responsable: la persona asignada en GitHub al *issue* de ese subsistema. Si no hay *issue* o la asignación no es clara, pregunta al usuario.

1. No edites archivos cuyo responsable no sea el usuario con el que trabajas, aunque el cambio parezca pequeño o evidente. Quien lleva el subsistema es quien conoce su diseño y debe decidir cómo se resuelve.
2. Si tu tarea necesita un cambio en un archivo ajeno, detente y redacta un *issue* dirigido a su responsable que indique:
   - qué se necesita (dato, puerto, atributo, corrección…) y en qué archivo;
   - por qué se necesita y qué subsistema lo requiere;
   - los requisitos del pliego implicados (`RGEN`, `RLT1`, `ROPE`, `RCOM`, `RNAV`) o, si es un valor propio, que es un requisito derivado de diseño interno;
   - opcionalmente, una sugerencia de solución, dejando claro que la decisión es del responsable.
3. No publiques el *issue* sin la confirmación del usuario.
4. Mientras el *issue* esté abierto, registra la dependencia en `proposal.md` (con su número) y deja fuera de `tasks.md` cualquier tarea sobre el archivo ajeno.
5. Los archivos compartidos (`00_tipos_base.sysml`, `09_sistema_ugv.sysml`, `10_comportamiento.sysml`, la cabecera de `11_vistas.sysml`, `AGENTS.md` y `openspec/config.yaml`) siguen el mismo criterio: se proponen por *issue* y no se modifican sin el acuerdo de sus responsables o del equipo.

Excepciones:
- Cada responsable puede editar y añadir sus propias vistas en `11_vistas.sysml`, usando nombres cualificados en `expose` en lugar de añadir `import` a la cabecera compartida.
- Si el responsable autoriza por escrito en el *issue* que otra persona haga el cambio, puede hacerse; registra esa autorización (enlace al *issue*) en `proposal.md`.
```

## Risks / Trade-offs

- **Riesgo**: Más lentitud cuando el cambio ajeno es trivial.
  - **Mitigación**: La excepción de autorización escrita permite que el responsable delegue cambios concretos en el propio *issue*.
- **Riesgo**: *Issues* sin asignar o archivos sin responsable claro (`06_estaciones_control`, `07_uav_cenital`, `08_cargas_pago`).
  - **Mitigación**: El agente pregunta al usuario en lugar de suponer; conviene que el equipo asigne esos *issues*.
- **Riesgo**: Se modifica `AGENTS.md`, que es compartido.
  - **Mitigación**: La integración en `main` queda condicionada al acuerdo del equipo (tarea 3.1).
