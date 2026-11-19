# Proposal

## Why

El profesor sitúa la Fase 0 del Issue #4 (planta motriz híbrida) en el **análisis de caja negra** (*black box*): entender la misión, el entorno y quién interactúa con la planta motriz **sin hablar todavía de soluciones técnicas**. El repositorio no contiene hoy ningún elemento de caja negra: no hay necesidades de las partes interesadas, ni diagrama de contexto, ni casos de uso, ni medidas de efectividad (MoEs). Solo existe la estructura interna (caja blanca), que se adelantó en el cambio archivado `2026-11-12-planta-motriz-estructura-general`.

## What Changes

Se añade, **dentro de `Modelos/03_planta_motriz.sysml`** (decisión del autor) y en un subpaquete propio separado de la caja blanca, el análisis de caja negra de la planta motriz como Sistema de Interés (SoI), organizado en los cuatro pilares pedidos:

- **Requirements – Necesidades de las partes interesadas**: partes interesadas (operador de misión, mantenedor de primer escalón, logística de combustible, cliente/contratante) y sus necesidades, trazadas a las cláusulas del pliego auditadas (ver tabla).
- **Structure – Contexto del sistema**:
  - Frontera del sistema: qué es la planta motriz (SoI) y qué queda fuera.
  - Bloque de caja negra `PlantaMotrizCajaNegra` con sus **interfaces externas de alto nivel** de energía, materia e información.
  - Bloque de contexto con la planta como bloque central, los actores humanos, los sistemas externos (resto del UGV, puntos de recarga, consumidores externos) y el entorno (agentes ambientales, agua de vadeo, atmósfera).
- **Behavior – Casos de uso**:
  - Casos de uso de la planta motriz vista como caja negra, cada uno con actores, precondiciones, postcondiciones, escenario principal (*happy path*) y escenarios alternativos o de excepción.
  - Secuencias de contexto caja negra: mensajes que entran y salen de la planta sin detallar el interior.
- **Parameters – MoEs**: medidas de efectividad con **umbral** (*threshold*, obligatorio del pliego) y **objetivo** (*objective*, mejora deseable u opcional del pliego). Si el pliego no da valor, se declara así y se deja sin fijar en lugar de inventarlo.

No se modifica la estructura interna (caja blanca) ni ningún requisito existente.

### Auditoría contra el pliego (Anexo I, §3.1 y §3.2.1)

Consulta autorizada por el autor el 2026-11-19, limitada a los identificadores relacionados. La numeración se ha reconstruido contando párrafos, porque los identificadores van en el margen del PDF, y se ha contrastado con la tabla de criterios de valoración (OG-05..07).

| ID | Texto del pliego (resumen fiel) | Uso en este cambio |
| :--- | :--- | :--- |
| `RGEN-06` | Resistencia a agentes ambientales: temperaturas extremas, lluvia, humedad, corrosión, radiación solar. | Entorno del contexto y necesidad |
| `RGEN-10` | Arrastrar un remolque de hasta 3.000 kg como mínimo. | Necesidad (demanda de tracción) |
| `RGEN-11` | Propulsión híbrida: pack de baterías, motor eléctrico y motor de combustión que pueda usar biocombustible 100 %. | Necesidad, interfaz de combustible y MoE |
| `RGEN-12` | Baterías recargables por el motor de combustión y por la energía regenerada en las frenadas. | Necesidad, caso de uso y MoE |
| `RGEN-13` | Modo puramente eléctrico (sin motor de combustión) para operar sigilosamente con firma térmica y acústica reducida. | Necesidad, caso de uso y MoE |
| `RGEN-14` | Autonomía total ≥ 8 h de funcionamiento o 400 km. | MoE |
| `RGEN-15` | Autonomía en modo puramente eléctrico ≥ 2 h o 100 km. | MoE |
| `RGEN-16` | Poder ser remolcado por otros vehículos a ≥ 65 km/h. | Caso de uso de excepción (planta inactiva) |
| `RGEN-18` | **[OPCIONAL]** Movilidad híbrida enchufable: recarga en puntos de recarga. | Interfaz, caso de uso y MoE (objetivo) |
| `RGEN-19` | **[OPCIONAL]** Exportar energía a sistemas externos a la plataforma con ≥ 120 kW. | Interfaz, caso de uso y MoE (objetivo) |
| `RLT1-04` | Tracción directa e independiente en cada rueda. | Frontera: los motores de rueda quedan fuera de la planta |
| `RLT1-08` | Peso total en orden de misión ≤ 9.000 kg. | MoE de contribución (sin valor asignado a la planta) |
| `RLT1-09` | Potencia total del sistema de propulsión ≥ 140 kW (190 CV). | MoE |
| `RLT1-10` | Vadeo sin preparación ≥ 0,75 m en agua dulce y salada. | Entorno y MoE |

### Discrepancias detectadas (solo se registran; no se corrigen en este cambio)

Afectan a requisitos o comentarios existentes y, según `AGENTS.md`, cualquier corrección necesita una autorización expresa y un cambio propio. Las discrepancias 2, 4 y 5 están en archivos de otros compañeros (`09_sistema_ugv.sysml`, `10_comportamiento.sysml`) y solo se les comunican. La 1 y la 3 están en el archivo del autor y quedan para un cambio posterior:

1. **`RGEN-19` es OPCIONAL en el pliego**, pero `ReqExportacionEnergia` (`03_planta_motriz.sysml`) no lo indica.
2. **`RGEN-14` y `RGEN-15` dicen «8 h *o* 400 km» y «2 h *o* 100 km»**, pero `ReqAutonomiaTotalPlataforma` y `ReqAutonomiaModoElectrico` (`09_sistema_ugv.sysml`) usan `and`, una lectura más restrictiva que el pliego que no está rotulada como requisito derivado.
3. El comentario de `packBateriasTraccion` cita «autonomía silenciosa ≥ 2 h (`RGEN-13`)»; esa autonomía es `RGEN-15` (`RGEN-13` es el modo puramente eléctrico).
4. `ReqCapacidadArrastreRemolque` cita `RLT1-14` junto a `RGEN-10`. En el pliego el remolque solo aparece en `RGEN-10`; el texto que acompaña a `RLT1-14` pertenece a los puntos de interfaz.
5. `ModoSigiloso` (`10_comportamiento.sysml`) mezcla el modo de detección SIGILOSO (`RGEN-09`, sensores radiantes) con el modo puramente eléctrico (`RGEN-13`). El pliego los trata como dos cosas independientes.

## Capabilities

### New Capabilities
- `planta-motriz-caja-negra`: análisis de caja negra de la planta motriz híbrida: necesidades de las partes interesadas, frontera y contexto con interfaces externas, casos de uso con secuencias de contexto y medidas de efectividad con umbral y objetivo.

### Modified Capabilities
- Ninguna. La especificación `planta-motriz` (caja blanca) no cambia.

## Impact

El autor solo trabaja en su archivo; el resto del modelo es de otros compañeros. **Por decisión del autor, este cambio no crea ni modifica vistas**: los diagramas (contexto, UCD, secuencias y MoEs) se dejan para un cambio posterior.

- **`Modelos/03_planta_motriz.sysml`**: un subpaquete nuevo de caja negra añadido al final. El contenido existente (puertos, bloques, conexiones y requisitos) no se toca.
- `Modelos/plan_desarrollo_planta_motriz.md` (documento personal del autor): se añade la Fase 0 (caja negra) al mapa de fases y se actualiza la tabla de partida, que está desactualizada.
- Fuera de alcance, sin ninguna edición: `11_vistas.sysml` (ninguna vista nueva ni modificada), `09_sistema_ugv.sysml`, `10_comportamiento.sysml`, `00_tipos_base.sysml` y los archivos de los demás subsistemas.
- Validación: Spec42 **no está instalado** en el entorno del agente. La comprobación con 0 errores y 0 avisos queda pendiente y la ejecutará el autor (ver `tasks.md`).
