# Design

## Context

- `Modelos/03_planta_motriz.sysml` contiene el paquete `SubsistemaPlantaMotriz`, que ya tiene la caja blanca: 8 `part def`, 2 puertos locales, `PlantaMotrizHibrida` con sus conexiones y dos requisitos (`ReqPotenciaMinimaPlataforma`, `ReqExportacionEnergia`).
- `TiposBase` ofrece `Masa`, `Potencia`, `Tension`, `Velocidad` y `Longitud`, y los puertos genéricos `MechanicalMountPort`, `ElectricalPowerPort`, `DataBusPort` y `RFPort`. Para horas y kilómetros, `09_sistema_ugv.sysml` usa `Real` con la unidad en el nombre (`autonomiaTotalHoras`), y este cambio sigue la misma convención para no tocar el archivo compartido.
- En el modelo no hay ningún `use case`, `actor`, `concern`, `stakeholder` ni `metadata def`.
- Spec42 no está disponible en el entorno del agente.
- La motivación y la auditoría del pliego están en `proposal.md`.

## Goals / Non-Goals

**Goals:**
- Modelar los cuatro pilares de caja negra de la planta motriz (necesidades, contexto, casos de uso y MoEs) con construcciones nativas de SysML v2.
- Dejar el modelo listo para que los diagramas se añadan en un cambio posterior. Por decisión del autor, este cambio **no crea vistas**.

**Non-Goals:**
- Enlazar la caja negra con la caja blanca (`PlantaMotrizHibrida :> PlantaMotrizCajaNegra`, `satisfy`, asignaciones). Se hará al pasar a caja blanca, porque añadir los puertos nuevos a `PlantaMotrizHibrida` obligaría a conectarlos por dentro.
- Corregir las discrepancias con el pliego listadas en `proposal.md`.
- Dimensionar componentes o fijar valores que el pliego no da.
- Contexto de los demás subsistemas o del UGV completo.

## Decisions

### D1. Subpaquete anidado `PlantaMotrizCajaNegra` dentro de `SubsistemaPlantaMotriz`

Por decisión del autor, todo va en `03_planta_motriz.sysml` y no se crean vistas (D8). El resto del modelo es de otros compañeros. Se crea un `package CajaNegraPlantaMotriz { ... }` anidado al final del paquete, con sus propios `private import ScalarValues::*;` y `private import TiposBase::*;`.

- *Alternativa descartada*: un archivo nuevo `03_0_...`, que el autor rechazó.
- *Alternativa descartada*: mezclarlo con la caja blanca, porque complicaría la separación entre fases. **Efecto colateral conocido**: la vista 11 (`vistaEstructuraPlantaMotriz`, del autor) expone `SubsistemaPlantaMotriz::*`. Un `::*` no recursivo solo añade el subpaquete como elemento, sin abrir su contenido. Si Spec42 lo despliega igualmente, se anota y se resuelve en el cambio posterior de vistas (D9).

### D2. Organización interna del subpaquete

```
package CajaNegraPlantaMotriz {
    // 1. Requirements: partes interesadas y necesidades
    // 2. Structure: items de intercambio, puertos de interfaz externa, bloque de caja negra,
    //    actores y sistemas externos, contexto
    // 3. Behavior: casos de uso (con especificacion textual) y secuencias
    // 4. Parameters: MoEs (en el bloque de caja negra) y requisitos de umbral
}
```

### D3. Partes interesadas y necesidades (Requirements)

- Cada parte interesada es una `part def` (`OperadorMision`, `MantenedorPrimerEscalon`, `LogisticaCombustible`, `ClienteContratante`). Las tres primeras se reutilizan como actores.
- Cada necesidad es una `requirement def Nec<Nombre>` con `doc` en lenguaje de usuario. Lleva el formato «*[Parte interesada]* necesita … (`RGEN-xx`)» y, si procede, la marca «[OPCIONAL en el pliego]».
- La parte interesada se declara con `stakeholder sh : <ParteInteresada>;` dentro de la `requirement def` (sintaxis estándar de SysML v2). *Plan B* si Spec42 no la acepta: quitar `stakeholder` y dejar la parte interesada solo en el `doc`.
- Las necesidades **no llevan restricción numérica**. Las cifras viven en las MoEs (D7).

| Necesidad | Parte interesada | Origen |
| :--- | :--- | :--- |
| `NecMovilidadHibridaBiocombustible` | Cliente | `RGEN-11` |
| `NecRecargaAutonomaBaterias` | Operador | `RGEN-12` |
| `NecOperacionSigilosa` | Operador | `RGEN-13` |
| `NecAutonomiaMision` | Operador | `RGEN-14`, `RGEN-15` |
| `NecPotenciaMovilidadYArrastre` | Operador | `RLT1-09`, `RGEN-10` |
| `NecAlimentacionEquiposEmbarcados` | Operador | `RGEN-01`, `RGEN-28` (los equipos y cargas necesitan energía) |
| `NecExportacionEnergia` [OPC] | Cliente | `RGEN-19` |
| `NecRecargaEnchufable` [OPC] | Logística / Mantenedor | `RGEN-18` |
| `NecRepostajeYMantenimientoSencillo` | Mantenedor / Logística | `RGEN-07`, `RGEN-08` [OPC] |
| `NecRobustezAmbientalYVadeo` | Cliente | `RGEN-06`, `RLT1-10` |
| `NecRemolcadoConPlantaInactiva` | Operador | `RGEN-16` |
| `NecContencionMasa` | Cliente | `RLT1-08` |

> Nota: `RGEN-01`, `RGEN-07`, `RGEN-08` y `RGEN-28` se identificaron en la misma lectura autorizada de §3.1 (sistema no tripulado con PMP, fabricación simple, mínimo de herramientas [OPCIONAL] y puntos de interfaz para cargas de pago).

### D4. Frontera e interfaces externas (Structure)

**Frontera.** Dentro: convertir combustible en electricidad, almacenar, gestionar y distribuir energía. Fuera: los motores de tracción por rueda (`RLT1-04`, en el tren de rodaje) y todos los demás subsistemas, que se tratan como sistemas externos. La frontera se documenta en el `doc` del bloque de caja negra.

**Items de intercambio** (`item def`), para poder tipar flujos y mensajes de secuencia:
- Materia: `Biocombustible`, `AireAdmision`, `GasesEscape`.
- Energía: `EnergiaElectrica`, `CalorResidual`, `EmisionAcustica`.
- Información: `OrdenModoEnergia`, `EstadoEnergia`, `AlarmaEnergia`.

**Puertos de interfaz externa** del bloque `PlantaMotrizCajaNegra`:

| Puerto | Tipo | Clase | Con quién |
| :--- | :--- | :--- | :--- |
| `potenciaTraccion` | `ElectricalPowerPort` | Energía (bidireccional: regeneración `RGEN-12`) | Tren de rodaje |
| `potenciaAvionica` | `ElectricalPowerPort` | Energía | Aviónica (Control, Navegación, Comunicaciones, Iluminación) |
| `potenciaCargaPago` | `ElectricalPowerPort` | Energía | Carga de pago y UAV |
| `exportacionExterna` | `ElectricalPowerPort` | Energía [OPC `RGEN-19`] | Consumidores externos |
| `recargaExterna` | `ElectricalPowerPort` | Energía [OPC `RGEN-18`] | Punto de recarga |
| `bocaRepostaje` | `PuertoBocaRepostaje` (nuevo) | Materia `RGEN-11` | Suministro de combustible / mantenedor |
| `intercambioAtmosfera` | `PuertoAtmosfera` (nuevo) | Materia y energía: aire, escape, calor, ruido (`RGEN-13`) | Atmósfera |
| `exposicionAmbiental` | `PuertoExposicionAmbiental` (nuevo) | Entorno (`RGEN-06`, `RLT1-10`) | Agentes ambientales y agua de vadeo |
| `fijacionChasis` | `MechanicalMountPort` | Mecánica | Barcaza |
| `enlaceControl` | `DataBusPort` | Información | Subsistema de Control |
| `accesoMantenimiento` | `PuertoAccesoMantenimiento` (nuevo) | Información y acción humana | Mantenedor |

Los cuatro `port def` nuevos se definen dentro del subpaquete. Sus nombres no coinciden con `PuertoCombustible` y `PuertoEjeMecanico` de la caja blanca, para evitar ambigüedades. Cada uno declara sus flujos con `in item` y `out item` usando los `item def` anteriores. Por ejemplo, `PuertoAtmosfera` tiene `in item aire : AireAdmision; out item escape : GasesEscape; out item calor : CalorResidual; out item ruido : EmisionAcustica;`.

- *Alternativa descartada*: reutilizar `PlantaMotrizHibrida` como bloque central, porque arrastraría la caja blanca al diagrama de contexto y carece de las interfaces de materia, recarga y exportación externa.

### D5. Actores, sistemas externos y contexto

- **Actores humanos** (`part def`): `OperadorMision` (siempre a través de Control, el PMP o la CPT; ordena modos), `MantenedorPrimerEscalon` y `LogisticaCombustible`.
- **Sistemas externos** (`part def` con sufijo `Externo`, para no chocar con los tipos reales de otros paquetes): `SubsistemaControlExterno`, `TrenRodajeExterno`, `BarcazaExterna`, `AvionicaExterna`, `CargaPagoYUAVExterno`, `ConsumidorExterno`, `PuntoRecargaExterno` y `SuministroCombustibleExterno`.
- **Entorno**: `AgentesAmbientales` (temperatura, lluvia, humedad, corrosión, radiación), `AguaVadeo` (dulce o salada, ≥ 0,75 m) y `Atmosfera`.
- Cada externo tiene el puerto conjugado (`~`) o complementario de la interfaz que le corresponde.
- *Por qué no se reutilizan los tipos reales* (`SistemaControl`, `TrenRodajeRuedas`…): en caja negra los externos solo importan por su interfaz, e importarlos acoplaría el análisis a la caja blanca de otros compañeros.

**Contexto**: `part def ContextoPlantaMotriz { part planta : PlantaMotrizCajaNegra; part ...; connection ...; }`, con una `connection` por cada puerto del bloque central (requisito «Toda interfaz conectada»).

### D6. Casos de uso y secuencias (Behavior)

Cada caso de uso es una `use case def UC<n>_<Nombre>` con `subject planta : PlantaMotrizCajaNegra;`, uno o varios `actor` y `objective { doc /* ... */ }`. La especificación textual va en el `doc` del caso de uso con esta plantilla fija:

```
Objetivo: ...
Actores: ...
Precondiciones: ...
Postcondiciones: ...
Escenario principal: 1. ... 2. ...
Escenarios alternativos / excepcion: A1. ... E1. ...
Trazabilidad: RGEN-xx
```

| UC | Nombre | Actores | Origen |
| :--- | :--- | :--- | :--- |
| UC1 | `PropulsarModoHibrido` | Control, Tren de rodaje, Atmósfera | `RGEN-11`, `RLT1-09`, `RGEN-10` |
| UC2 | `PropulsarModoElectricoSigiloso` | Control, Tren de rodaje | `RGEN-13`, `RGEN-15` |
| UC3 | `RecargarBateriasEnMarcha` (motor + regeneración) | Control, Tren de rodaje | `RGEN-12` |
| UC4 | `AlimentarEquiposEmbarcados` | Aviónica, Carga de pago y UAV | `RGEN-01`, `RGEN-28` |
| UC5 | `ExportarEnergia` [OPC] | Operador (vía Control), Consumidor externo | `RGEN-19` |
| UC6 | `RecargarDesdePuntoExterno` [OPC] | Mantenedor, Punto de recarga | `RGEN-18` |
| UC7 | `RepostarYMantener` | Mantenedor, Logística, Suministro de combustible | `RGEN-11`, `RGEN-07` |
| UC8 | `SoportarRemolcadoInactivo` (excepción de misión) | Operador, Tren de rodaje | `RGEN-16` |

Excepciones mínimas: batería agotada en UC2 (aviso a Control y petición de modo híbrido), falta de combustible en UC1 (paso a solo batería y alarma), petición de exportación que comprometería la tracción en UC5 (rechazo con estado) y entrada de agua en vadeo (alarma).

**Secuencias de contexto** (UC1, UC2, UC5): se modelan como `occurrence def Secuencia<UC>` con un evento por participante (Control, planta y externos) y `message <nombre> of <ItemDef> from <emisor> to <receptor>;` en orden, encadenados con `first ... then ...`. *Plan B*: si Spec42 rechaza `message`, la secuencia se modela como `action def` con `send`/`accept` ordenados, y si tampoco, como lista numerada en el `doc` del caso de uso. El plan B aplicado se registra en `tasks.md`.

### D7. MoEs (Parameters)

- `metadata def MedidaEfectividad;` marca cada MoE con `@MedidaEfectividad` (o `#MedidaEfectividad`). *Plan B*: si Spec42 no lo acepta, se marca con un comentario `// MoE`.
- Las MoEs son `attribute` del bloque `PlantaMotrizCajaNegra`. El umbral y el objetivo son atributos constantes en un `part def MoEsPlantaMotriz` (`umbral...`, `objetivo...`), y cada umbral se formaliza con un `requirement def Umbral<MoE>` sobre el bloque de caja negra con `require constraint`.

| MoE | Unidad / tipo | Umbral (pliego) | Objetivo | Origen |
| :--- | :--- | :--- | :--- | :--- |
| `potenciaPropulsionKW` | `Potencia` (kW) | ≥ 140 | sin fijar | `RLT1-09` |
| `autonomiaTotalHoras` / `autonomiaTotalKm` | `Real` (h / km) | ≥ 8 h **o** ≥ 400 km | sin fijar | `RGEN-14` |
| `autonomiaElectricaHoras` / `autonomiaElectricaKm` | `Real` (h / km) | ≥ 2 h **o** ≥ 100 km | sin fijar | `RGEN-15` |
| `fraccionBiocombustibleAdmisible` | `Real` (%) | 100 | 100 | `RGEN-11` |
| `recargaPorMotorYRegeneracion` | `Boolean` | true | true | `RGEN-12` |
| `potenciaExportableKW` | `Potencia` (kW) | sin umbral (opcional) | ≥ 120 | `RGEN-19` [OPC] |
| `recargaEnchufable` | `Boolean` | false admisible | true | `RGEN-18` [OPC] |
| `profundidadVadeoM` | `Longitud` (m) | ≥ 0,75 | sin fijar | `RLT1-10` |
| `masaPlantaKg` | `Masa` (kg) | sin valor en el pliego (cuota de los 9.000 kg de `RLT1-08`) | sin fijar | `RLT1-08` |

Disyunción del pliego: `require constraint { planta.autonomiaTotalHoras >= 8.0 or planta.autonomiaTotalKm >= 400.0 }`. Es distinta de la de `09_sistema_ugv.sysml`, que no se toca (discrepancia 2 de la propuesta).

Las MoEs sin valor en el pliego (disponibilidad, MTBF, coste de ciclo de vida) **no se modelan como atributos**. Se citan en el `doc` de `MoEsPlantaMotriz` como candidatas pendientes del equipo.

### D8. Sin vistas en este cambio

Por decisión del autor no se añade ni se modifica ningún `view`, ni en `11_vistas.sysml` ni en `03_planta_motriz.sysml`. Los diagramas de contexto (BDD e IBD), de casos de uso, de secuencias y de MoEs quedan para un cambio posterior. Los elementos se modelan de forma que ese cambio solo tenga que exponerlos: un bloque de contexto único, casos de uso con sujeto y actores, y secuencias como ocurrencias.

### D9. Compatibilidad con la caja blanca y las vistas existentes

No se edita ningún elemento existente de la caja blanca ni ninguna vista. La vista 11 del autor (`expose SubsistemaPlantaMotriz::*`) podría mostrar el subpaquete nuevo como un elemento más. Si ocurre, solo se anota y se corrige en el cambio posterior de vistas.

### D10. Validación

1. `spec42 check Modelos`, con 0 errores y 0 avisos (lo ejecuta el autor, porque el agente no tiene Spec42).
2. Revisar en el editor el texto del subpaquete y comprobar que las vistas 10 a 12 existentes siguen abriéndose.
3. Comprobar la trazabilidad: cada necesidad y cada MoE cita su ID del pliego.
4. Hacer `git diff main -- Modelos/` y comprobar que solo cambia el subpaquete nuevo de `03_planta_motriz.sysml` y que no hay ningún `view` nuevo ni modificado.

## Risks / Trade-offs

- [Spec42 puede no soportar `stakeholder`, `message` o `metadata`] → los planes B de D3, D6 y D7, registrados en `tasks.md`.
- [La caja negra y la caja blanca usan puertos distintos para la misma planta (`powerOutputTraction` frente a `potenciaTraccion`)] → es intencionado en la Fase 0. La reconciliación (especialización y asignación) se hará en la fase de caja blanca y queda anotada en el plan de desarrollo.
- [La numeración de `RGEN` y `RLT1` se ha reconstruido contando párrafos, porque los identificadores van en el margen del PDF] → se ha contrastado con la tabla de valoración (OG-05..07 cita `RGEN-18`, `RGEN-19` y `RLT1-11`) y coincide con el modelo existente.
- [Los nombres de los actores (`SubsistemaControlExterno`…) duplican conceptos de otros paquetes] → el sufijo `Externo` y el subpaquete evitan colisiones, y el `doc` de cada uno indica el subsistema real al que representa.
- [Sin diagramas en esta entrega, la caja negra solo se revisa como texto] → se pide un cambio posterior de vistas. Posible sobrecarga de la vista 11 → D9.

## Migration Plan

Solo se añaden elementos. Para deshacer el cambio basta con eliminar el subpaquete `CajaNegraPlantaMotriz`.
