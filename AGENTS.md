# Instrucciones obligatorias para agentes de IA

Estas instrucciones se aplican a todo el repositorio y a cualquier agente de IA que participe en él.

## Antes de actuar

1. Lee íntegramente `openspec/config.yaml`.
2. Comprueba `git status --short --branch`.
3. No trabajes directamente sobre `main`. Para cualquier cambio, usa una rama dedicada.
4. Conserva todos los cambios previos del usuario que no pertenezcan a la tarea actual.

## Flujo obligatorio

Todo cambio material debe seguir OpenSpec:

1. `opsx-propose`: crea `proposal.md`, el delta en `specs/`, `design.md` y `tasks.md`.
2. Detente y solicita la revisión del usuario antes de implementar.
3. `opsx-apply`: aplica únicamente la propuesta aprobada.
4. Verifica sintaxis, trazabilidad, requisitos y vistas afectadas.
5. `opsx-archive`: consolida las especificaciones y archiva el cambio terminado.
6. **Cierre e integración**:
   - Evalúa y confirma si el trabajo completado respeta las buenas prácticas y convenciones del proyecto (sin alteraciones indebidas de requisitos, modelos íntegros y trazables).
   - En caso afirmativo, consulta explícitamente al autor si desea:
     a) Cerrar el *issue* de GitHub relacionado (si existe).
     b) Fusionar (`merge`) la rama de trabajo dedicada en `main` y sincronizar (`push`) con el repositorio remoto.
     c) Eliminar la rama temporal de trabajo tanto en local como en remoto.

Durante la propuesta está prohibido editar directamente `Modelos/*.sysml`.

## Protección de requisitos

Si una petición modifica, elimina, relaja, sustituye o contradice un requisito existente:

1. Detente antes de editar o generar la propuesta.
2. Identifica el requisito afectado, su origen, su condición actual y el cambio solicitado.
3. Explica el impacto técnico y de trazabilidad.
4. Solicita confirmación explícita al usuario.
5. Registra la autorización y la justificación en los artefactos de OpenSpec.

No interpretes la petición de añadir un componente o requisito como autorización para alterar requisitos vigentes.

## Acceso a documentos densos y pliegos de referencia

Los documentos PDF oficiales ubicados en `docs/` (`curso_ROBOT_TERRESTRE_Contrato.pdf` y `curso_ROBOT_TERRESTRE_Anexo_I.pdf`) contienen pliegos y especificaciones contractuales muy extensas. Para preservar el contexto y evitar consumo innecesario de tokens:

1. **Prohibición por defecto**: Ningún agente de IA debe leer, abrir, inspeccionar, indexar ni cargar en su contexto estos archivos de forma autónoma, automática o rutinaria.
2. **Petición directa del usuario**: Solo se accederá a ellos cuando el usuario lo solicite de manera explícita y directa en su instrucción.
3. **Propuesta previa justificada**: Si el agente detecta que consultar un dato específico de estos documentos resulta indispensable o conveniente para resolver una tarea o verificar un requisito, debe formular una propuesta en el chat detallando qué sección necesita consultar y por qué. Solo procederá a leer el archivo tras recibir la autorización expresa del usuario.

## Convenciones del proyecto

- Redacta en español técnico.
- Los `.sysml` de `Modelos/` son la fuente de verdad.
- Usa SysML v2, `private import` y los tipos definidos en `TiposBase`.
- Conserva los identificadores del pliego (`RGEN`, `RLT1`, `RNAV`, `ROPE`, `RCOM`) y su trazabilidad.
- No hay límites artificiales para la longitud de propuestas, diseños o listas de tareas.
- Toda implementación debe incluir validación con Spec42. Si Spec42 no está disponible, informa claramente de la validación pendiente.
- No uses ni reactives Docker, WSL, PostgreSQL o Eclipse SysON; su contenido en `residuos/` es histórico.

Una corrección tipográfica sin impacto semántico puede omitir la propuesta completa, pero nunca la rama dedicada.
