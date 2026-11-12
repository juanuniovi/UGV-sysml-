# Design: Corrección de Tara Máxima y Trazabilidad RGEN en Barcaza

## Context

El subsistema de barcaza ([`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml)) formaliza el bastidor estructural del vehículo. La especificación actual fijó erróneamente el límite de tara en 5.000 kg, arrastrado de un borrador inicial previo a la incorporación de los pliegos oficiales del CDTI. El Anexo I §3.2.1 fija la tara admisible de la plataforma de ruedas en un rango de 3.500 kg a 7.000 kg (`RLT1-06`). Además, los códigos de requisitos generales deben concordar con el pliego oficial (`RGEN-03`, `RGEN-10`, `RGEN-23/26`).

## Goals / Non-Goals

**Goals:**
- Ajustar formalmente la restricción de `ReqMasaTaraPlataforma` en SysML v2 al rango `[3500.0, 7000.0]` kg.
- Alinear los identificadores `RGEN` de los requisitos y partes con el Anexo I del pliego CDTI.
- Establecer en [`AGENTS.md`](AGENTS.md) y [`openspec/config.yaml`](openspec/config.yaml) el protocolo preventivo de auditoría contra fuentes contractuales.
- Verificar el modelo resultante con Spec42 asegurando 0 errores y 0 avisos.

**Non-Goals:**
- No modificar los puertos mecánicos ni la topología física de `01_barcaza.sysml` (conservando compatibilidad total con [`Modelos/09_sistema_ugv.sysml`](Modelos/09_sistema_ugv.sysml)).
- No modificar requisitos de otros subsistemas (por ejemplo `RLT1-07` de cargas de pago o `RLT1-08` de masa en orden de combate).

## Decisions

### Decisión 1: Ajuste de Restricción Formal SysML v2 a 7.000 kg
- **Elección**: Sustituir en `ReqMasaTaraPlataforma`:
  ```sysml
  require constraint { barcaza.masa >= 3500.0 and barcaza.masa <= 7000.0 }
  ```
- **Justificación**: Cumple estrictamente con el requisito `RLT1-06` del Anexo I. Sumado a los 2.000 kg de carga útil mínima exigidos en `RLT1-07`, da exactamente los 9.000 kg de masa máxima en orden de combate fijados en `RLT1-08`, cerrando la coherencia global del sistema.
- **Alternativa descartada**: Mantener 5.000 kg como requisito interno derivado (descartado por el usuario para reflejar fielmente el pliego contractual y evitar discrepancias de auditoría).

### Decisión 2: Regularización de Identificadores RGEN
- **Elección**:
  - `ReqBarcazaComun`: documentar como `RGEN-03` (*«Barcaza principal común para todas las configuraciones del lote»*).
  - `ReqGanchoSTANAG4101`: documentar como `RGEN-10` (*«Arrastre de remolque $\ge 3.000\text{ kg}$ con gancho STANAG 4101»*).
  - `ReqCabestranteAutoRecuperacion`: documentar como `RGEN-23 / RGEN-26` (*«Puntos de anclaje con eslingas y cabestrante de autorrecuperación»*).
- **Justificación**: Resuelve la discrepancia detectada en el Issue #13 y consolida la trazabilidad de ingeniería hacia las especificaciones del cliente.

### Decisión 3: Cláusula Preventiva en Gobernanza (Anti-Arrastre de Errores)
- **Elección**: Añadir a [`AGENTS.md`](AGENTS.md) y [`openspec/config.yaml`](openspec/config.yaml) la sección normativa:
  > **Auditoría de Requisitos Contractuales**: *«Todo agente que cree o modifique requisitos vinculados a códigos contractuales (RGEN, RLT1, ROPE, RCOM, RNAV) está expresamente autorizado y obligado a contrastar la literalidad y los valores numéricos exactos con el pliego oficial de referencia en `docs/`. Queda prohibido asumir o heredar acríticamente valores de plantillas, maquetas o commits previos.»*
- **Justificación**: Elimina la causa raíz del problema: la combinación de una prohibición ciega de lectura de pliegos con la regla de preservación pasiva de requisitos antiguos.

## Risks / Trade-offs

- **[Riesgo]** Consumo excesivo de tokens al auditar pliegos en futuros cambios.
  - **Mitigación**: La regla preventiva autoriza la consulta únicamente de la sección o fragmento puntual relevante para el requisito a formalizar, manteniendo la prohibición de cargas masivas de contexto innecesario.
- **[Riesgo]** Ruptura de relaciones `satisfy` preexistentes.
  - **Mitigación**: Los nombres de los `requirement def` (`ReqMasaTaraPlataforma`, `ReqBarcazaComun`, etc.) y de las partes (`chasisProtegidoEnV`, etc.) se mantienen idénticos; solo se corrigen restricciones y docstrings de trazabilidad.

## Validation Plan

1. **Inspección de Sintaxis**: Verificar que `01_barcaza.sysml` compila limpiamente en Spec42.
2. **Auditoría de Trazabilidad**: Comprobar que los requisitos `RGEN-03`, `RGEN-10`, `RGEN-23/26` y `RLT1-06` concuerdan al 100% con el Anexo I.
3. **Validación de OpenSpec**: Ejecutar `openspec validate` sobre la propuesta y el delta consolidado.
