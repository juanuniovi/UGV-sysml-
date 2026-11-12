# Design

## Context

`Modelos/08_cargas_pago.sysml` define `CargaPagoModular` (atributo `masaModuloKg : Masa` y puertos `chassisMount`, `powerInput`, `dataBus`), tres especializaciones (`Modulo_ISTAR`, `Modulo_Logistico`, `Modulo_MEDEVAC`) y un único requisito, `ReqCapacidadCargaUtilPlataforma`, cuyo `doc` y restricción no coinciden (ver Issue `#14`).

`RLT1-07` ya está formalizado a nivel de plataforma en `Modelos/09_sistema_ugv.sysml` mediante `ReqCapacidadCargaMinimaPlataforma` (`subject ugv : PlataformaUGV`, `ugv.capacidadCargaUtilKg >= 2000.0`). El diseño del cambio archivado `2026-11-06-requisitos-generales-sistema-ugv` eligió ese nombre precisamente para no colisionar con el requisito de 08 hasta resolver el Issue `#14`.

Fuente consultada con autorización del autor: Anexo I §3.2.1 (`RLT1-06..08`) y §3.2.2 (`RLT1-12..14`, `CP-01..14`). El Contrato no contiene requisitos técnicos aplicables.

## Goals / Non-Goals

**Goals:**
- Hacer coherentes el nombre, el `doc` y la restricción del requisito de masa de módulo.
- Declarar explícitamente que es un requisito derivado de `RLT1-07`.
- Corregir y completar la trazabilidad del paquete con `RLT1-13` y `CP-05`, `CP-07` y `CP-08`.

**Non-Goals:**
- Cambiar la condición evaluada (`masaModuloKg <= 2000.0`) o el `subject`.
- Modelar puntos de interfaz o cargas de pago adicionales.
- Ligar la masa del módulo a `PlataformaUGV.capacidadCargaUtilKg` (opción 2, descartada).
- Editar `09_sistema_ugv.sysml`, `11_vistas.sysml` u otros paquetes.

## Decisions

1. **Conservar la restricción con valor fijo de 2.000 kg.** Es el peor caso compatible con `RLT1-07`: cualquier plataforma conforme admite al menos 2.000 kg, de modo que un módulo que cumpla el límite es admisible en todas. Evita introducir parámetros (`in attribute`) y vinculaciones entre paquetes.

2. **Renombrar a `ReqMasaMaximaModulo`.** El nombre actual describe una capacidad de la plataforma y se confunde con `SistemaUGV::ReqCapacidadCargaMinimaPlataforma`. Como no existen referencias externas al nombre antiguo (verificado con `git grep`), el renombrado no rompe ningún `satisfy` ni vista. Si el autor prefiere conservar el nombre durante la revisión, la tarea 1.1 se omite y el resto del diseño no cambia.

3. **Redacción de `doc` resultante** (sin tildes, según la convención actual de los `.sysml`):
   ```sysml
   requirement def ReqMasaMaximaModulo {
       subject modulo : CargaPagoModular;
       doc /* La masa de un modulo de carga de pago no superara 2000 kg, de modo que no exceda
              la capacidad de carga minima exigida a la plataforma (requisito derivado de RLT1-07). */
       require constraint { modulo.masaModuloKg <= 2000.0 }
   }
   ```
   - Cabecera: `doc /* Cargas de pago modulares intercambiables sobre la barcaza (RGEN-28, RLT1-13) */`.
   - `Modulo_ISTAR`: `... (UC-01; CP-05, Punto de Interfaz 2, RLT1-13) */`.
   - `Modulo_Logistico`: `... (UC-02; CP-07, Punto de Interfaz 3, RLT1-13) */`.
   - `Modulo_MEDEVAC`: `... (UC-03; CP-08, Punto de Interfaz 3, RLT1-13) */`.

4. **Sintaxis y tipos.** No se añaden imports, tipos ni elementos nuevos. Se mantienen `private import ScalarValues::*;` y `private import TiposBase::*;`, y `masaModuloKg : Masa` (kg).

## Compatibilidad

- No cambia ninguna condición evaluable, por lo que ningún requisito queda relajado ni endurecido.
- `VistasUGV::vistaRequisitos` expone `SubsistemaCargasPago::*` y mostrará el nuevo nombre sin editar `11_vistas.sysml`.
- `SistemaUGV::PlataformaUGV.cargaPagoMision : CargaPagoModular[0..1]` no se ve afectado.

## Validation

- Ejecutar Spec42 sobre todos los modelos de `Modelos/` con resultado de 0 errores y 0 avisos.
- Comprobar con `git grep` que no queda ninguna referencia a `ReqCapacidadCargaUtilPlataforma` en `Modelos/` ni en `openspec/specs/`.
- Comprobar que `vistaRequisitos` procesa `ReqMasaMaximaModulo`.

## Risks / Trade-offs

- **Valor fijo frente a capacidad real:** si una plataforma real superase los 2.000 kg, el límite fijo rechazaría módulos que sí cabrían. Se acepta por simplicidad; la opción 2 queda documentada como posible evolución.
- **Issue `#14` cita `docs/ROBOT_TERRESTRE_Anexo_I.pdf` y `RLT1-12..14` como puntos de interfaz:** tras consultar el pliego se confirma que `RLT1-14` corresponde a la Zona Trasera (PI-4, `CP-14` remolque), coherente con su uso actual en `09_sistema_ugv.sysml`.
