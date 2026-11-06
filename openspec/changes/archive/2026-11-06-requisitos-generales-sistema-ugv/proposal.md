# Proposal

## Why

El paquete `SistemaUGV` (`Modelos/09_sistema_ugv.sysml`) ensambla actualmente los bloques principales (`PlataformaUGV` y `SistemaUGVPesadoDual`) y su topología de conexiones internas, pero carece por completo de atributos globales, definiciones de requisitos (`requirement def`), restricciones evaluables (`require constraint`) y relaciones de satisfacción (`satisfy requirement`) para las condiciones y exigencias de carácter general del pliego oficial (`docs/ROBOT_TERRESTRE_Anexo_I.pdf`, §3.1 `RGEN-01..29` y §3.2.1 `RLT1-01..11`). Es necesario formalizar a nivel de sistema las restricciones transversales de masa máxima en orden de misión (`RLT1-08`), capacidad mínima de carga útil de plataforma (`RLT1-07`), capacidad de arrastre de remolque (`RGEN-10`, `RLT1-14`), velocidad de remolcado pasivo (`RGEN-16`), vadeo (`RLT1-10`), autonomía total y eléctrica (`RGEN-14`, `RGEN-15`), concepción nativa no tripulada (`RGEN-01`, `RGEN-04`), resistencia ambiental (`RGEN-06`), estiba/transporte (`RGEN-24`, `RGEN-25`) e invariancia de estabilidad en los puntos de interfaz (`RGEN-28`, `RGEN-29`).

## What Changes

- Incorporar en `Modelos/09_sistema_ugv.sysml` (`package SistemaUGV`):
  - **Atributos de prestaciones y masa a nivel plataforma (`part def PlataformaUGV`)**:
    - `masaOrdenMisionKg : Masa` (usando `TiposBase::Masa` en kg, para evaluar `RLT1-08`).
    - `capacidadCargaUtilKg : Masa` (capacidad nominal de carga útil de la plataforma en kg, para evaluar `RLT1-07`).
    - `capacidadArrastreRemolqueKg : Masa` (capacidad de arrastre de remolque trasero en kg, para evaluar `RGEN-10` y `RLT1-14`).
    - `velocidadRemolcadoKmh : Real` (velocidad máxima admisible al ser remolcado por otro vehículo en km/h, `RGEN-16`).
    - `profundidadVadeoM : Real` (profundidad de vadeo sin preparación en metros, `RLT1-10`).
    - `autonomiaTotalHoras : Real` y `autonomiaTotalKm : Real` (autonomía global híbrida en horas y km, `RGEN-14`).
    - `autonomiaElectricaHoras : Real` y `autonomiaElectricaKm : Real` (autonomía en modo puramente eléctrico sigiloso en horas y km, `RGEN-15`).
  - **Definiciones de requisitos generales cuantitativos y normativos (`requirement def` con `require constraint`)**:
    - `ReqMasaMaximaOrdenMision` (`RLT1-08`): `ugv.masaOrdenMisionKg <= 9000.0`.
    - `ReqCapacidadCargaMinimaPlataforma` (`RLT1-07`): `ugv.capacidadCargaUtilKg >= 2000.0`.
    - `ReqCapacidadArrastreRemolque` (`RGEN-10`, `RLT1-14`): `ugv.capacidadArrastreRemolqueKg >= 3000.0`.
    - `ReqVelocidadRemolcadoPasivo` (`RGEN-16`): `ugv.velocidadRemolcadoKmh >= 65.0`.
    - `ReqCapacidadVadeo` (`RLT1-10`): `ugv.profundidadVadeoM >= 0.75`.
    - `ReqAutonomiaTotalPlataforma` (`RGEN-14`): `ugv.autonomiaTotalHoras >= 8.0 and ugv.autonomiaTotalKm >= 400.0`.
    - `ReqAutonomiaModoElectrico` (`RGEN-15`): `ugv.autonomiaElectricaHoras >= 2.0 and ugv.autonomiaElectricaKm >= 100.0`.
    - `ReqConcepcionNativaNoTripulada` (`RGEN-01`, `RGEN-04`): concepción nativa como robot autónomo sin habitáculo de tripulación y supervisado/controlado remotamente desde el Puesto de Mando Portable.
    - `ReqResistenciaAmbiental` (`RGEN-06`): resistencia de la plataforma y sus subsistemas frente a agentes ambientales (temperaturas extremas, lluvia, humedad, corrosión y radiación solar).
    - `ReqEstibaTransporteEstrategico` (`RGEN-24`, `RGEN-25`): puntos de amarre y estiba dimensionados para aerotransporte en aeronave de ala fija según STANAG 3400 y transporte terrestre según UNE-EN 12195.
    - `ReqEstabilidadPuntosInterfaz` (`RGEN-28`, `RGEN-29`): preservación de la estabilidad estática y dinámica del UGV tanto con cualquier carga de pago acoplada en sus puntos de interfaz como sin carga montada.
  - **Usos de satisfacción de requisitos (`satisfy requirement`)**:
    - Declarar en `PlataformaUGV` y `SistemaUGVPesadoDual` las cláusulas `satisfy requirement : <Req>;` correspondientes para que queden trazadas en el modelo y se recopilen automáticamente en `VistasUGV::vistaRequisitos` (`Modelos/11_vistas.sysml`).
- **Fuera de alcance de este cambio**:
  - No se modifica ningún requisito existente en los subcomponentes (`01_barcaza.sysml`, `02_tren_rodaje.sysml`, `03_planta_motriz.sysml`, `04_navegacion_control.sysml` ni `08_cargas_pago.sysml`). Las revisiones puntuales detectadas para los especialistas de `01_barcaza.sysml` y `08_cargas_pago.sysml` han quedado registradas de forma independiente en los GitHub Issues `#13` y `#14`.

## Capabilities

### New Capabilities
- `sistema-ugv-requisitos-generales`: Requisitos y restricciones generales de nivel plataforma y sistema de interés (`SistemaUGV` en `09_sistema_ugv.sysml`), abarcando límites de masa en orden de misión (`RLT1-08`), capacidad mínima de carga útil (`RLT1-07`), arrastre y remolcado (`RGEN-10`, `RGEN-16`, `RLT1-14`), vadeo (`RLT1-10`), autonomía energética (`RGEN-14`, `RGEN-15`), concepción nativa no tripulada (`RGEN-01`, `RGEN-04`), resistencia ambiental (`RGEN-06`), estiba/transporte (`RGEN-24`, `RGEN-25`) y estabilidad con/sin cargas de pago (`RGEN-28`, `RGEN-29`).

### Modified Capabilities
<!-- Ninguna capacidad existente se modifica. -->

## Impact

- **Archivos afectados**:
  - `Modelos/09_sistema_ugv.sysml` (incorporación aditiva de atributos de plataforma, `requirement def` con `require constraint` y `satisfy requirement`).
- **Subsistemas y vistas afectados**:
  - `SistemaUGV` (`PlataformaUGV` y `SistemaUGVPesadoDual`).
  - `VistasUGV::vistaRequisitos` (`Modelos/11_vistas.sysml`) expondrá automáticamente los nuevos requisitos sin necesidad de editar `11_vistas.sysml` gracias a la directiva `expose SistemaUGV::*;` ya presente.
  - Se preservan intactas todas las partes (`vehiculo`, `puestoMando`, `consolaCPT`, `uavCenital`, `cargaPagoMision`) y todas las conexiones (`connection c_...`) existentes en `09_sistema_ugv.sysml`.
- **Requisitos del pliego relacionados y análisis de conflictos**:
  - Requisitos nuevos formalizados en `09_sistema_ugv.sysml`: `RGEN-01`, `RGEN-04`, `RGEN-06`, `RGEN-10`, `RGEN-14`, `RGEN-15`, `RGEN-16`, `RGEN-24`, `RGEN-25`, `RGEN-28`, `RGEN-29`, `RLT1-07`, `RLT1-08`, `RLT1-10`, `RLT1-14`.
  - Ningún requisito existente en `Modelos/*.sysml` ni en `openspec/specs/` resulta eliminado, relajado o contradicho.
