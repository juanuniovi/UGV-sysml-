package SubsistemaControl {
    doc /* Subsistema 4.1 de Control, Computador de Autonomia y Frenado de Seguridad (ROPE-05, RGEN-09, RGEN-17) */
    private import ScalarValues::*;
    private import TiposBase::*;
    private import SubsistemaNavegacion::*;
    private import SubsistemaIluminacion::*;

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

    // --- Modos de Operacion de Conduccion y Telemando (ROPE-01, ROPE-05) ---
    enum def ModoOperacionConduccion {
        doc /* Modos de operacion de conduccion del UGV: TELEOPERADO (mando remoto directo) o NAVEGACION (autonomia por waypoints) */
        enum TELEOPERADO;
        enum NAVEGACION;
    }

    enum def SubmodoNavegacionAutonoma {
        doc /* Submodos funcionales de navegacion autonoma comandables antes y durante la mision (ROPE-05) */
        enum PUNTOS_PASO;           // Navegacion por waypoints definidos antes o durante el recorrido
        enum PUNTO_DESTINO;         // Navegacion autonoma eficiente a punto de destino final
        enum REGRESO_ORIGEN;        // Retorno autonomo a punto de paso previo o vuelta a casa
        enum SEGUIMIENTO_FOLLOW_ME; // Seguimiento automatico de personas o de otros vehiculos
        enum SHUTTLE_LANZADERA;     // Lanzadera ciclica de ida y vuelta entre dos puntos
    }

    item def ComandoModoOperacion {
        doc /* Orden de conmutacion entre modo TELEOPERADO y NAVEGACION enviada desde las Estaciones de Control PMP/CPT (ROPE-01) */
        attribute modoObjetivo : ModoOperacionConduccion;
    }

    item def ComandoSubmodoAutonomia {
        doc /* Orden de activacion y conmutacion de submodo de navegacion autonoma recibido desde las Estaciones de Control (ROPE-05) */
        attribute submodoObjetivo : SubmodoNavegacionAutonoma;
        attribute habilitado : Boolean;
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
        doc /* Evalua si existe riesgo de colision a partir del mapa unificado, genera las consignas de conduccion y frenado, y modula la intensidad luminica gobernada por el modo activo (ROPE-01, ROPE-02, ROPE-05, ROPE-06, RGEN-17) */
        attribute consignasHabilitadas : Boolean;
        port entradaMapaUnificado : ~PuertoMapaEstadoUnificado;
        port busComunicaciones : DataBusPort;
        port entradaControlModo : DataBusPort;
        port salidaSalud : PuertoLatidoSalud;
        port salidaConsigna : PuertoConsignaAutonomia;
        port salidaIntensidad : PuertoIntensidadIluminacion;
    }

    part def SupervisorSeguridad {
        doc /* Bloque logico independiente segregado en software cuya unica mision es verificar que el computador principal no se ha colgado y emitir ConsignaFrenado si hay perdida de comunicacion interna (RGEN-17) */
        port entradaSalud : ~PuertoLatidoSalud;
        port salidaFrenadoWatchdog : PuertoConsignaAutonomia;
    }

    part def GobiernoControl {
        doc /* Gestiona el arbitraje entre Modo Teleoperado y Modo Navegacion, activando o desactivando las consignas de planificacion de la autonomia (ROPE-01) */
        attribute modoActivo : ModoOperacionConduccion;
        port busComunicaciones : DataBusPort;
        port salidaControlHabilitacion : DataBusPort;
    }

    // --- Definiciones de Partes Internas del Subsistema 4.1 de Control ---
    part def ComputadorAutonomia {
        doc /* Computador de navegacion autonoma en ROS 2 compuesto por Fusion y Estado, Planificacion y Evaluacion, y Supervisor de Seguridad (ROPE-05, RGEN-17) */
        attribute submodoActivo : SubmodoNavegacionAutonoma;

        part subsistemaFusionEstado : SubsistemaFusionEstado;
        part subsistemaPlanificacionEvaluacion : SubsistemaPlanificacionEvaluacion;
        part supervisorSeguridad : SupervisorSeguridad;

        port entradaObstaculos : ~PuertoMapaObstaculos;
        port entradaOdometria : ~PuertoOdometriaVIO;
        port salidaConsigna : PuertoConsignaAutonomia;
        port salidaIntensidad : PuertoIntensidadIluminacion;
        port busComunicaciones : DataBusPort;
        port entradaHabilitacionConsignas : DataBusPort;

        // Enlaces con los puertos de contorno de ComputadorAutonomia
        binding b_fusion_obstaculos bind entradaObstaculos = subsistemaFusionEstado.entradaObstaculos;
        binding b_fusion_odometria bind entradaOdometria = subsistemaFusionEstado.entradaOdometria;
        binding b_plan_comms bind busComunicaciones = subsistemaPlanificacionEvaluacion.busComunicaciones;
        binding b_plan_habilitacion bind entradaHabilitacionConsignas = subsistemaPlanificacionEvaluacion.entradaControlModo;
        binding b_plan_consigna bind subsistemaPlanificacionEvaluacion.salidaConsigna = salidaConsigna;
        binding b_plan_intensidad bind salidaIntensidad = subsistemaPlanificacionEvaluacion.salidaIntensidad;
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

    requirement def ReqModoTeleoperado {
        subject ctrl : SistemaControl;
        doc /* El UGV dispondra de un modo de operacion teleoperado gobernable de forma remota desde las estaciones de control (CPT en LOS y PMP en BLOS), durante el cual se desactivan las consignas de guiado y planificacion de la autonomia (ROPE-01). */
        require constraint { true }
    }

    requirement def ReqSubmodosNavegacionAutonoma {
        subject ctrl : SistemaControl;
        doc /* El modo AUTONOMO o de navegacion autonoma incorporara al menos cinco submodos habilitables y deshabilitables antes y durante la mision: navegacion por puntos de paso (waypoints), navegacion mediante punto de destino, regreso autonomo al origen o punto anterior (vuelta a casa), seguimiento automatico de personas o vehiculos (Follow-Me) y shuttle o lanzadera entre dos puntos (ROPE-05). */
        require constraint { true }
    }

    // --- Bloque Principal del Subsistema 4.1 de Control ---
    part def SistemaControl {
        doc /* Ensamblaje del computador de autonomia, gobierno de control y modulo de frenado de seguridad (ROPE-01, ROPE-05, RGEN-09, RGEN-17) */
        attribute modoDeteccionComandado : ModoDeteccionObstaculos;
        attribute modoOperacionComandado : ModoOperacionConduccion;
        attribute submodoAutonomiaComandado : SubmodoNavegacionAutonoma;

        // Computadores y modulos de control y actuacion segura
        part gobiernoControl : GobiernoControl;               // Gestion de transicion entre Modo Teleoperado y Navegacion (ROPE-01)
        part computadorAutonomia : ComputadorAutonomia;       // Waypoints georreferenciados, Follow-Me y mando de modo (ROPE-05, RGEN-09)
        part moduloFrenadoSeguridad : ModuloFrenadoSeguridad; // Frenado automatico progresivo con inhabilitacion manual (RGEN-17)

        // Puertos externos hacia la plataforma UGV y Comunicaciones
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort;
        port entradaInhabilitacionFrenado : DataBusPort;
        port driveByWireOutput : DataBusPort;
        port salidaIntensidad : PuertoIntensidadIluminacion;

        // Puertos de interfaz directa con el Subsistema 4.2 de Navegacion
        port entradaObstaculos : ~PuertoMapaObstaculos;
        port entradaOdometria : ~PuertoOdometriaVIO;

        // Conexiones internas con los puertos de contorno hacia SubsistemaNavegacion
        binding c_entrada_obstaculos bind entradaObstaculos = computadorAutonomia.entradaObstaculos;
        binding c_entrada_vio bind entradaOdometria = computadorAutonomia.entradaOdometria;
        binding b_ctrl_intensidad bind salidaIntensidad = computadorAutonomia.salidaIntensidad;

        // Conexion interna entre computador de autonomia y modulo de frenado de seguridad
        connection c_autonomia_frenado connect computadorAutonomia.salidaConsigna to moduloFrenadoSeguridad.entradaConsigna;

        // Conexiones con los buses externos de la plataforma (Comunicaciones/Equipos de Control y Drive-by-Wire)
        connection c_bus_comunicaciones connect dataBus to computadorAutonomia.busComunicaciones;
        connection c_bus_comms_modo connect dataBus to gobiernoControl.busComunicaciones;
        connection c_modo_habilitacion_consignas connect gobiernoControl.salidaControlHabilitacion to computadorAutonomia.entradaHabilitacionConsignas;
        connection c_inhabilitacion_frenado connect entradaInhabilitacionFrenado to moduloFrenadoSeguridad.controlInhabilitacionManual;
        connection c_frenado_dbw connect moduloFrenadoSeguridad.salidaActuacion to driveByWireOutput;

        // Accion local de generacion de consignas de control y frenado
        perform action generarControlAutonomo : GenerarControlAutonomo;

        // Satisfaccion formal de requisitos en SistemaControl
        satisfy ReqModoTeleoperado by gobiernoControl;
        satisfy ReqSubmodosNavegacionAutonoma by computadorAutonomia;
    }
}
