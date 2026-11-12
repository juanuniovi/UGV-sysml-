# Hoja de Ruta y Guía Paso a Paso: Planta Motriz Híbrida (Issue #4)

> **Documento de trabajo personal para César Bobes (`@cesarbobes`)**  
> *Este archivo sirve de cuaderno de bitácora, guía técnica y referencia rápida para el desarrollo de `Modelos/03_planta_motriz.sysml`.*

---

## 🧭 Idea en una frase

La planta motriz es **el motor y la batería del robot**: un motor de biocombustible mueve un generador, la electricidad se guarda en baterías y se reparte a las ruedas y al resto de equipos. Un gestor de energía (PMS) decide en cada momento quién aporta y quién consume energía.

```
Motor HVO ──► Generador ──► Bus de potencia ──► Tracción (motores en rueda, tren de rodaje)
                               ▲     │        ├──► Aviónica (control, navegación, comunicaciones)
                    Baterías ◄─┘     │        └──► Cargas de pago / recarga UAV / exportación externa
                                     │
                         PMS (gestión de energía) ◄──► control.dataBus
```

---

## 📍 Punto de partida: qué hay hoy en `03_planta_motriz.sysml`

| Elemento | Estado actual | Qué falta |
| :--- | :--- | :--- |
| `PlantaMotrizHibrida` | Existe con 6 partes | Las partes **no tienen tipo** (`part def`), ni atributos, ni puertos propios |
| Puertos de contorno (`chassisMount`, `powerOutputTraction`, `powerOutputAvionics`, `powerOutputPayload`, `controlBus`) | Existen y ya están conectados en `09_sistema_ugv.sysml` | Conectarlos por dentro con las partes internas |
| `ReqPotenciaMinimaPlataforma` (`RLT1-09`, ≥ 140 kW) | Definido | **No tiene `satisfy`** |
| `ReqExportacionEnergia` (`RGEN-19`, 120 kW) | Restricción vacía `{ true }` | Restricción real y `satisfy` |
| `capacidadBateriaKWh : Real` | Sin tipo de `TiposBase` | Tipar con una magnitud de energía |
| Especificación OpenSpec | No existe `openspec/specs/planta-motriz/` | Crearla al archivar el primer cambio |

---

## 📋 Matriz de Requisitos Relacionados con la Planta Motriz

> ⚠️ **Pendiente de confirmar con el pliego**: los textos marcados con *(a confirmar)* se han deducido de los comentarios del modelo y deben contrastarse con `docs/curso_ROBOT_TERRESTRE_Anexo_I.pdf` (sección de requisitos generales `RGEN-11..19` y `RLT1-09`) antes de la propuesta OpenSpec. Recuerda que, según `AGENTS.md`, el agente solo puede abrir ese PDF con tu autorización expresa.

| Código | Resumen | ¿Por qué afecta a la planta motriz? | ¿Cómo lo resolvemos en SysML v2? |
| :--- | :--- | :--- | :--- |
| **`RLT1-09`** | Potencia combinada de propulsión ≥ 140 kW | Es la potencia que la planta debe poder entregar a las ruedas. | Atributo `potenciaNominalKW : Potencia` + `satisfy ReqPotenciaMinimaPlataforma`. |
| **`RGEN-19`** | Exportación de energía a consumidores externos ≥ 120 kW | La planta debe tener una salida de potencia hacia equipos externos. | `part def ModuloExportacionPotencia` con `potenciaExportacionContinuaKW` + restricción `>= 120.0` y `satisfy`. |
| **`RGEN-11`** *(a confirmar)* | Motor térmico compatible con biocombustible HVO 100 % | Define el tipo de motor de combustión. | `part def MotorCombustionBiocombustible` con atributo de combustible admitido. |
| **`RGEN-13`** *(a confirmar)* | Operación puramente eléctrica con baterías | Exige que las baterías puedan mover el vehículo sin el motor. | `part def PackBateriasTraccion` con capacidad y potencia de descarga. |
| **`RGEN-14`** | Autonomía total ≥ 8 h o 400 km | Depende del depósito de combustible y del consumo. | Ya está a nivel `PlataformaUGV`; la planta aporta atributos (depósito, consumo) que lo justifican. |
| **`RGEN-15`** | Autonomía eléctrica ≥ 2 h o 100 km | Depende de la capacidad de la batería. | Ya está a nivel `PlataformaUGV`; la planta aporta `capacidadBateriaKWh`. |
| **`RGEN-09`** | Modos NORMAL / SIGILOSO | En sigiloso el motor térmico se apaga y todo va por baterías. | El PMS recibe el modo por `controlBus`; enlace con `ModoSigiloso` de `10_comportamiento.sysml`. |
| **`RLT1-01`, `RLT1-04`** | Tracción eléctrica independiente por rueda | Los motores de rueda ya están en el tren de rodaje: la planta solo les da energía. | Interfaz `powerOutputTraction` → `rodaje.powerInput` (ya existe). |
| **`RGEN-10`, `RLT1-14`** | Arrastre de remolque ≥ 3.000 kg | Aumenta la potencia demandada en tracción. | Se tiene en cuenta al justificar la potencia nominal (sin requisito nuevo). |
| **`RLT1-08`** | Masa en orden de misión ≤ 9.000 kg | Motor, generador y baterías son de lo más pesado del vehículo. | Atributo `masaSubsistemaKg : Masa` como presupuesto de masa. |
| **`RGEN-06`** | Resistencia ambiental | Refrigeración y estanqueidad de motor y baterías. | Comentario/atributos de rugerización en las partes exteriores. |
| **`RLT1-10`** | Vadeo ≥ 0,75 m | Admisión de aire del motor y cofre de baterías no deben inundarse. | Atributo de cota de admisión / estanqueidad en el `chassisMount`. |

---

## 🎯 Clasificación por Objetivos (Grupos Funcionales)

### 🔥 Grupo 1: Generación Térmica (Motor HVO + Generador)
* **Objetivo**: producir electricidad a partir de biocombustible para mover el vehículo y recargar las baterías.
* **Componentes**: `MotorCombustionBiocombustible`, `GeneradorElectrico`.
* **Requisitos**: `[RGEN-11, RGEN-14, RLT1-09]`.

### 🔋 Grupo 2: Almacenamiento de Energía (Baterías de Tracción)
* **Objetivo**: guardar energía para poder circular solo con electricidad (modo sigiloso) y absorber picos de demanda.
* **Componentes**: `PackBateriasTraccion`.
* **Requisitos**: `[RGEN-13, RGEN-15, RGEN-09]`.

### 🧠 Grupo 3: Gestión de Energía (PMS)
* **Objetivo**: decidir quién aporta energía (motor, baterías o ambos) y quién la recibe, según el modo de operación (normal o sigiloso) que llega desde Control.
* **Componentes**: `GestionEnergiaPMS`, puerto `controlBus`.
* **Requisitos**: `[RGEN-09, RGEN-13, RGEN-15]`.

### ⚡ Grupo 4: Distribución de Potencia (Bus y Salidas)
* **Objetivo**: repartir la electricidad a tracción, aviónica y cargas de pago por sus puertos de salida.
* **Componentes**: bus interno de potencia, puertos `powerOutputTraction`, `powerOutputAvionics`, `powerOutputPayload`.
* **Requisitos**: `[RLT1-09, RLT1-01, RLT1-04]`.

### 🔌 Grupo 5: Exportación de Energía
* **Objetivo**: entregar al menos 120 kW de forma continua a consumidores externos (y alimentar la recarga del UAV y las cargas de pago).
* **Componentes**: `ModuloExportacionPotencia`.
* **Requisitos**: `[RGEN-19]`.

### ⚙️ Grupo 6: Interfaces Físicas, Masa y Ambiente
* **Objetivo**: cumplir el presupuesto de masa, la resistencia ambiental y el vadeo.
* **Componentes**: `chassisMount`, atributos de masa y estanqueidad.
* **Requisitos**: `[RLT1-08, RGEN-06, RLT1-10]`.

---

## 🤔 Decisiones a tomar antes de la propuesta

1. ✅ **¿Dónde viven los motores eléctricos de tracción?** *(resuelto el 2026-11-12)*  
   Estaban duplicados: en la planta (`motoresElectricosTraccion[1..*]`) y en el tren de rodaje (`RuedaTraccionIndependiente`).  
   👉 **Decisión**: se quedan en el tren de rodaje y se **quitan** de la planta. La planta solo entrega energía por `powerOutputTraction` (arquitectura híbrida serie).
2. **Numeración `RGEN-13` vs `RGEN-15`** en el comentario de `packBateriasTraccion` (línea 13): el comentario dice «autonomía silenciosa ≥ 2 h (`RGEN-13`)», pero en el resto del modelo esa autonomía es `RGEN-15`. Corregir con el pliego delante.
3. **Tipo para la energía (kWh)**: `TiposBase` no tiene magnitud de energía. Habrá que añadir `attribute def Energia :> Real;` en `00_tipos_base.sysml` (archivo compartido: avisar al equipo).
4. **Cifras de diseño** (potencia del motor, capacidad de batería, depósito…): se fijan en la Fase 2, justificadas con los requisitos, sin inventar valores que contradigan el pliego.

---

## 🗺️ Mapa de Fases Incrementales

```
[Fase 1: Estructura General y Conexiones (bloques + flujos + vistas)]  <--- EN CURSO (cambio OpenSpec planta-motriz-estructura-general)
   │
   ├──> [Fase 2: Detalle de Componentes (parámetros técnicos y requisitos)]
   │
   ├──> [Fase 3: Modos de Operación del PMS]
   │
   └──> [Fase 4: Integración Global y Revisión de Vistas]
```

> **Enfoque acordado**: primero los **bloques generales y cómo se relacionan** (energía, combustible, eje mecánico y datos) para verlo en un esquema; **después** el detalle de cada componente.

---

## 📌 Fase 1 (En curso): Estructura General y Conexiones

### Meta
Sustituir la lista de nombres por bloques tipados, **conectados entre sí** y con los puertos de contorno, sin atributos de dimensionado todavía.

### Paso a paso
1. **Puertos locales**: `PuertoCombustible` y `PuertoEjeMecanico`.
2. **Bloques generales (`part def`)**: `DepositoCombustible`, `MotorCombustionBiocombustible`, `GeneradorElectrico`, `PackBateriasTraccion`, `UnidadDistribucionPotencia`, `ConvertidorBajaTension`, `GestionEnergiaPMS`, `ModuloExportacionPotencia`.
3. **Quitar** `motoresElectricosTraccion` (decisión 1).
4. **Conexiones internas**: depósito → motor → generador → distribución; baterías ↔ distribución; distribución → convertidor y exportación; PMS ↔ todos los bloques.
5. **Enlaces con los enchufes de contorno**: distribución → `powerOutputTraction`, convertidor → `powerOutputAvionics`, exportación → `powerOutputPayload`, PMS → `controlBus`.
6. **Vistas**: Vista 10 (conexiones internas), Vista 11 (estructura) y Vista 12 (planta junto con los subsistemas que alimenta).
7. **Validar con Spec42** (0 errores, 0 avisos).

---

## 🔭 Fase 2: Detalle de Componentes (parámetros técnicos y requisitos)

**Requisitos:**
- `ReqPotenciaMinimaPlataforma` (`RLT1-09`): añadir su `satisfy`.
- `ReqExportacionEnergia` (`RGEN-19`): sustituir `{ true }` por una restricción real y añadir su `satisfy` (consultar antes con el autor, porque es un requisito existente).

**Parámetros:**

- `MotorCombustionBiocombustible`: `potenciaMaximaKW : Potencia`, `combustibleAdmitido : String`, `consumoEspecifico…`.
- `GeneradorElectrico`: `potenciaNominalKW : Potencia`, `tensionSalida : Tension`.
- `PackBateriasTraccion`: `capacidadKWh : Energia`, `potenciaDescargaKW : Potencia`, `tensionNominal : Tension`.
- `PlantaMotrizHibrida`: `capacidadDepositoLitros : Real`, `masaSubsistemaKg : Masa`.
- Comprobar que los valores elegidos permiten cumplir `RGEN-14` y `RGEN-15` a nivel plataforma.

---

## 🔌 Fase 3: Modos de Operación del PMS

1. **Flujos tipados** (opcional): `item def` y direcciones `in`/`out` en los puertos creados en la Fase 1.
2. **Modos de energía**: acción o estados del PMS (`Hibrido`, `SoloElectrico`, `Recarga`, `Exportacion`) coherentes con `ModoSigiloso` de `10_comportamiento.sysml`.

---

## 🧩 Fase 4: Integración Global y Revisión de Vistas

> Las vistas 10, 11 y 12 se crean ya en la Fase 1. En esta fase se revisan para que reflejen los atributos y requisitos añadidos en las Fases 2 y 3.

- **Verificar en `09_sistema_ugv.sysml`** (solo conexiones de mis puertos):
  - `c_barcaza_powertrain`: bancada en la barcaza.
  - `c_power_traction`, `c_power_control`, `c_power_navegacion`, `c_power_comms`: salidas de potencia.
  - `c_pms_control`: bus de datos con Control.
  - `c_payload_power`, `c_uav_power`: alimentación de cargas de pago y UAV.
- **Vistas en `11_vistas.sysml`:**
  - `vistaEstructuraPlantaMotriz : GeneralView` (BDD): piezas, atributos y requisitos.
  - `vistaConexionesPlantaMotriz : InterconnectionView` (IBD): flujo de energía interno.

---

## 🚀 Selección para comenzar

> **Primer cambio OpenSpec**: `planta-motriz-estructura-general` = **Fase 1** (estructura general y conexiones, sin dimensionado).  
> Antes de la Fase 2: revisar con el pliego los requisitos *(a confirmar)* y cerrar las decisiones 2 y 3.

---

## 💡 Buenas Prácticas y Reglas del Proyecto

- ✅ **Rama dedicada**: nunca trabajar en `main` (ej. `feat/planta-motriz-fase1`).
- ✅ **Flujo OpenSpec**: `propose` → revisión → `apply` → verificación → `archive` → `merge`.
- ✅ **Spec42**: 0 errores y 0 avisos antes de integrar.
- ✅ **Imports**: `private import ScalarValues::*;` y `private import TiposBase::*;`.
- ✅ **No invadir otros subsistemas**: cambios en `03_planta_motriz.sysml`; en `09_sistema_ugv.sysml` solo las conexiones de mis puertos; `00_tipos_base.sysml` avisando al equipo.
- ✅ **Protección de requisitos**: no modificar ni relajar requisitos existentes sin autorización expresa.
