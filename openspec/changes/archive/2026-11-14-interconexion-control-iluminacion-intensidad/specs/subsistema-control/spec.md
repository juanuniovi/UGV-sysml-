# Spec Delta: subsistema-control

## MODIFIED Requirements

### Requirement: Puertos de contorno e interconexiones internas de SistemaControl (ROPE-05, RGEN-17)
El bloque `SistemaControl` SHALL exponer puertos de montaje y alimentación (`chassisMount`, `powerInput`), puertos de bus de plataforma (`dataBus`, `driveByWireOutput`), puertos de interfaz de entrada desde el Subsistema de Navegación (`entradaObstaculos : ~PuertoMapaObstaculos`, `entradaOdometria : ~PuertoOdometriaVIO`), y el puerto de salida de iluminación (`salidaIntensidad : PuertoIntensidadIluminacion`), enlazándolos con `computadorAutonomia` y `moduloFrenadoSeguridad` sin enviar la orden de modo de detección desde `computadorAutonomia`.

#### Scenario: Flujo interno de consignas en SistemaControl
- **WHEN** `SistemaControl` recibe un mapa de obstáculos por `entradaObstaculos`, odometría por `entradaOdometria` y órdenes de misión desde `dataBus`
- **THEN** `computadorAutonomia` calcula y envía las consignas de conducción (`PuertoConsignaAutonomia`) a `moduloFrenadoSeguridad`, el cual las supervisa y entrega en `driveByWireOutput`, y comanda el nivel de iluminación por `salidaIntensidad`

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

### Requirement: Vista conjunta de Control y Navegación en VistasUGV
El paquete `VistasUGV` en `Modelos/11_vistas.sysml` SHALL representar conjuntamente `SubsistemaControl`, `SubsistemaNavegacion` y `SubsistemaIluminacion` en las vistas `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView`, incluyendo la parte `SistemaUGV::PlataformaUGV::iluminacion` y su enlace de datos de control `SistemaUGV::PlataformaUGV::c_control_iluminacion` conectando `control.salidaIntensidad` con `iluminacion.entradaIntensidad` para supervisión del soporte lumínico perimetral y su gobierno en teleoperación (`ROPE-02`, `RGEN-20`).

#### Scenario: Renderizado conjunto de Control y Navegación en Spec42
- **WHEN** se procesan las vistas `VistasUGV::vistaEstructuraNavegacionControl` y `VistasUGV::vistaConexionesNavegacionControl` con Spec42
- **THEN** se visualizan en una misma vista la parte de Control (`control`), Navegación (`navegacion`), Iluminación (`iluminacion`), Comunicaciones (`comunicaciones`) y sus conexiones de bus, vídeo e iluminación (`c_control_iluminacion`) sin errores ni advertencias
