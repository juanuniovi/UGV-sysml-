# Design: Renombrar ControlEmisionRadiante a ControlEmisionSigilosoNormal

## Context
En `Modelos/04_2_navegacion.sysml`, el subsistema de navegación modela la conmutación entre modo normal y modo sigiloso para los sensores radiantes (LiDAR y radar) según el requisito contractual `RGEN-09`. La señal de conmutación se definía mediante `item def ControlEmisionRadiante`. Véase `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**
- Renombrar de forma limpia y consistente `item def ControlEmisionRadiante` a `item def ControlEmisionSigilosoNormal` en `Modelos/04_2_navegacion.sysml`.
- Actualizar el uso del tipo en el parámetro de salida `out controlRadiante : ControlEmisionSigilosoNormal;` dentro de la acción `ConfigurarModoDeteccion`.
- Preservar la integridad sintáctica de SysML v2, la trazabilidad del requisito `RGEN-09` y las convenciones del repositorio (`TiposBase`, directivas `private import`, docstrings en español técnico).

**Non-Goals:**
- No alterar la arquitectura de puertos externos entre subsistemas ni los enlaces en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`), donde se emplean puertos de bus de datos (`DataBusPort`).
- No modificar ni relajar las exigencias de `RGEN-09`.
- No alterar otros subsistemas fuera de `04_2_navegacion.sysml`.

## Decisions

### Decisión 1: Formato sintáctico del identificador en SysML v2
- **Elección**: Utilizar el identificador CamelCase `ControlEmisionSigilosoNormal`.
- **Justificación**: En la gramática formal de SysML v2, las barras inclinadas `/` son operadores aritméticos y delimitadores léxicos, por lo que una cadena literal como `SIGILOSO/NORMAL` causaría un error de sintaxis en cualquier analizador (incluido Spec42). La combinación descriptiva `ControlEmisionSigilosoNormal` satisface exactamente la semántica pedida por el usuario manteniendo plena validez léxica y normativa.
- **Alternativas consideradas**:
  - `item def SIGILOSO_NORMAL`: Menos descriptivo sobre la naturaleza de ítem de control de emisión radiante.
  - `item def ModoEmisionSigilosoNormal`: Válido, pero cambiaría drásticamente el nombre del ítem en lugar de refinarlo.

### Decisión 2: Preservación del atributo interno
- **Elección**: Mantener `attribute emitir : Boolean;` dentro de `item def ControlEmisionSigilosoNormal`, complementado con su docstring que documenta la alternancia entre el estado `NORMAL` (emisión activa) y `SIGILOSO` (emisión inhibida).

## Risks / Trade-offs

- **[Riesgo] Referencias huérfanas en el modelo** → **Mitigación**: Auditoría de grep previa en todo el árbol `Modelos/` y confirmación de que solo existe referencia en `Modelos/04_2_navegacion.sysml` (líneas 35 y 194).
