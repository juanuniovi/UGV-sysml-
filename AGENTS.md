# Instrucciones obligatorias para agentes de IA

Estas instrucciones se aplican a todo el repositorio y a cualquier agente de IA que participe en él.

## Antes de actuar

1. Lee íntegramente `openspec/config.yaml`.
2. Comprueba `git status --short --branch`.
3. No trabajes directamente sobre `main`. Para cualquier cambio, usa una rama dedicada.
4. Desarrolla y valida exhaustivamente en la rama dedicada: todo el ciclo de edición, depuración y resolución de advertencias de Spec42 debe completarse en la rama antes de plantear la integración. Queda terminantemente prohibido subir micro-commits o entregas fragmentarias a `main`.
5. Trabaja por bloques funcionales completos y consolidados.
6. Conserva todos los cambios previos del usuario que no pertenezcan a la tarea actual.

## Flujo obligatorio

Todo cambio material debe seguir OpenSpec:

1. `opsx-propose`: crea `proposal.md`, el delta en `specs/`, `design.md` y `tasks.md`.
2. Detente y solicita la revisión del usuario antes de implementar.
3. `opsx-apply`: aplica únicamente la propuesta aprobada.
4. Verifica sintaxis, trazabilidad, requisitos y vistas afectadas.
5. `opsx-archive`: consolida las especificaciones y archiva el cambio terminado.
6. **Cierre e integración**:
   - Evalúa y confirma si el trabajo completado respeta las buenas prácticas y convenciones del proyecto (sin alteraciones indebidas de requisitos, modelos íntegros y trazables, bloque funcional completo y 0 errores y 0 avisos en Spec42).
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

## Acceso a documentos densos y pliegos de referencia

Los documentos PDF oficiales ubicados en `docs/` (`ROBOT_TERRESTRE_Contrato.pdf` y `ROBOT_TERRESTRE_Anexo_I.pdf`) contienen pliegos y especificaciones contractuales muy extensas. Para preservar el contexto y evitar consumo innecesario de tokens:

1. **Prohibición por defecto**: Ningún agente de IA debe leer, abrir, inspeccionar, indexar ni cargar en su contexto estos archivos de forma autónoma, automática o rutinaria.
2. **Petición directa del usuario**: Solo se accederá a ellos cuando el usuario lo solicite de manera explícita y directa en su instrucción.
3. **Propuesta previa justificada**: Si el agente detecta que consultar un dato específico de estos documentos resulta indispensable o conveniente para resolver una tarea o verificar un requisito, debe formular una propuesta en el chat detallando qué sección necesita consultar y por qué. Solo procederá a leer el archivo tras recibir la autorización expresa del usuario.

## Auditoría obligatoria de requisitos contractuales (Anti-alucinación y anti-arrastre)

Para evitar la propagación pasiva de errores o valores provisionales arrastrados de maquetas iniciales:

1. **Verificación de fuentes primarias**: Siempre que se formalice, modifique o consolide un requisito trazable al pliego oficial (identificadores `RGEN`, `RLT1`, `ROPE`, `RCOM`, `RNAV`), el agente queda expresamente autorizado y obligado a contrastar puntualmente la cita literal y los rangos numéricos exactos con el pliego de referencia en `docs/` antes de cerrar la especificación.
2. **Prohibición de asunción acrítica**: Queda terminantemente prohibido asumir, heredar o dar por válidos valores numéricos de requisitos procedentes de plantillas, maquetas o commits previos sin haberlos auditado contra el pliego.
3. **Requisitos derivados de diseño**: Si el equipo decide introducir un margen interno más restrictivo que el pliego (por ejemplo, para garantizar balance de masas o potencias), debe rotularse obligatoriamente en el docstring y en OpenSpec como *"Requisito derivado de diseño interno (más restrictivo que el pliego)"*, justificando el motivo técnico y sin atribuirse falsamente a la cláusula contractual primaria.

## Convenciones del proyecto

- Redacta en español técnico.
- Los `.sysml` de `Modelos/` son la fuente de verdad.
- Usa SysML v2, `private import` y los tipos definidos en `TiposBase`.
- Conserva los identificadores del pliego (`RGEN`, `RLT1`, `RNAV`, `ROPE`, `RCOM`) y su trazabilidad.
- No hay límites artificiales para la longitud de propuestas, diseños o listas de tareas.
- Toda implementación debe incluir validación con Spec42. Si Spec42 no está disponible, informa claramente de la validación pendiente.
- No uses ni reactives Docker, WSL, PostgreSQL o Eclipse SysON; su contenido en `residuos/` es histórico.

Una corrección tipográfica sin impacto semántico puede omitir la propuesta completa, pero nunca la rama dedicada.

## Lecciones aprendidas y reglas preventivas

### Satisfacción única de requisitos
Cada requisito se satisface en un único nivel jerárquico. Si una definición de parte ya satisface un requisito internamente (`satisfy requirement : Req;`), no se repite en el contenedor con `satisfy requirement : Req by <parte>;`, y viceversa. Antes de añadir un `satisfy`, busca el requisito en `Modelos/*.sysml` y comprueba que no esté ya satisfecho.

*Origen (2026-11-20)*: `RGEN-20` estaba satisfecho dentro de `SistemaIluminacion` y otra vez en `PlataformaUGV` (`by iluminacion`). `spec42 check` no daba errores, pero las vistas que exponían la plataforma completa no se renderizaban (`diagram occurrence is outside the projected node set`).

### Validación de vistas con Spec42
La validación con Spec42 no termina en `spec42 check Modelos`: renderiza también todas las vistas (`spec42 diagram Modelos` para listarlas y `spec42 diagram Modelos --view <vista>` para cada una). Un cambio no está validado si alguna vista no se renderiza.

### Configuración compartida portable
Los archivos versionados (`.vscode/`, `openspec/config.yaml`, scripts) no contienen rutas absolutas ni dependientes de un usuario o equipo (por ejemplo, `C:\Users\<usuario>\...`). Las rutas locales van en la configuración de usuario del editor, fuera del repositorio.

*Origen (2026-11-20)*: `.vscode/settings.json` fijaba `spec42.serverPath` al perfil `Usuario` de un solo equipo; en el resto, Spec42 no arrancaba (`spawn ... ENOENT`). La extensión localiza su propio servidor sin necesidad de esa clave.
