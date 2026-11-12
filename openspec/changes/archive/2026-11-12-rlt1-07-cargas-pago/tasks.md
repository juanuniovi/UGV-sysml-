# Tasks

## 1. Requisito de masa máxima de módulo (`Modelos/08_cargas_pago.sysml`)

- [x] 1.1 Renombrar `requirement def ReqCapacidadCargaUtilPlataforma` a `ReqMasaMaximaModulo`.
- [x] 1.2 Sustituir su `doc` por el texto de `design.md` (límite máximo de masa del módulo, derivado de `RLT1-07`).
- [x] 1.3 Comprobar que `subject modulo : CargaPagoModular` y `require constraint { modulo.masaModuloKg <= 2000.0 }` quedan sin cambios.

## 2. Trazabilidad con el pliego (`Modelos/08_cargas_pago.sysml`)

- [x] 2.1 Cambiar la cabecera del paquete de `(RGEN-28, RLT1-12..14)` a `(RGEN-28, RLT1-13)`.
- [x] 2.2 Añadir al `doc` de `Modulo_ISTAR` la referencia `CP-05, Punto de Interfaz 2, RLT1-13`, conservando `UC-01`.
- [x] 2.3 Añadir al `doc` de `Modulo_Logistico` la referencia `CP-07, Punto de Interfaz 3, RLT1-13`, conservando `UC-02`.
- [x] 2.4 Añadir al `doc` de `Modulo_MEDEVAC` la referencia `CP-08, Punto de Interfaz 3, RLT1-13`, conservando `UC-03`.
- [x] 2.5 Verificar con `git grep` que no quedan referencias a `ReqCapacidadCargaUtilPlataforma` en `Modelos/` ni en `openspec/specs/`.

## 3. Verificación con Spec42

- [x] 3.1 Ejecutar Spec42 sobre todos los modelos de `Modelos/` y confirmar 0 errores y 0 avisos. Resultado: `Checked 13 document(s): 0 error(s), 0 warning(s), 0 info(s)` (Spec42 0.60.2).
- [x] 3.2 Confirmar que `VistasUGV::vistaRequisitos` (`Modelos/11_vistas.sysml`) procesa `ReqMasaMaximaModulo`. Verificado con `spec42 diagram Modelos --view VistasUGV::vistaRequisitos`.

## 4. Seguimiento

- [x] 4.1 Proponer al autor abrir un issue para modelar los Puntos de Interfaz PI-1 a PI-4 y las cargas obligatorias ausentes (`CP-01`, `CP-04`, `CP-09`, `CP-10`, `CP-14`). Propuesto al autor en el chat al cerrar el cambio.
- [x] 4.2 Proponer al autor abrir un issue para el responsable de `01_barcaza.sysml` sobre la discrepancia de `RLT1-06` (tara de 3.500–5.000 kg en el modelo frente a 3.500–7.000 kg en el pliego). Propuesto al autor en el chat al cerrar el cambio.
