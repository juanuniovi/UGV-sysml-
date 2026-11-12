# Proposal

## Why

El GitHub Issue `#14` señala que el requisito `ReqCapacidadCargaUtilPlataforma` de `Modelos/08_cargas_pago.sysml` es incoherente con su origen en el pliego:

- Su `doc` afirma que «la plataforma de ruedas debe transportar al menos 2000 kg de carga útil continua (RLT1-07)», pero su restricción es `modulo.masaModuloKg <= 2000.0`, que limita la masa de un módulo de carga de pago y no la capacidad de la plataforma.
- El pliego (`docs/ROBOT_TERRESTRE_Anexo_I.pdf`, §3.2.1, pág. 108) establece en `RLT1-07`: «La capacidad de carga del UGV será de dos mil (2.000) kg como mínimo». Es una prestación mínima del vehículo, que ya está modelada correctamente en `SistemaUGV::ReqCapacidadCargaMinimaPlataforma` (`Modelos/09_sistema_ugv.sysml`, `ugv.capacidadCargaUtilKg >= 2000.0`).
- El nombre `ReqCapacidadCargaUtilPlataforma` sugiere una capacidad de la plataforma, cuando el requisito restringe la masa del módulo.
- La cabecera del paquete cita `RLT1-12..14`, pero los tres módulos modelados (ISTAR, logístico y MEDEVAC) corresponden únicamente a `RLT1-13` (Zona Superior, Puntos de Interfaz 2 y 3, Anexo I §3.2.2, págs. 108-109), y sus `doc` no citan los identificadores de carga de pago del pliego (`CP-05`, `CP-07`, `CP-08`).

La restricción `masaModuloKg <= 2000.0` es, sin embargo, válida y compatible con `RLT1-07`: si toda plataforma conforme admite al menos 2.000 kg, un módulo de como máximo 2.000 kg es admisible en cualquiera de ellas (peor caso). El problema es de redacción, nombre y trazabilidad, no de la condición evaluada.

## What Changes

En `Modelos/08_cargas_pago.sysml` (`package SubsistemaCargasPago`):

- **Renombrar** `ReqCapacidadCargaUtilPlataforma` a `ReqMasaMaximaModulo`.
- **Mantener sin cambios** la restricción `require constraint { modulo.masaModuloKg <= 2000.0 }` y el `subject modulo : CargaPagoModular`.
- **Reescribir el `doc`** del requisito para que coincida con la restricción y declare su carácter derivado: «La masa de un módulo de carga de pago no superará 2000 kg, de modo que no exceda la capacidad de carga mínima exigida a la plataforma (requisito derivado de RLT1-07).»
- **Corregir la cabecera del paquete**: de `(RGEN-28, RLT1-12..14)` a `(RGEN-28, RLT1-13)`.
- **Completar la trazabilidad de los módulos** con su identificador `CP` y su punto de interfaz, conservando la referencia al caso de uso existente:
  - `Modulo_ISTAR` → `CP-05`, Punto de Interfaz 2 (`RLT1-13`).
  - `Modulo_Logistico` → `CP-07`, Punto de Interfaz 3 (`RLT1-13`).
  - `Modulo_MEDEVAC` → `CP-08`, Punto de Interfaz 3 (`RLT1-13`).

**Fuera de alcance:**

- Modelar los Puntos de Interfaz PI-1 a PI-4 y las cargas obligatorias aún ausentes (`CP-01`, `CP-04`, `CP-09`, `CP-10`, `CP-14`). Se propondrá en un issue independiente.
- Comparar la masa del módulo con la capacidad real de la plataforma (`PlataformaUGV.capacidadCargaUtilKg`) en lugar del valor fijo de 2.000 kg (opción 2, descartada por el autor).
- La discrepancia de `RLT1-06` en `Modelos/01_barcaza.sysml:51` (tara 3.500–5.000 kg en el modelo frente a 3.500–7.000 kg en el pliego). Pertenece al subsistema barcaza y se comunicará a su responsable en un issue aparte.
- Cualquier cambio en `09_sistema_ugv.sysml` o en `11_vistas.sysml`.

## Capabilities

### New Capabilities

- `cargas-pago-modulares`: requisitos y trazabilidad del subsistema de cargas de pago modulares (`SubsistemaCargasPago` en `08_cargas_pago.sysml`): masa máxima por módulo derivada de `RLT1-07` y correspondencia de los módulos con las cargas `CP-05`, `CP-07` y `CP-08` de `RLT1-13`.

### Modified Capabilities

<!-- Ninguna capacidad de openspec/specs/ se modifica. -->

## Impact

- **Archivos afectados:** `Modelos/08_cargas_pago.sysml` (solo nombre y textos `doc`; ninguna restricción ni estructura cambia).
- **Referencias:** `ReqCapacidadCargaUtilPlataforma` no se referencia desde ningún otro archivo de `Modelos/` ni de `openspec/specs/`. Solo aparece en `VistasUGV::vistaRequisitos` mediante `expose SubsistemaCargasPago::*;`, que recogerá automáticamente el nuevo nombre.
- **Requisitos del pliego relacionados:** `RLT1-07`, `RLT1-13`, `RGEN-28`.
- **Conflictos:** el cambio no relaja ni endurece ninguna condición evaluable. `SistemaUGV::ReqCapacidadCargaMinimaPlataforma` queda como única formalización directa de `RLT1-07`.

## Autorización del autor (protección de requisitos)

Este cambio modifica un requisito existente (nombre, texto y trazabilidad de `ReqCapacidadCargaUtilPlataforma`), por lo que exige confirmación explícita según `AGENTS.md`.

- **Requisito afectado:** `SubsistemaCargasPago::ReqCapacidadCargaUtilPlataforma` (`Modelos/08_cargas_pago.sysml:36-40`), con origen declarado en `RLT1-07`.
- **Condición actual:** `modulo.masaModuloKg <= 2000.0`, con un `doc` que describe una capacidad mínima de la plataforma.
- **Cambio solicitado:** conservar la condición, renombrar el requisito a `ReqMasaMaximaModulo` y declararlo como derivado de `RLT1-07`.
- **Confirmación:** el autor (@cesarbobes) aprobó en el chat el 2026-11-12 la «opción 1» (mantener la restricción y corregir texto, nombre y trazabilidad). El renombrado se presentó como opcional y queda sujeto a la revisión de esta propuesta.
- **Justificación:** el requisito actual atribuye al pliego una condición que este no formula y su texto contradice su restricción. La condición sigue siendo útil como requisito derivado, porque garantiza que cualquier módulo cabe en cualquier plataforma conforme con `RLT1-07`.
