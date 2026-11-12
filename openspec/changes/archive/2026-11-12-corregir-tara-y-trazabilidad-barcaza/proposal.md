# Proposal: Corrección de Tara Máxima (RLT1-06) y Trazabilidad RGEN en Barcaza (Issue #20)

## Why

Al auditar [`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml) tras los Issues #13 y #20 (abierto por César Bobes), se ha constatado que el requisito `ReqMasaTaraPlataforma` impone un límite superior de tara de 5.000 kg (`barcaza.masa <= 5000.0`), cuando el pliego oficial del CDTI (Anexo I §3.2.1, pág. 108, requisito `RLT1-06`) estipula de forma explícita:
> *«La tara o peso en vacío del UGV deberá encontrarse entre tres mil quinientos (3.500) y siete mil (7.000) kg»*.

### Causa Raíz del Error
1. **Origen en maqueta inicial**: El valor restrictivo de 5.000 kg y la numeración provisional `RGEN-02..05` se introdujeron en el commit fundacional del repositorio (`d13c59e`), como una estimación preliminar antes de que se incorporaran los pliegos contractuales definitivos.
2. **Efecto de contención de contexto estricta**: Al añadirse la regla en `AGENTS.md` prohibiendo la lectura autónoma de los PDFs de `docs/` para ahorrar tokens, los agentes de IA no pudieron contrastar los valores preexistentes con el documento contractual original.
3. **Protección acrítica de requisitos previos**: Durante la ejecución del cambio `2026-11-06-barcaza-chasis-subsistema`, se aplicó la regla de "protección de requisitos vigentes", preservando de manera pasiva el límite de 5.000 kg sin someterlo a validación con el pliego.

### Autorización Explícita del Usuario
En cumplimiento estricto de la cláusula de protección de requisitos de `AGENTS.md`, el usuario ha confirmado explícitamente la **Opción A**: ajustar el límite superior de tara a 7.000 kg para garantizar fidelidad contractual absoluta con el pliego oficial del CDTI y regularizar los códigos `RGEN`.

## What Changes

- **Modificación de Requisito Contractual (MODIFIED)**: En [`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml), se actualiza la restricción de `ReqMasaTaraPlataforma` de `barcaza.masa <= 5000.0` a `barcaza.masa <= 7000.0`, y su docstring trazable correspondiente.
- **Corrección de Identificadores RGEN**:
  - `ReqBarcazaComun`: pasa de citar `RGEN-02` a citar `RGEN-03` (barcaza común para el lote).
  - `ReqGanchoSTANAG4101`: pasa de citar `RGEN-05` a citar `RGEN-10` (arrastre de remolque $\ge 3.000\text{ kg}$ con gancho STANAG 4101).
  - `ReqCabestranteAutoRecuperacion`: pasa de citar `RGEN-04` a citar `RGEN-23` / `RGEN-26` (puntos de anclaje con eslingas y cabestrante de gran capacidad de autorrecuperación).
- **Medida Preventiva Transversal (Anti-Arrastre de Errores)**:
  - Incorporar en [`AGENTS.md`](AGENTS.md) y [`openspec/config.yaml`](openspec/config.yaml) una salvaguarda obligatoria: **Auditoría de Requisitos Contractuales**. Todo agente que formalice o actualice requisitos procedentes de pliegos oficiales queda autorizado y obligado a verificar contra el texto del pliego la literalidad y los rangos numéricos exactos, impidiendo la asunción ciega de valores heredados de plantillas o maquetas.

## Capabilities

### New Capabilities
<!-- Ninguna nueva capacidad de producto; se actualiza la capacidad existente y las reglas de gobernanza. -->

### Modified Capabilities
- `barcaza-chasis`: Actualiza el requisito de tara `RLT1-06` (límite superior ampliado a 7.000 kg) y la trazabilidad de los códigos `RGEN-03`, `RGEN-10` y `RGEN-23/26`.

## Impact

- **Código y Modelos**: [`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml).
- **Especificaciones**: Actualización del delta y sincronización en [`openspec/specs/barcaza-chasis/spec.md`](openspec/specs/barcaza-chasis/spec.md).
- **Gobernanza**: Actualización de directrices en [`AGENTS.md`](AGENTS.md) y [`openspec/config.yaml`](openspec/config.yaml) para evitar recurrencias.
- **Trazabilidad Global**: Compatibilidad total con la masa máxima en orden de misión de 9.000 kg (`RLT1-08`) y carga útil de 2.000 kg (`RLT1-07`). Cierre del Issue #20 en GitHub.
