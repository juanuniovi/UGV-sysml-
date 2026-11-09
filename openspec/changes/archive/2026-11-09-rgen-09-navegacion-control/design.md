# Design

## Context

El archivo `Modelos/04_navegacion_control.sysml` necesita modelar la arquitectura interna del subsistema de Navegación y Control para el requisito **RGEN-09** empleando bloques tipados (`part def`), ítems de flujo (`item def`), puertos tipados (`port def`) que transporten dichos ítems, y conexiones internas (`connection ... connect ... to ...`) dentro de `SistemaNavegacionControl`, además de reflejar la relación con los Equipos de Control (`06_estaciones_control.sysml`) y disponer de vistas tanto de estructura (`GeneralView`) como de interconexiones (`InterconnectionView`) en `11_vistas.sysml`.

## Goals / Non-Goals

**Goals:**
- Definir `item def` para los flujos de datos de LiDAR (`DatosLidar`), radar (`DatosRadar`), visión por computador (`DatosVisionComputador`), mapa de obstáculos (`MapaObstaculosDetectados`), comando de modo (`ComandoModoDeteccion`), control de emisión radiante (`ControlEmisionRadiante`) y consigna de navegación (`ConsignaNavegacionAutonoma`).
- Definir `port def` que declaren explícitamente los `in item` / `out item` correspondientes.
- Definir `part def` para cada componente de `SistemaNavegacionControl` (`SensorLidar`, `SensorRadar`, `SistemaVisionComputador`, `ModuloDeteccionEvasion`, `ComputadorAutonomia`, `OdometriaVisualInercialVIO`, `ModuloFrenadoSeguridad`, `CamarasOpticas360`, `CamaraTermicaNocturna`) con sus puertos.
- Conectar internamente las partes dentro de `SistemaNavegacionControl` mediante sentencias `connection ... connect ... to ...` y enlazarlas con los puertos de contorno (`dataBus`, `driveByWireOutput`).
- Reflejar en `SubsistemaEstacionesControl` (`06_estaciones_control.sysml`) la capacidad de conmutar el modo de detección (`NORMAL` / `SIGILOSO`) desde todos los equipos de control (PMP y CPT).
- Proveer en `11_vistas.sysml` dos vistas dedicadas: `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView`.

**Non-Goals:**
- Alterar o eliminar requisitos existentes (`RNAV-01`, `ROPE-05`, `ROPE-06`, `RGEN-17`, `RGEN-20`, `RGEN-22`).
- Modificar los nombres de los puertos externos de `SistemaNavegacionControl` (`chassisMount`, `powerInput`, `dataBus`, `driveByWireOutput`) usados en `09_sistema_ugv.sysml`.

## Decisions

1. **Puertos tipados con flujo de ítems (`port def` + `in/out item`)**:
   - *Decisión*: Definir en `SubsistemaNavegacionControl`:
     - `port def PuertoDatosLidar { out item datos : DatosLidar; in item controlEmision : ControlEmisionRadiante; }`
     - `port def PuertoDatosRadar { out item datos : DatosRadar; in item controlEmision : ControlEmisionRadiante; }`
     - `port def PuertoDatosVision { out item datos : DatosVisionComputador; }`
     - `port def PuertoMapaObstaculos { out item mapa : MapaObstaculosDetectados; }`
     - `port def PuertoComandoModoDeteccion { out item comando : ComandoModoDeteccion; }`
     - `port def PuertoConsignaAutonomia { out item consigna : ConsignaNavegacionAutonoma; }`
   - *Justificación*: Permite que los puertos de los sensores radiantes (`SensorLidar`, `SensorRadar`) envíen sus datos (`out item`) hacia `ModuloDeteccionEvasion` y reciban en sentido inverso (`in item`) la orden de activación/desactivación de emisión radiante cuando el sistema pasa a modo `SIGILOSO` o `NORMAL`. Asimismo, usa puertos conjugados (`~PuertoDatosLidar`, etc.) en el receptor conforme al estándar SysML v2 y Spec42.

2. **Topología de interconexiones internas en `SistemaNavegacionControl`**:
   - *Decisión*: Dentro de `part def SistemaNavegacionControl`, conectar:
     - `sensoresLidar.puertoLidar` → `moduloDeteccionEvasion.entradaLidar`
     - `sensoresRadar.puertoRadar` → `moduloDeteccionEvasion.entradaRadar`
     - `sistemaVisionComputador.puertoVision` → `moduloDeteccionEvasion.entradaVision`
     - `camarasOpticas360.puertoVideo` → `sistemaVisionComputador.entradaOptica`
     - `camaraTermicaNocturna.puertoVideo` → `sistemaVisionComputador.entradaTermica`
     - `moduloDeteccionEvasion.salidaObstaculos` → `computadorAutonomia.entradaObstaculos`
     - `computadorAutonomia.salidaModoDeteccion` → `moduloDeteccionEvasion.entradaModoDeteccion`
     - `odometriaVisualInercialVIO.puertoOdometria` → `computadorAutonomia.entradaOdometria`
     - `computadorAutonomia.salidaConsigna` → `moduloFrenadoSeguridad.entradaConsigna`
     - `dataBus` → `computadorAutonomia.busComunicaciones` (recibe comandos desde PMP/CPT vía `SistemaComunicacionesEmbarcado`)
     - `moduloFrenadoSeguridad.salidaActuacion` → `driveByWireOutput` (envía actuación segura hacia `TrenRodajeRuedas`)
   - *Justificación*: Traza el camino completo de los datos desde la captación física (LiDAR, radar, cámaras/visión por computador), pasando por la detección/evasión de obstáculos estáticos y dinámicos y el computador de autonomía, hasta los buses del vehículo (`dataBus` y `driveByWireOutput`).

3. **Relación con `SubsistemaEstacionesControl` (`06_estaciones_control.sysml`)**:
   - *Decisión*: Añadir `part selectorModoDeteccionSigiloso;` en `PuestoMandoPortable` y en `ConsolaPortableCPT` (documentando `RGEN-09`: conmutación entre modo `NORMAL` y `SIGILOSO` desde todos los equipos de control). Las conexiones RF y de bus en `09_sistema_ugv.sysml` (`c_rf_blos`, `c_rf_los`, `c_bus_comms_gnc`) ya enlazan ambas estaciones con `vehiculo.navegacionControl.dataBus`.

4. **Doble vista en `11_vistas.sysml` (`GeneralView` + `InterconnectionView`)**:
   - *Decisión*: Definir en `package VistasUGV`:
     - `view vistaEstructuraNavegacionControl : GeneralView` exponiendo `SubsistemaNavegacionControl::*` con filtro de partes, puertos, ítems y requisitos.
     - `view vistaConexionesNavegacionControl : InterconnectionView` exponiendo `SubsistemaNavegacionControl::subsistemaGNC` (o `SistemaNavegacionControl`) para renderizar el diagrama de bloques internos (IBD) con todas las conexiones entre LiDAR, radar, visión por computador, módulo de detección y computador de autonomía.
   - *Justificación*: En Spec42, `GeneralView` muestra las definiciones y jerarquía de tipos (BDD), mientras que `InterconnectionView` dibuja las conexiones punto a punto entre los puertos de las partes internas (IBD).

## Risks / Trade-offs

- **[Risk] Conjugación de puertos (`~Port`) y validación en Spec42** → **Mitigation**: Verificar con `spec42.exe check Modelos` y `spec42.exe diagram` que cada `connect` enlaza puertos compatibles sin errores ni advertencias.
- **[Risk] Compatibilidad con `09_sistema_ugv.sysml`** → **Mitigation**: Mantener inalterados los nombres de las partes y puertos de contorno de `SistemaNavegacionControl` y `SubsistemaEstacionesControl`.
