# Proposal

## Why

El modelo está repartido por subsistemas entre varios miembros del equipo (barcaza y tren de rodaje, planta motriz, navegación/control/iluminación, comunicaciones, requisitos generales), cada uno con su archivo en `Modelos/` y su *issue* de GitHub asignado. Sin embargo, ni `AGENTS.md` ni `openspec/config.yaml` dicen nada sobre quién puede editar qué:

- La única regla parecida ("los cambios no relacionados que ya existan en el árbol de trabajo pertenecen al usuario y deben preservarse") se refiere a cambios locales sin confirmar, no a la responsabilidad sobre cada archivo.
- Cuando un subsistema necesita algo de otro (por ejemplo, Comunicaciones necesita una potencia de alimentación que suministra la Planta Motriz, o la Planta Motriz necesita acordar la tensión del bus con el Tren de Rodaje), un agente de IA puede acabar editando directamente el archivo ajeno.
- Eso provoca que el responsable encuentre en su archivo cambios que no conoce ni ha decidido, y que pueden ser técnicamente incorrectos porque quien los hizo no conoce el diseño interno de ese subsistema.

La regla existe hoy solo como preferencia personal de un miembro del equipo en la memoria local de su asistente; no es visible para el resto del equipo ni para sus agentes.

## What Changes

Añadir a `AGENTS.md` una sección **"Coordinación entre responsables de subsistema"** que establezca:

- Cada archivo de `Modelos/` (y su especificación en `openspec/specs/`) tiene un responsable: la persona asignada al *issue* de GitHub de ese subsistema.
- Un agente no edita archivos cuyo responsable no sea el usuario con el que trabaja. Si su tarea requiere un cambio en ellos, redacta un *issue* dirigido al responsable con qué se necesita, por qué y qué requisitos están implicados, y es el responsable quien decide e implementa el cambio.
- El agente no publica el *issue* sin la confirmación del usuario.
- Mientras el *issue* esté abierto, la propuesta OpenSpec propia lo registra como dependencia externa y queda fuera de su alcance.
- Los archivos compartidos (`00_tipos_base.sysml`, `09_sistema_ugv.sysml`, `10_comportamiento.sysml`, la cabecera de `11_vistas.sysml`, `AGENTS.md`, `openspec/config.yaml`) siguen el mismo criterio: se propone el cambio por *issue* y no se edita sin el acuerdo de sus responsables o del equipo.
- Excepciones: las vistas propias de cada responsable en `11_vistas.sysml`, y los cambios que el responsable autorice expresamente (por escrito en el *issue*), registrando esa autorización en la propuesta OpenSpec.

## Capabilities

### New Capabilities
- `coordinacion-entre-responsables`: reglas de coordinación entre los responsables de cada subsistema para cambios que afectan a archivos ajenos.

### Modified Capabilities
*(Ninguna)*

## Protección de requisitos

No se modifica ningún requisito del pliego ni del modelo. El cambio afecta solo a `AGENTS.md` y a OpenSpec.

## Fuera de alcance

- No se incluye una tabla nominal de responsables en `AGENTS.md`: la fuente de verdad es la asignación de *issues* en GitHub, que el equipo ya usa y que se mantiene actualizada sin tocar el repositorio.
- No se crea `.github/CODEOWNERS`: el equipo integra en `main` mediante `merge` local y `push`, sin *pull requests*, por lo que no tendría efecto.
- No se modifica `openspec/config.yaml` (archivo compartido); `AGENTS.md` ya obliga a todos los agentes a seguirlo.

## Impact

- `AGENTS.md`: nueva sección; el resto del documento queda intacto. Como `AGENTS.md` es un archivo compartido, esta propuesta se somete al acuerdo del equipo antes de integrarse en `main`, aplicando la propia regla que introduce.
- `openspec/specs/coordinacion-entre-responsables/spec.md`: nueva especificación tras el archivado.
- Sin cambios en `Modelos/*.sysml`.
