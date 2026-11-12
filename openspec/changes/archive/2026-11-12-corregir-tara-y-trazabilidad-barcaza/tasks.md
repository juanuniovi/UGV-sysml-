# Tasks: Corrección de Tara Máxima y Trazabilidad RGEN en Barcaza

## 1. Actualización de Requisitos en SysML v2

- [x] 1.1 Modificar la restricción numérica de `ReqMasaTaraPlataforma` en `Modelos/01_barcaza.sysml` fijando el rango en `barcaza.masa >= 3500.0 and barcaza.masa <= 7000.0` y actualizar su docstring formal citando RLT1-06 del Anexo I §3.2.1.
- [x] 1.2 Regularizar los códigos RGEN en `Modelos/01_barcaza.sysml`: actualizar `ReqBarcazaComun` a RGEN-03, `ReqGanchoSTANAG4101` a RGEN-10 y `ReqCabestranteAutoRecuperacion` a RGEN-23/RGEN-26, actualizando también los docstrings de `ChasisProtegidoEnV`, `CabestranteAutoRecuperacion` y `GanchoRemolqueSTANAG`.
- [x] 1.3 Comprobar que los puertos mecánicos (`rodajeMount`, `powertrainMount`, `avionicaMount`, interfaces de carga) y las relaciones `satisfy` canónicas permanecen intactos y compatibles con `Modelos/09_sistema_ugv.sysml`.

## 2. Salvaguarda Preventiva en Gobernanza (AGENTS.md y openspec/config.yaml)

- [x] 2.1 Incorporar en `AGENTS.md` la cláusula normativa obligatoria de "Auditoría de Requisitos Contractuales", autorizando y exigiendo la verificación puntual de valores y citas contra los pliegos de `docs/` antes de consolidar requisitos normativos.
- [x] 2.2 Reflejar la misma directriz preventiva en `openspec/config.yaml` dentro de las reglas de `proposal` y `specs`.

## 3. Verificación de Modelo y OpenSpec

- [x] 3.1 Verificar la sintaxis y coherencia formal de `Modelos/01_barcaza.sysml` comprobando que no se introducen advertencias ni errores en el espacio de nombres de SysML v2 (validación formal completada; validación visual de Spec42 lista para inspección en editor).
- [x] 3.2 Ejecutar `openspec validate` sobre el cambio `corregir-tara-y-trazabilidad-barcaza` para confirmar el cumplimiento estricto del esquema.

## Workflow follow-up

- Ejecutar `opsx-archive` para consolidar el delta en `openspec/specs/barcaza-chasis/spec.md`.
- Consultar al usuario para fusionar la rama `fix/issue-20-tara-barcaza-trazabilidad` en `main`, sincronizar con `origin` y cerrar el Issue #20 en GitHub.
