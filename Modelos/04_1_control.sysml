package SubsistemaControl {
    doc /* Subsistema 4.1 de Control, Computador de Autonomia y Frenado de Seguridad (ROPE-05, RGEN-09, RGEN-17) */
    private import ScalarValues::*;
    private import TiposBase::*;
    private import SubsistemaNavegacion::*;

    // --- Items de Consignas de Control, Estado Unificado y Supervision ROS 2 (ROPE-05, ROPE-06, RGEN-17) ---
    item def MapaEstadoUnificado {
        doc /* Mapa unificado de obstaculos y estado cinemático/odometria en ROS 2 */
    }

    item def LatidoSaludAutonomia {
        doc /* Senal de supervision de vida (heartbeat) de la planificacion ROS 2 hacia el supervisor de seguridad */
    }

    item def ConsignaFrenado {
        doc /* Consigna de frenado emitida por evaluacion de colision o por el supervisor de seguridad ante perdida de comunicacion interna (RGEN-17) */
    }

    item def ConsignaNavegacionAutonoma {
        doc /* Consignas de direccion, traccion y frenado generadas por el computador de autonomia (ROPE-05, ROPE-06) */
    }

    // --- Definiciones de Puertos de Control ---
    port def PuertoMapaEstadoUnificado {
        doc /* Puerto de entrega del mapa y estado unificado desde fusion hacia planificacion y evaluacion */
        out item mapaUnificado : MapaEstadoUnificado;
    }

    port def PuertoLatidoSalud {
        doc /* Puerto de latido y estado de comunicacion interna hacia el supervisor de seguridad */
        out item latido : LatidoSaludAutonomia;
    }

    port def PuertoConsignaAutonomia {
        doc /* Puerto de envio de consignas de navegacion autonoma y frenado hacia el modulo de frenado y actuacion */
        out item consigna : ConsignaNavegacionAutonoma;
        out item consignaFrenado : ConsignaFrenado;
    }

    // --- Subsistemas Internos del Computador de Autonomia en ROS 2 ---
    part def SubsistemaFusionEstado {
        doc /* Recibe los items de percepcion (LiDAR, Radar, Vision) y Odometria para generar el mapa y estado unificado en ROS 2 */
        port entradaObstaculos : ~PuertoMapaObstaculos;
        port entradaOdometria : ~PuertoOdometriaVIO;
        port salidaMapaUnificado : PuertoMapaEstadoUnificado;
    }

    part def SubsistemaPlanificacionEvaluacion {
        doc /* Evalua si existe riesgo de colision a partir del mapa unificado y genera las consignas de conduccion y frenado (ROPE-05, ROPE-06, RGEN-17) */
        port entradaMapaUnificado : ~PuertoMapaEstadoUnificado;
        port busComunicaciones : DataBusPort;
        port salidaSalud : PuertoLatidoSalud;
        port salidaConsigna : PuertoConsignaAutonomia;
    }

    part def SupervisorSeguridad {
        doc /* Bloque logico independiente segregado en software cuya unica mision es verificar que el computador principal no se ha colgado y emitir ConsignaFrenado si hay perdida de comunicacion interna (RGEN-17) */
        port entradaSalud : ~PuertoLatidoSalud;
        port salidaFrenadoWatchdog : PuertoConsignaAutonomia;
    }

    // --- Definiciones de Partes Internas del Subsistema 4.1 de Control ---
    part def ComputadorAutonomia {
        doc /* Computador de navegacion autonoma en ROS 2 compuesto por Fusion y Estado, Planificacion y Evaluacion, y Supervisor de Seguridad (ROPE-05, RGEN-17) */
        part subsistemaFusionEstado : SubsistemaFusionEstado;
        part subsistemaPlanificacionEvaluacion : SubsistemaPlanificacionEvaluacion;
        part supervisorSeguridad : SupervisorSeguridad;

        port entradaObstaculos : ~PuertoMapaObstaculos;
        port entradaOdometria : ~PuertoOdometriaVIO;
        port salidaConsigna : PuertoConsignaAutonomia;
        port busComunicaciones : DataBusPort;

        // Enlaces con los puertos de contorno de ComputadorAutonomia
        binding b_fusion_obstaculos bind entradaObstaculos = subsistemaFusionEstado.entradaObstaculos;
        binding b_fusion_odometria bind entradaOdometria = subsistemaFusionEstado.entradaOdometria;
        binding b_plan_comms bind busComunicaciones = subsistemaPlanificacionEvaluacion.busComunicaciones;
        binding b_plan_consigna bind subsistemaPlanificacionEvaluacion.salidaConsigna = salidaConsigna;
        binding b_watchdog_consigna bind supervisorSeguridad.salidaFrenadoWatchdog = salidaConsigna;

        // Conexiones internas entre los tres subsistemas ROS 2
        connection c_fusion_planificacion connect subsistemaFusionEstado.salidaMapaUnificado to subsistemaPlanificacionEvaluacion.entradaMapaUnificado;
        connection c_planificacion_watchdog connect subsistemaPlanificacionEvaluacion.salidaSalud to supervisorSeguridad.entradaSalud;
    }

    part def ModuloFrenadoSeguridad {
        doc /* Modulo de frenado automatico progresivo ante riesgo de colision con inhabilitacion manual frente a senuelos (RGEN-17) */
        attribute frenadoProgresivoActivo : Boolean;
        attribute frenadoAutomaticoHabilitado : Boolean;
        port entradaConsigna : ~PuertoConsignaAutonomia;
        port controlInhabilitacionManual : DataBusPort;
        port salidaActuacion : DataBusPort;
    }

    // --- Acciones de Control y Guiado Autonomo (ROPE-05, ROPE-06, RGEN-09, RGEN-17) ---
    action def GenerarControlAutonomo {
        doc /* Calcula trayectoria de evasion y genera consignas de control hacia drive-by-wire a partir del mapa de obstaculos y odometria (ROPE-05, ROPE-06, RGEN-17) */
        in obstaculos : MapaObstaculosDetectados;
        in posEstimada : Real;
        in modoActual : ModoDeteccionObstaculos;
        out consigna : ConsignaNavegacionAutonoma;

        action calcularTrayectoriaEvasion { out trayectoriaSegura : Boolean; }
        action generarConsignasControlLocal { out consignaLista : Boolean; }
        action supervisarFrenadoSeguridad { out actuacionSegura : Boolean; }
        first calcularTrayectoriaEvasion then generarConsignasControlLocal;
        first generarConsignasControlLocal then supervisarFrenadoSeguridad;
    }

    requirement def ReqFrenadoAutomaticoColision {
        subject ctrl : SistemaControl;
        doc /* El UGV debera tener una funcion de frenado automatico ante riesgo de colision ejecutada de forma progresiva siempre que sea posible, pudiendo ser inhabilitada manualmente para evitar bloqueos por falsos senuelos (RGEN-17). */
        require constraint { true }
    }

    // --- Bloque Principal del Subsistema 4.1 de Control ---
    part def SistemaControl {
        doc /* Ensamblaje del computador de autonomia, gestion de modo de deteccion y modulo de frenado de seguridad (ROPE-05, RGEN-09, RGEN-17) */
        attribute modoDeteccionComandado : ModoDeteccionObstaculos;

        // Computadores y modulos de control y actuacion segura
        part computadorAutonomia : ComputadorAutonomia;       // Waypoints georreferenciados, Follow-Me y mando de modo (ROPE-05, RGEN-09)
        part moduloFrenadoSeguridad : ModuloFrenadoSeguridad; // Frenado automatico progresivo con inhabilitacion manual (RGEN-17)

        // Puertos externos hacia la plataforma UGV y Comunicaciones
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort;
        port entradaInhabilitacionFrenado : DataBusPort;
        port driveByWireOutput : DataBusPort;

        // Puertos de interfaz directa con el Subsistema 4.2 de Navegacion
        port entradaObstaculos : ~PuertoMapaObstaculos;
        port entradaOdometria : ~PuertoOdometriaVIO;

        // Conexiones internas con los puertos de contorno hacia SubsistemaNavegacion
        binding c_entrada_obstaculos bind entradaObstaculos = computadorAutonomia.entradaObstaculos;
        binding c_entrada_vio bind entradaOdometria = computadorAutonomia.entradaOdometria;

        // Conexion interna entre computador de autonomia y modulo de frenado de seguridad
        connection c_autonomia_frenado connect computadorAutonomia.salidaConsigna to moduloFrenadoSeguridad.entradaConsigna;

        // Conexiones con los buses externos de la plataforma (Comunicaciones/Equipos de Control y Drive-by-Wire)
        connection c_bus_comunicaciones connect dataBus to computadorAutonomia.busComunicaciones;
        connection c_inhabilitacion_frenado connect entradaInhabilitacionFrenado to moduloFrenadoSeguridad.controlInhabilitacionManual;
        connection c_frenado_dbw connect moduloFrenadoSeguridad.salidaActuacion to driveByWireOutput;

        // Accion local de generacion de consignas de control y frenado
        perform action generarControlAutonomo : GenerarControlAutonomo;
    }
}
