# subsistema-control Specification

## Purpose

Especifica la arquitectura interna, bloques tipados, puertos, conexiones, acciones y vistas del subsistema **4.1 Control** (`SubsistemaControl` en `Modelos/04_1_control.sysml`), encargado del computador de autonomía/guiado (`ComputadorAutonomia`), la gestión de comandos de modo de detección (`NORMAL` / `SIGILOSO`, `RGEN-09`) recibidos desde los Equipos de Control y el frenado automático de seguridad (`ModuloFrenadoSeguridad`, `RGEN-17`) hacia el tren de rodaje (`driveByWireOutput`).

## Requirements

### Requirement: Separación estructural del Subsistema 4.1 de Control (ROPE-05, RGEN-09, RGEN-17)
El modelo SHALL definir en `Modelos/04_1_control.sysml` el paquete `SubsistemaControl` con el bloque principal `SistemaControl` (y la instancia `subsistemaControl : SistemaControl`), integrando las partes tipadas `computadorAutonomia : ComputadorAutonomia`, `gobiernoControl : GobiernoControl` y `moduloFrenadoSeguridad : ModuloFrenadoSeguridad`.

#### Scenario: Composición interna de SistemaControl
- **WHEN** se inspecciona la estructura de `SubsistemaControl::SistemaControl`
- **THEN** contiene los bloques de control y actuación segura (`computadorAutonomia`, `gobiernoControl` y `moduloFrenadoSeguridad`), sin acoplar directamente los sensores físicos de navegación

### Requirement: Modo de operación teleoperado e inhibición de consignas de autonomía (ROPE-01)
El subsistema `SistemaControl` SHALL incorporar la parte `gobiernoControl : GobiernoControl` encargada de gestionar los modos de conducción (`TELEOPERADO` y `NAVEGACION`), recibiendo la orden de modo desde las estaciones de control PMP/CPT vía `dataBus` y gobernando la activación/desactivación de las consignas de guiado del computador de autonomía según el requisito contractual `ROPE-01`.

#### Scenario: Transición a Modo Teleoperado con desactivación de consignas de autonomía
- **WHEN** `gobiernoControl` recibe a través de `dataBus` la consigna de conmutación al modo `TELEOPERADO`
- **THEN** desactiva la emisión de consignas de guiado en `subsistemaPlanificacionEvaluacion` para otorgar el mando exclusivo a la teleoperación manual

#### Scenario: Transición a Modo Navegación con activación de consignas de autonomía
- **WHEN** `gobiernoControl` recibe a través de `dataBus` la orden de modo `NAVEGACION`
- **THEN** activa la generación de consignas de conducción y frenado en `subsistemaPlanificacionEvaluacion` hacia los actuadores

### Requirement: Puertos de contorno e interconexiones internas de SistemaControl (ROPE-05, RGEN-17)
El bloque `SistemaControl` SHALL exponer puertos de montaje y alimentación (`chassisMount`, `powerInput`), puertos de bus de plataforma (`dataBus`, `driveByWireOutput`), puertos de interfaz de entrada desde el Subsistema de Navegación (`entradaObstaculos : ~PuertoMapaObstaculos`, `entradaOdometria : ~PuertoOdometriaVIO`), y el puerto de salida de iluminación (`salidaIntensidad : PuertoIntensidadIluminacion`), enlazándolos con `computadorAutonomia` y `moduloFrenadoSeguridad` sin enviar la orden de modo de detección desde `computadorAutonomia`.

#### Scenario: Flujo interno de consignas en SistemaControl
- **WHEN** `SistemaControl` recibe un mapa de obstáculos por `entradaObstaculos`, odometría por `entradaOdometria` y órdenes de misión desde `dataBus`
- **THEN** `computadorAutonomia` calcula y envía las consignas de conducción (`PuertoConsignaAutonomia`) a `moduloFrenadoSeguridad`, el cual las supervisa y entrega en `driveByWireOutput`, y comanda el nivel de iluminación por `salidaIntensidad`

### Requirement: Vista conjunta de Control y Navegación en VistasUGV
El paquete `VistasUGV` en `Modelos/11_vistas.sysml` SHALL representar conjuntamente `SubsistemaControl`, `SubsistemaNavegacion` y `SubsistemaIluminacion` en las vistas `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView`, incluyendo la parte `SistemaUGV::PlataformaUGV::iluminacion` y su enlace de datos de control `SistemaUGV::PlataformaUGV::c_control_iluminacion` conectando `control.salidaIntensidad` con `iluminacion.entradaIntensidad` para supervisión del soporte lumínico perimetral y su gobierno en teleoperación (`ROPE-02`, `RGEN-20`).

#### Scenario: Renderizado conjunto de Control y Navegación en Spec42
- **WHEN** se procesan las vistas `VistasUGV::vistaEstructuraNavegacionControl` y `VistasUGV::vistaConexionesNavegacionControl` con Spec42
- **THEN** se visualizan en una misma vista la parte de Control (`control`), Navegación (`navegacion`), Iluminación (`iluminacion`), Comunicaciones (`comunicaciones`) y sus conexiones de bus, vídeo e iluminación (`c_control_iluminacion`) sin errores ni advertencias

### Requirement: Frenado automático progresivo e inhabilitación manual desde Comunicaciones (RGEN-17)
El paquete `SubsistemaControl` SHALL dotar a `ModuloFrenadoSeguridad` de los atributos `frenadoProgresivoActivo : Boolean` y `frenadoAutomaticoHabilitado : Boolean` y del puerto `controlInhabilitacionManual : DataBusPort`, conectado mediante `entradaInhabilitacionFrenado` de `SistemaControl` con `salidaInhabilitacionFrenado : DataBusPort` de `SistemaComunicacionesEmbarcado`, y SHALL formalizar `ReqFrenadoAutomaticoColision` (`RGEN-17`) con su relación `satisfy`.

#### Scenario: Desactivación manual del frenado automático desde Comunicaciones frente a señuelos enemigos
- **WHEN** `PlataformaUGV` conecta `comunicaciones.salidaInhabilitacionFrenado` con `control.entradaInhabilitacionFrenado` y este se enlaza internamente con `moduloFrenadoSeguridad.controlInhabilitacionManual`
- **THEN** el operador puede inhabilitar manualmente la función de frenado automático progresivo ante riesgo de colisión (`RGEN-17`) para evitar el bloqueo del paso del UGV mediante falsos señuelos, quedando satisfecho formalmente `ReqFrenadoAutomaticoColision`

### Requirement: Descomposición interna de ComputadorAutonomia en tres subsistemas ROS 2 (ROPE-05, ROPE-06, RGEN-17)
El bloque `ComputadorAutonomia` en `Modelos/04_1_control.sysml` SHALL descomponerse internamente en tres partes interconectadas: `subsistemaFusionEstado : SubsistemaFusionEstado`, `subsistemaPlanificacionEvaluacion : SubsistemaPlanificacionEvaluacion` y `supervisorSeguridad : SupervisorSeguridad`, incorporando en `subsistemaPlanificacionEvaluacion` y en `ComputadorAutonomia` el puerto `salidaIntensidad : PuertoIntensidadIluminacion` para emitir el ítem `Intensidad`, gobernando su modulación autónoma en modo `NAVEGACION` o canalizando la consigna de luces del telemando recibida por `busComunicaciones` cuando `gobiernoControl` señale modo `TELEOPERADO` ([ROPE-01], [ROPE-02]).

#### Scenario: Generación del mapa unificado y evaluación de colisión en ComputadorAutonomia
- **WHEN** `ComputadorAutonomia` recibe los datos sensoriales de obstáculos por `entradaObstaculos` y la odometría por `entradaOdometria`
- **THEN** `subsistemaFusionEstado` fusiona ambas entradas en `MapaEstadoUnificado` y lo entrega a `subsistemaPlanificacionEvaluacion`, el cual evalúa si existe riesgo de colisión y emite las consignas de navegación y frenado hacia `salidaConsigna`

#### Scenario: Supervisión de seguridad y frenado ante caída del computador principal
- **WHEN** `supervisorSeguridad` detecta la pérdida de comunicación interna (`LatidoSaludAutonomia`) desde `subsistemaPlanificacionEvaluacion`
- **THEN** `supervisorSeguridad` emite `ConsignaFrenado` hacia `salidaConsigna` (conectada con `moduloFrenadoSeguridad`) para detener el UGV de forma segura (`RGEN-17`)

#### Scenario: Control y modulación de intensidad de iluminación por modo de operación
- **WHEN** `subsistemaPlanificacionEvaluacion` gestiona la salida `salidaIntensidad`
- **THEN** en modo `NAVEGACION` modula la intensidad lumínica según requerimientos de visión de los sensores, mientras que en modo `TELEOPERADO` adopta la consigna de intensidad comandada por el telemando desde las estaciones de control
