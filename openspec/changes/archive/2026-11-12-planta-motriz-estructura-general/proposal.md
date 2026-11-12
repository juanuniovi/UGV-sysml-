# Proposal

## Why

`Modelos/03_planta_motriz.sysml` (Issue #4) solo contiene una lista de partes sin tipo, sin puertos propios y sin conexiones internas, por lo que no puede verse en un diagrama cómo fluye la energía dentro de la planta motriz híbrida. Antes de detallar cada componente (potencias, capacidades, masas), se necesita una **estructura general**: los bloques principales y cómo se relacionan entre sí mediante flujos de combustible, potencia mecánica, potencia eléctrica y datos de gestión, visible en una vista de interconexión.

## What Changes

- **En `Modelos/03_planta_motriz.sysml`**:
  - Nuevas definiciones de puertos locales del subsistema: `PuertoCombustible` (suministro de combustible) y `PuertoEjeMecanico` (transmisión de par/giro motor → generador).
  - Nuevas definiciones de bloques generales (`part def`), solo con documentación y puertos, **sin atributos de dimensionado** (se dejan para la fase de detalle):
    - `DepositoCombustible`, `MotorCombustionBiocombustible`, `GeneradorElectrico`, `PackBateriasTraccion`, `UnidadDistribucionPotencia` (bus de alta tensión), `ConvertidorBajaTension` (alimentación de aviónica), `GestionEnergiaPMS`, `ModuloExportacionPotencia`.
  - `PlantaMotrizHibrida` pasa a tipar sus partes con esas definiciones y a declarar las **conexiones internas** de combustible, mecánicas, eléctricas y de datos, y los **enlaces (`binding`)** con sus puertos de contorno.
  - Se añaden las partes nuevas `depositoCombustible`, `distribucionPotencia` y `convertidorBajaTension`.
  - **Se elimina la parte `motoresElectricosTraccion[1..*]`** de la planta motriz: la tracción directa por rueda ya está modelada en `SubsistemaTrenRodaje::RuedaTraccionIndependiente` (`RLT1-01`, `RLT1-04`) y la planta solo le entrega potencia por `powerOutputTraction`. ⚠️ *Pendiente de confirmación explícita del autor en la revisión de esta propuesta.*
  - Se conservan **sin cambios** los puertos de contorno (`chassisMount`, `powerOutputTraction`, `powerOutputAvionics`, `powerOutputPayload`, `controlBus`), los atributos `potenciaNominalKW` y `capacidadBateriaKWh`, y los requisitos `ReqPotenciaMinimaPlataforma` (`RLT1-09`) y `ReqExportacionEnergia` (`RGEN-19`).
- **En `Modelos/11_vistas.sysml`**:
  - Nueva vista `vistaConexionesPlantaMotriz : InterconnectionView` (esquema de conexiones internas).
  - Nueva vista `vistaEstructuraPlantaMotriz : GeneralView` (jerarquía de bloques y puertos).
  - Nueva vista `vistaConexionesPlantaMotrizSistema : InterconnectionView`: la planta motriz junto con los subsistemas a los que alimenta o con los que se comunica (control, navegación, comunicaciones, carga de pago y UAV) y las conexiones existentes entre ellos. El montaje en barcaza y la tracción hacia el tren de rodaje se siguen viendo en `vistaConexionesPlataforma` (ver `design.md`, sección 6).
- **En `Modelos/plan_desarrollo_planta_motriz.md`** (documento de trabajo): reordenar las fases para reflejar el enfoque acordado (primero estructura y conexiones, después detalle de componentes).

## Fuera de alcance

- Atributos y valores de dimensionado (potencias, capacidades, tensiones, masas, depósito) → fase de detalle.
- Nuevas relaciones `satisfy` y cambios en el texto o las restricciones de cualquier requisito existente.
- Cambios en `00_tipos_base.sysml`, `02_tren_rodaje.sysml` y `09_sistema_ugv.sysml` (las conexiones externas de la planta no cambian).
- Comportamiento (estados o acciones del PMS) y su enlace con `10_comportamiento.sysml`.

## Capabilities

### New Capabilities
- `planta-motriz`: arquitectura estructural de la planta motriz híbrida del UGV (bloques, puertos, flujos internos de energía y datos, y vistas), base sobre la que se añadirán más adelante los requisitos de dimensionado.

### Modified Capabilities
<!-- Ninguna. No se modifica ningún requisito existente. -->

## Impact

- **Archivos afectados**: `Modelos/03_planta_motriz.sysml`, `Modelos/11_vistas.sysml`, `Modelos/plan_desarrollo_planta_motriz.md`.
- **Requisitos del pliego relacionados** (solo trazados en la documentación de los bloques, sin modificar): `RLT1-09`, `RGEN-11`, `RGEN-13`, `RGEN-19`, `RGEN-09`, `RLT1-01`, `RLT1-04`.
- **Requisitos existentes**: ninguno se modifica, relaja ni elimina.
- **Compatibilidad**: los puertos de contorno de `PlantaMotrizHibrida` se mantienen idénticos, así que todas las conexiones de `09_sistema_ugv.sysml` (`c_barcaza_powertrain`, `c_power_*`, `c_pms_control`, `c_payload_power`, `c_uav_power`) siguen siendo válidas. No hay ninguna referencia externa a `motoresElectricosTraccion` en el repositorio.
- **Validación**: `spec42 check Modelos` con 0 errores y 0 avisos.
