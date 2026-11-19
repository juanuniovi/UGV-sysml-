# Tasks

> **Alcance de edición**: solo `Modelos/03_planta_motriz.sysml` y el plan personal `Modelos/plan_desarrollo_planta_motriz.md`. **No se crea ni se modifica ninguna vista** (decisión del autor). Los demás archivos son de otros compañeros y no se editan.

## 0. Autorizaciones previas

- [x] 0.1 Registrar las decisiones del autor (César Bobes, 2026-11-19): el SoI es la planta motriz; la caja negra va dentro de `03_planta_motriz.sysml`; se autoriza consultar el Anexo I solo para `RGEN-06..19` y `RLT1-01..14`; solo se modifica `03_planta_motriz.sysml`; y no se crean vistas en este cambio. Verificación: esta tarea y la tabla de auditoría de `proposal.md`.
- [x] 0.2 Confirmar con el autor que las discrepancias 1 y 3 de `proposal.md` (en su archivo) **no** se corrigen en este cambio. Las 2, 4 y 5 están en archivos ajenos y solo se comunican a sus responsables. Verificación: respuesta del autor anotada aquí.
  - **Aprobado por el autor (César Bobes, 2026-11-19)**: «aplica», aprobando la propuesta tal como está redactada, en la que las discrepancias 1 a 5 solo se registran.
  - **Línea base de Spec42 en `main`** (`spec42 check Modelos`, binario de la extensión `elan8.spec42-0.61.1`): 0 errores y 6 avisos, todos previos y ajenos (`satisfy_invalid_endpoint_kind` y `satisfy_subject_type_mismatch` en `04_1_control.sysml:216-217` y `04_2_navegacion.sysml:287`). Criterio de este cambio: no añadir ningún aviso nuevo.

## 1. Requirements: partes interesadas y necesidades (`03_planta_motriz.sysml`)

- [x] 1.1 Crear al final de `SubsistemaPlantaMotriz` el subpaquete `CajaNegraPlantaMotriz` con `doc` (Fase 0, caja negra) y con `private import ScalarValues::*;` y `TiposBase::*;`. Verificación: el `git diff` muestra solo líneas añadidas tras `ReqExportacionEnergia`.
- [x] 1.2 Definir las `part def` de partes interesadas `OperadorMision`, `MantenedorPrimerEscalon`, `LogisticaCombustible` y `ClienteContratante`, cada una con su `doc`. Verificación: Spec42 sin errores.
- [x] 1.3 Definir las 12 `requirement def Nec...` de la tabla D3 de `design.md`, cada una con su `stakeholder`, un `doc` en lenguaje de usuario, su ID del pliego y la marca [OPCIONAL] en `RGEN-18` y `RGEN-19`. Verificación: revisar cada `doc` frente a la tabla de auditoría de `proposal.md`.
- [x] 1.4 Comprobar que Spec42 acepta `stakeholder`; si no, aplicar el plan B de D3 y anotarlo aquí. Verificación: `spec42 check` sin errores.

## 2. Structure: frontera, interfaces y contexto

- [x] 2.1 Definir los `item def` de materia, energía e información de D4. Verificación: Spec42 sin errores.
- [x] 2.2 Definir los `port def` `PuertoBocaRepostaje`, `PuertoAtmosfera`, `PuertoExposicionAmbiental` y `PuertoAccesoMantenimiento`, con flujos `in`/`out item` y su `doc`. Verificación: Spec42 sin errores.
- [x] 2.3 Definir `part def PlantaMotrizCajaNegra` con un `doc` que describa la frontera (dentro y fuera, `RLT1-04`) y los 11 puertos de la tabla D4. Verificación: los 11 puertos están presentes y ninguna parte interna de la caja blanca aparece referenciada.
- [x] 2.4 Definir los actores, los sistemas externos (sufijo `Externo`) y los elementos de entorno de D5, cada uno con su puerto complementario y un `doc` que diga a qué subsistema real representa. Verificación: Spec42 sin errores.
- [x] 2.5 Definir `part def ContextoPlantaMotriz` con la planta como bloque central y una `connection` por cada puerto de `PlantaMotrizCajaNegra`. Verificación: cada uno de los 11 puertos tiene al menos una conexión.

## 3. Behavior: casos de uso y secuencias

- [x] 3.1 Definir `UC1` a `UC8` de la tabla D6 con `subject`, `actor` y `objective`, y con el `doc` siguiendo la plantilla fija (objetivo, actores, precondiciones, postcondiciones, escenario principal, alternativos y excepción, trazabilidad). Verificación: cada `doc` contiene los siete apartados.
- [x] 3.2 Incluir como mínimo las excepciones de D6: batería agotada (UC2), falta de combustible (UC1), exportación que compromete la tracción (UC5) y entrada de agua en vadeo. Verificación: búsqueda de «E1.» en cada caso de uso afectado.
- [x] 3.3 Comprobar que cada caso de uso declara `subject planta : PlantaMotrizCajaNegra` y al menos un `actor`. Verificación: revisión del texto.
- [x] 3.4 Modelar las secuencias de contexto de UC1, UC2 y UC5 con mensajes tipados por los `item def` y solo con participantes externos y la planta. Verificación: la secuencia de UC2 sigue el orden orden de modo → confirmación o rechazo → tracción solo desde baterías → estado periódico.
- [x] 3.5 Comprobar que Spec42 acepta `message` en las secuencias; si no, aplicar el plan B de D6 y anotar aquí cuál. Verificación: `spec42 check` sin errores.

## 4. Parameters: MoEs

- [x] 4.1 Definir `metadata def MedidaEfectividad` (o el plan B de D7). Verificación: Spec42 sin errores.
- [x] 4.2 Añadir a `PlantaMotrizCajaNegra` los atributos MoE de la tabla D7, con tipos de `TiposBase` y unidad en el nombre. Verificación: hay 9 MoEs (11 atributos, porque las autonomías tienen dos).
- [x] 4.3 Definir `part def MoEsPlantaMotriz` con los umbrales y objetivos, poniendo «sin fijar» o «sin valor en el pliego» donde corresponda y citando en el `doc` las candidatas pendientes (disponibilidad, MTBF, coste de ciclo de vida). Verificación: ninguna cifra que no esté en la tabla de auditoría.
- [x] 4.4 Definir los `requirement def Umbral...` con `require constraint`. Las autonomías usan `or`, como en `RGEN-14` y `RGEN-15`, y la exportación y la recarga enchufable no llevan umbral obligatorio. Verificación: revisar cada restricción frente a la tabla D7.

## 5. Documentación del plan

- [x] 5.1 Actualizar `Modelos/plan_desarrollo_planta_motriz.md`: añadir la Fase 0 (caja negra) al mapa, marcar como completada la estructura interna (antes «Fase 1 en curso»), corregir la tabla «Punto de partida» y la fila `RLT1-14` de la matriz, y anotar como trabajo pendiente la reconciliación entre caja negra y caja blanca y los avisos para los responsables de las discrepancias 2, 4 y 5. Verificación: lectura del documento.

## 6. Verificación integral

- [x] 6.1 `spec42 check Modelos` con 0 errores y 0 avisos. Verificación: salida pegada aquí.
  - Spec42 se ha encontrado en la extensión de VS Code (`elan8.spec42-0.61.1/server/win32-x64/spec42.exe`). Resultado: `Checked 14 document(s): 0 error(s), 6 warning(s)`. Son los mismos 6 avisos de la línea base (0.2), previos y ajenos (`04_1_control.sysml` y `04_2_navegacion.sysml`); **el cambio no añade ningún aviso**. Además, se comprobó con una copia que Spec42 detecta errores introducidos a propósito dentro del subpaquete (tipos, mensajes y restricciones), así que lo analiza de verdad.
  - `stakeholder`, `message`, `first ... then`, `metadata def` y `@MedidaEfectividad` se aceptan, así que no hizo falta ningún plan B (tareas 1.4, 3.5 y 4.1).
- [x] 6.2 Abrir las vistas 10 a 12 existentes y confirmar que siguen funcionando. Si la vista 11 muestra el subpaquete nuevo, anotarlo para el cambio posterior de vistas (D9). Verificación: inspección visual del autor.
  - Comprobado con `spec42 diagram --format json` antes y después del cambio: las vistas 10, 11 y 12 contienen exactamente los mismos elementos (142, 136 y 532 nombres). La vista 11 **no** muestra el subpaquete, así que no hace falta aplicar D9. Queda la inspección visual opcional del autor.
- [x] 6.3 Ejecutar `git diff main --stat` y confirmar que solo cambian `03_planta_motriz.sysml` (solo el subpaquete nuevo, sin ningún `view`), el plan personal y la carpeta del cambio. Verificación: salida del diff.
- [x] 6.4 Ejecutar `openspec validate planta-motriz-caja-negra --strict`. Verificación: sin errores.

## Workflow follow-up

- Archivar con `opsx-archive` cuando 6.1 a 6.4 estén cerrados.
- Preguntar al autor si quiere cerrar el Issue #4 (probablemente no, porque quedan fases), fusionar `feat-planta-motriz-caja-negra` en `main` y hacer push, y borrar la rama.
