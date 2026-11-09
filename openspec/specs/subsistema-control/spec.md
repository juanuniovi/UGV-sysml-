# subsistema-control Specification

## Purpose

Especifica la arquitectura interna, bloques tipados, puertos, conexiones, acciones y vistas del subsistema **4.1 Control** (`SubsistemaControl` en `Modelos/04_1_control.sysml`), encargado del computador de autonomía/guiado (`ComputadorAutonomia`), la gestión de comandos de modo de detección (`NORMAL` / `SIGILOSO`, `RGEN-09`) recibidos desde los Equipos de Control y el frenado automático de seguridad (`ModuloFrenadoSeguridad`, `RGEN-17`) hacia el tren de rodaje (`driveByWireOutput`).

## Requirements

### Requirement: Separación estructural del Subsistema 4.1 de Control (ROPE-05, RGEN-09, RGEN-17)
El modelo SHALL definir en `Modelos/04_1_control.sysml` el paquete `SubsistemaControl` con el bloque principal `SistemaControl` (y la instancia `subsistemaControl : SistemaControl`), integrando las partes tipadas `computadorAutonomia : ComputadorAutonomia` y `moduloFrenadoSeguridad : ModuloFrenadoSeguridad`.

#### Scenario: Composición interna de SistemaControl
- **WHEN** se inspecciona la estructura de `SubsistemaControl::SistemaControl`
- **THEN** contiene únicamente los bloques de control y actuación segura (`computadorAutonomia` y `moduloFrenadoSeguridad`), sin acoplar directamente los sensores físicos de navegación

### Requirement: Puertos de contorno e interconexiones internas de SistemaControl (ROPE-05, RGEN-17)
El bloque `SistemaControl` SHALL exponer puertos de montaje y alimentación (`chassisMount`, `powerInput`), puertos de bus de plataforma (`dataBus`, `driveByWireOutput`) y puertos de interfaz de entrada desde el Subsistema de Navegación (`entradaObstaculos : ~PuertoMapaObstaculos`, `entradaOdometria : ~PuertoOdometriaVIO`), enlazándolos con `computadorAutonomia` y `moduloFrenadoSeguridad` sin enviar la orden de modo de detección desde `computadorAutonomia`.

#### Scenario: Flujo interno de consignas en SistemaControl
- **WHEN** `SistemaControl` recibe un mapa de obstáculos por `entradaObstaculos`, odometría por `entradaOdometria` y órdenes de misión desde `dataBus`
- **THEN** `computadorAutonomia` calcula y envía las consignas de conducción (`PuertoConsignaAutonomia`) a `moduloFrenadoSeguridad`, el cual las supervisa y entrega en `driveByWireOutput`

### Requirement: Vista conjunta de Control y Navegación en VistasUGV
El paquete `VistasUGV` en `Modelos/11_vistas.sysml` SHALL representar conjuntamente `SubsistemaControl` y `SubsistemaNavegacion` en las vistas `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView`.

#### Scenario: Renderizado conjunto de Control y Navegación en Spec42
- **WHEN** se procesan las vistas `VistasUGV::vistaEstructuraNavegacionControl` y `VistasUGV::vistaConexionesNavegacionControl` con Spec42
- **THEN** se visualizan en una misma vista tanto la parte de Control (`SistemaControl`) como la parte de Navegación (`SistemaNavegacion`), sus componentes internos, puertos e interconexiones sin errores ni advertencias

### Requirement: Frenado automático progresivo e inhabilitación manual desde Comunicaciones (RGEN-17)
El paquete `SubsistemaControl` SHALL dotar a `ModuloFrenadoSeguridad` de los atributos `frenadoProgresivoActivo : Boolean` y `frenadoAutomaticoHabilitado : Boolean` y del puerto `controlInhabilitacionManual : DataBusPort`, conectado mediante `entradaInhabilitacionFrenado` de `SistemaControl` con `salidaInhabilitacionFrenado : DataBusPort` de `SistemaComunicacionesEmbarcado`, y SHALL formalizar `ReqFrenadoAutomaticoColision` (`RGEN-17`) con su relación `satisfy`.

#### Scenario: Desactivación manual del frenado automático desde Comunicaciones frente a señuelos enemigos
- **WHEN** `PlataformaUGV` conecta `comunicaciones.salidaInhabilitacionFrenado` con `control.entradaInhabilitacionFrenado` y este se enlaza internamente con `moduloFrenadoSeguridad.controlInhabilitacionManual`
- **THEN** el operador puede inhabilitar manualmente la función de frenado automático progresivo ante riesgo de colisión (`RGEN-17`) para evitar el bloqueo del paso del UGV mediante falsos señuelos, quedando satisfecho formalmente `ReqFrenadoAutomaticoColision`

### Requirement: Descomposición interna de ComputadorAutonomia en tres subsistemas ROS 2 (ROPE-05, ROPE-06, RGEN-17)
El bloque `ComputadorAutonomia` en `Modelos/04_1_control.sysml` SHALL descomponerse internamente en tres partes interconectadas: `subsistemaFusionEstado : SubsistemaFusionEstado`, `subsistemaPlanificacionEvaluacion : SubsistemaPlanificacionEvaluacion` y `supervisorSeguridad : SupervisorSeguridad`, modelando el flujo interno del mapa unificado, la evaluación de colisión y la supervisión por *watchdog* con emisión de `ConsignaFrenado` ante pérdida de comunicación interna.

#### Scenario: Generación del mapa unificado y evaluación de colisión en ComputadorAutonomia
- **WHEN** `ComputadorAutonomia` recibe los datos sensoriales de obstáculos por `entradaObstaculos` y la odometría por `entradaOdometria`
- **THEN** `subsistemaFusionEstado` fusiona ambas entradas en `MapaEstadoUnificado` y lo entrega a `subsistemaPlanificacionEvaluacion`, el cual evalúa si existe riesgo de colisión y emite las consignas de navegación y frenado hacia `salidaConsigna`

#### Scenario: Supervisión de seguridad y frenado ante caída del computador principal
- **WHEN** `supervisorSeguridad` detecta la pérdida de comunicación interna (`LatidoSaludAutonomia`) desde `subsistemaPlanificacionEvaluacion`
- **THEN** `supervisorSeguridad` emite `ConsignaFrenado` hacia `salidaConsigna` (conectada con `moduloFrenadoSeguridad`) para detener el UGV de forma segura (`RGEN-17`)
