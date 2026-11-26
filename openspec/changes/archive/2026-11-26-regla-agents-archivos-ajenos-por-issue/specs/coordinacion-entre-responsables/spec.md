# Spec Delta: coordinacion-entre-responsables

## ADDED Requirements

### Requirement: Identificación del responsable de cada archivo
El responsable de cada archivo de `Modelos/` y de su especificación en `openspec/specs/` SHALL ser la persona asignada en GitHub al *issue* del subsistema correspondiente. Si no existe *issue* o la asignación no es clara, el agente MUST preguntar al usuario antes de suponer quién es el responsable.

#### Scenario: Archivo sin responsable claro
- **WHEN** un agente necesita modificar un archivo cuyo subsistema no tiene *issue* asignado
- **THEN** pregunta al usuario quién es el responsable antes de editarlo o de redactar ningún *issue*

### Requirement: Cambios en archivos ajenos mediante issue
Un agente MUST NOT editar archivos cuyo responsable no sea el usuario con el que trabaja. Cuando su tarea requiera un cambio en un archivo ajeno, el agente SHALL redactar un *issue* dirigido al responsable que indique qué se necesita y en qué archivo, por qué, qué subsistema lo requiere y qué requisitos del pliego están implicados (o que se trata de un requisito derivado de diseño interno). El agente MUST NOT publicar el *issue* sin la confirmación del usuario.

#### Scenario: Necesidad de potencia de otro subsistema
- **WHEN** un agente que trabaja en Comunicaciones necesita que la Planta Motriz garantice una potencia de alimentación
- **THEN** no edita `03_planta_motriz.sysml`, redacta un *issue* para el responsable de la Planta Motriz con el consumo, la tensión y los modos de operación implicados, y lo publica solo tras la confirmación del usuario

### Requirement: Registro de dependencias externas en OpenSpec
Cuando un cambio OpenSpec dependa de un cambio en un archivo ajeno, `proposal.md` SHALL registrar la dependencia con el número de *issue* correspondiente y `tasks.md` MUST NOT incluir tareas que modifiquen ese archivo.

#### Scenario: Propuesta con dependencia abierta
- **WHEN** se redacta una propuesta cuya implementación completa requiere un dato que debe aportar otro subsistema
- **THEN** la propuesta cita el *issue* abierto como dependencia externa y sus tareas se limitan a los archivos del usuario

### Requirement: Archivos compartidos
Los archivos compartidos (`00_tipos_base.sysml`, `09_sistema_ugv.sysml`, `10_comportamiento.sysml`, la cabecera de `11_vistas.sysml`, `AGENTS.md` y `openspec/config.yaml`) MUST NOT modificarse sin el acuerdo de sus responsables o del equipo, y los cambios sobre ellos SHALL proponerse mediante *issue*.

#### Scenario: Necesidad de un tipo nuevo en TiposBase
- **WHEN** un subsistema necesita un tipo que no existe en `00_tipos_base.sysml`
- **THEN** el agente redacta un *issue* proponiendo el tipo y no edita `00_tipos_base.sysml` sin el acuerdo del equipo

### Requirement: Excepciones a la coordinación por issue
Cada responsable SHALL poder editar y añadir sus propias vistas en `11_vistas.sysml`, usando nombres cualificados en `expose` sin añadir `import` a la cabecera. Un cambio en un archivo ajeno SHALL poder realizarse si su responsable lo autoriza por escrito en el *issue*, registrando esa autorización en `proposal.md`.

#### Scenario: Cambio autorizado por el responsable
- **WHEN** el responsable de un archivo escribe en el *issue* que autoriza a otra persona a realizar un cambio concreto
- **THEN** el cambio puede implementarse y `proposal.md` enlaza el *issue* como registro de la autorización

#### Scenario: Vista propia en el archivo de vistas
- **WHEN** un responsable añade una vista de su subsistema en `11_vistas.sysml`
- **THEN** la vista usa nombres cualificados en `expose` y no se modifica la cabecera ni las vistas de otros responsables
