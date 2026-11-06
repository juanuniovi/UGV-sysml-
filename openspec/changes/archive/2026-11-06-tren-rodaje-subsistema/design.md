# Design

## Context

Véase `proposal.md` para la motivación. Actualmente, [`Modelos/02_tren_rodaje.sysml`](Modelos/02_tren_rodaje.sysml) define `TrenRodajeRuedas` de forma embrionaria con partes sin tipar y un único requisito incompleto. A partir de los pliegos oficiales del CDTI (Anexo I: `RLT1-01` a `RLT1-05`), se debe diseñar una estructura detallada y trazable que represente la tracción directa, la suspensión neumática y la dirección.

## Goals / Non-Goals

**Goals:**
- Tipar explícitamente los subcomponentes del tren mediante definiciones `part def` independientes y documentadas.
- Formalizar los requisitos `RLT1-01` (tracción ruedas), `RLT1-02` (4x4 a 8x8), `RLT1-03` (movilidad y velocidad), `RLT1-04` (tracción directa/independiente) y `RLT1-05` (suspensión regulable/retráctil).
- Establecer relaciones `satisfy requirement : <Req> by <parte>;` en `TrenRodajeRuedas` validadas con Spec42 (`0 errors, 0 warnings`).
- Incluir comentarios explicativos continuos y citas normativas en el código SysML.
- Mantener los puertos `chassisMount`, `powerInput` y `controlBus` 100% compatibles con [`Modelos/09_sistema_ugv.sysml`](Modelos/09_sistema_ugv.sysml).

**Non-Goals:**
- No alterar la barcaza, la planta motriz ni el sistema GNC.
- No sobrecargar el modelo con ecuaciones cinemáticas no lineales (se reservan para `10_comportamiento.sysml` en fases futuras).

## Decisions

### Decisión 1: Modelado de componentes mediante `part def` modulares
- **Elección**: Definir dentro de `package SubsistemaTrenRodaje`:
  - `part def RuedaTraccionIndependiente`
  - `part def SuspensionNeumaticaRegulable`
  - `part def ServodireccionMultieje`
  - `part def SistemaFrenadoServicio`
- **Razón**: Permite tipar las partes internas y asignarles atributos físicos sin apelotonar la lógica en una sola entidad monolítica.

### Decisión 2: Trazabilidad y referencias continuas al pliego
- **Elección**: Incorporar bloques `doc /* ... */` explicativos en cada parte, atributo y requisito citando el identificador del pliego (`RLT1-XX`) y la justificación operativa.
- **Razón**: Cumple el requerimiento directo del autor de mantener el código auto-explicativo y trazable para auditorías y docencia.

### Decisión 3: Sintaxis canónica de `satisfy` para Spec42
- **Elección**: Ubicar los `satisfy requirement : <Req> by <usage>;` dentro del cuerpo de `TrenRodajeRuedas`.
- **Razón**: Respeta la gramática formal de Spec42 confirmada en el análisis sintáctico previo, garantizando cero advertencias (`satisfy_invalid_endpoint_kind`).

## Risks / Trade-offs

- **[Riesgo] Incompatibilidad de puertos con el ensamble global**:
  - *Mitigación*: Se conservan con idéntico nombre y tipo `chassisMount`, `powerInput` y `controlBus`, de modo que las conexiones `c_barcaza_rodaje`, `c_power_traction` y `c_drive_by_wire` de `09_sistema_ugv.sysml` no sufran regresiones.
