# Design: Control de Modo de Operación y Gestión de Consignas (ROPE-01)

## Context
En `Modelos/04_1_control.sysml`, `ComputadorAutonomia` aloja el `SubsistemaPlanificacionEvaluacion`, el cual calcula y emite `ConsignaNavegacionAutonoma` directamente hacia `ModuloFrenadoSeguridad` y los actuadores mecánicos (`driveByWireOutput`). Para implementar el requisito contractual `ROPE-01`, el sistema debe soportar la transición a modo `TELEOPERADO`, desactivando la emisión de consignas de la autonomía para otorgar control exclusivo a la conducción remota, y reactivándolas al conmutar a `NAVEGACION`. Véase `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**
- Definir `part def ControlModoOperacion` y su instancia `part controlModoOperacion : ControlModoOperacion;` en `SistemaControl`.
- Modelar los tipos de soporte: `enum def ModoOperacionConduccion { enum TELEOPERADO; enum NAVEGACION; }` y el ítem `item def ComandoModoOperacion`.
- Establecer el enlace de control entre `ControlModoOperacion` y `ComputadorAutonomia` (específicamente hacia `SubsistemaPlanificacionEvaluacion`), dotándolo del atributo/estado `consignasHabilitadas : Boolean` para desactivar o activar las consignas de guiado autónomo.
- Formalizar `ReqModoTeleoperado` (`ROPE-01`) en `SubsistemaControl` y establecer su relación formal `satisfy`.

**Non-Goals:**
- No alterar las conexiones externas de plataforma en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`), dado que las órdenes de modo circulan por el bus digital existente `dataBus` conectado con `comunicaciones`.
- No eliminar ni relajar la función de frenado automático progresivo ante colisión (`RGEN-17`), que permanece activa en ambos modos como envolvente de seguridad.
- No modificar los archivos de Navegación (`04_2_navegacion.sysml`).

## Decisions

### Decisión 1: Ubicación de `ControlModoOperacion` en `SistemaControl`
- **Elección**: Situar `ControlModoOperacion` como parte de primer nivel dentro de `part def SistemaControl`.
- **Justificación**: Cumple directamente la instrucción técnica del usuario ("crear una parte llamada control de modo de operacion en la propia parte de control") y respeta el principio de segregación: el árbitro de modo reside en el sistema de control antes de los actuadores, recibiendo las órdenes de las estaciones de control PMP/CPT vía `dataBus`.

### Decisión 2: Mecanismo de inhibición de consignas en `SubsistemaPlanificacionEvaluacion`
- **Elección**: Incorporar en `SubsistemaPlanificacionEvaluacion` el atributo `consignasHabilitadas : Boolean` y el puerto de control de modo `entradaControlModo : DataBusPort`.
- **Justificación**: En la arquitectura ROS 2 / Nav2, el gestor de ciclo de vida (`lifecycle manager`) o el conmutador de nodos (`twist_mux`) activa o desactiva la publicación de comandos de velocidad del planificador. Representar esto como un atributo de habilitación y un puerto de control gobernado por `ControlModoOperacion` es idiomático en SysML v2 y semánticamente preciso.

### Decisión 3: Formalización del requisito `ROPE-01`
- **Elección**: Definir `requirement def ReqModoTeleoperado` con `subject ctrl : SistemaControl` y satisfacción mediante `satisfy requirement : ReqModoTeleoperado by controlModoOperacion;`.
- **Justificación**: Proporciona trazabilidad completa con el pliego contractual y se alinea con la máquina de estados de `Modelos/10_comportamiento.sysml` (`state ModoTeleoperado`).

## Risks / Trade-offs

- **[Riesgo] Competencia de señales en `ComputadorAutonomia`** → **Mitigación**: Cuando `consignasHabilitadas == false`, `SubsistemaPlanificacionEvaluacion` entra en estado inactivo/standby y no emite consignas activas hacia `ModuloFrenadoSeguridad`.
- **[Riesgo] Compatibilidad con puertos existentes de `SistemaControl`** → **Mitigación**: Se preservan los puertos de contorno `dataBus`, `driveByWireOutput`, `entradaObstaculos` y `entradaOdometria`.
