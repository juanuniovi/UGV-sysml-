# Design

## Context

Actualmente, `Modelos/09_sistema_ugv.sysml` (`package SistemaUGV`) define únicamente la estructura de ensamblaje de `PlataformaUGV` y `SistemaUGVPesadoDual` junto con sus conexiones mecánicas, eléctricas y de datos/RF, sin ningún atributo ni requisito general a nivel de sistema. Por su parte, `Modelos/11_vistas.sysml` ya incluye `expose SistemaUGV::*;` en `vistaRequisitos`, filtrando por `@SysML::RequirementDefinition`, `@SysML::RequirementUsage` y `@SysML::SatisfyRequirementUsage`.

## Goals / Non-Goals

**Goals:**
- Dotar a `PlataformaUGV` de los atributos físicos y operativos globales necesarios para expresar las restricciones cuantitativas del Anexo I (§3.1 `RGEN` y §3.2.1 `RLT1`), respetando el uso de `TiposBase::Masa` para todas las magnitudes de masa en kilogramos.
- Formalizar en `SistemaUGV` las definiciones de requisitos (`requirement def`) con sus respectivas restricciones (`require constraint { ... }`) para `RLT1-07`, `RLT1-08`, `RLT1-10`, `RGEN-01`, `RGEN-04`, `RGEN-06`, `RGEN-10`, `RGEN-14`, `RGEN-15`, `RGEN-16`, `RGEN-24`, `RGEN-25`, `RGEN-28`, `RGEN-29` y `RLT1-14`.
- Vincular dichos requisitos a `PlataformaUGV` y `SistemaUGVPesadoDual` mediante `satisfy requirement : <NombreRequisito>;`, garantizando su visualización automática en `VistasUGV::vistaRequisitos` y 0 errores / 0 advertencias en Spec42.

**Non-Goals:**
- No alterar ninguna definición existente en `01_barcaza.sysml`, `02_tren_rodaje.sysml`, `03_planta_motriz.sysml`, `04_navegacion_control.sysml` ni `08_cargas_pago.sysml` (cuyas observaciones para los especialistas ya se han canalizado mediante los GitHub Issues `#13` y `#14`).
- No modificar las conexiones (`connection c_...`) ni los nombres de partes o puertos actuales de `PlataformaUGV` ni `SistemaUGVPesadoDual`.

## Decisions

1. **Separación entre `requirement def`, `require constraint` y `satisfy requirement` en SysML v2**:
   - Cada cláusula general del pliego se modela como un `requirement def` con `subject` tipado (`PlataformaUGV` o `SistemaUGVPesadoDual`), bloque `doc /* ... */` con el identificador oficial (`RGEN-xx` / `RLT1-xx`) y una restricción `require constraint { ... }`.
   - En los requisitos cuantitativos (`RLT1-08`, `RLT1-07`, `RGEN-10`/`RLT1-14`, `RGEN-16`, `RLT1-10`, `RGEN-14`, `RGEN-15`), `require constraint` evalúa desigualdades explícitas sobre los atributos de `PlataformaUGV`.
   - En los requisitos normativos/arquitectónicos (`RGEN-01`/`RGEN-04`, `RGEN-06`, `RGEN-24`/`RGEN-25`, `RGEN-28`/`RGEN-29`), se sigue la convención canónica del repositorio (`require constraint { true }`) para mantener total compatibilidad con el analizador de Spec42.
   - Dentro de `part def PlataformaUGV` y `part def SistemaUGVPesadoDual`, se declaran cláusulas `satisfy requirement : <Req>;` (que corresponden a `SatisfyRequirementUsage` en el metamodelo SysML v2).

2. **Unidades y Tipos**:
   - Todas las magnitudes de masa (`masaOrdenMisionKg`, `capacidadCargaUtilKg`, `capacidadArrastreRemolqueKg`) se tipan con `TiposBase::Masa` (en kg), cumpliendo estrictamente `openspec/config.yaml`.
   - Las magnitudes cinemáticas, geométricas y temporales (`velocidadRemolcadoKmh`, `profundidadVadeoM`, `autonomiaTotalHoras`, `autonomiaTotalKm`, `autonomiaElectricaHoras`, `autonomiaElectricaKm`) se tipan con `ScalarValues::Real` indicando la unidad en el identificador del atributo.

3. **Estrategia de Validación**:
   - Verificar sintaxis y semántica de los 12 archivos en `Modelos/` con `spec42` (0 errores y 0 advertencias) y comprobar la correcta exposición en `VistasUGV::vistaRequisitos`.

## Risks / Trade-offs

- **Coexistencia de `ReqCapacidadCargaMinimaPlataforma` (`SistemaUGV`) y `ReqCapacidadCargaUtilPlataforma` (`SubsistemaCargasPago`)**:
  - Se utiliza el identificador `ReqCapacidadCargaMinimaPlataforma` en `SistemaUGV` (sobre `subject ugv : PlataformaUGV` con `ugv.capacidadCargaUtilKg >= 2000.0`) para evitar cualquier colisión de nombres en el espacio global de `VistasUGV` con `SubsistemaCargasPago::ReqCapacidadCargaUtilPlataforma` hasta que el especialista de `08_cargas_pago.sysml` aborde el Issue `#14`.
