package SubsistemaNavegacionControl {
    doc /* Sistema de Guiado, Navegacion y Control (GNC) y Suite de Sensores (ROPE, RNAV, RGEN-09) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // --- Modos de Deteccion de Obstaculos (RGEN-09) ---
    enum def ModoDeteccionObstaculos {
        doc /* Modos de deteccion del UGV: NORMAL (radiantes + no radiantes) o SIGILOSO (solo no radiantes) */
        enum NORMAL;
        enum SIGILOSO;
    }

    // --- Items de Informacion Sensorial y Control (RGEN-09) ---
    item def DatosLidar {
        doc /* Nube de puntos 3D y distancias procedentes de sensores LiDAR (tecnologia radiante, RGEN-09) */
    }

    item def DatosRadar {
        doc /* Detecciones de distancia y velocidad radial procedentes de sensores radar (tecnologia radiante, RGEN-09) */
    }

    item def DatosVisionComputador {
        doc /* Imagenes procesadas y deteccion pasiva mediante vision por computador (tecnologia no radiante, RGEN-09) */
    }

    item def MapaObstaculosDetectados {
        doc /* Obstaculos estaticos y dinamicos fusionados para la navegacion autonoma y evasion (RGEN-09, ROPE-06) */
    }

    item def ComandoModoDeteccion {
        doc /* Orden de conmutacion entre modo de deteccion NORMAL y SIGILOSO desde Equipos de Control (RGEN-09) */
        attribute modoObjetivo : ModoDeteccionObstaculos;
    }

    item def ControlEmisionRadiante {
        doc /* Senal de activacion o desactivacion de emision hacia sensores radiantes LiDAR y radar (RGEN-09) */
        attribute emitir : Boolean;
    }

    item def ConsignaNavegacionAutonoma {
        doc /* Consignas de direccion, traccion y frenado generadas por el computador de autonomia (ROPE-05, ROPE-06) */
    }

    // --- Definiciones de Puertos con Flujo de Items (RGEN-09) ---
    port def PuertoDatosLidar {
        doc /* Puerto de datos LiDAR y control de emision radiante */
        out item datos : DatosLidar;
        in item controlEmision : ControlEmisionRadiante;
    }

    port def PuertoDatosRadar {
        doc /* Puerto de datos radar y control de emision radiante */
        out item datos : DatosRadar;
        in item controlEmision : ControlEmisionRadiante;
    }

    port def PuertoDatosVision {
        doc /* Puerto de salida de percepcion pasiva de vision por computador */
        out item datos : DatosVisionComputador;
    }

    port def PuertoVideoOptico {
        doc /* Puerto de flujo de video optico o termico hacia el sistema de vision por computador */
        out item fotogramas : DatosVisionComputador;
    }

    port def PuertoOdometriaVIO {
        doc /* Puerto de estimacion de posicion inercial y visual en entorno GNSS denegado (RNAV-01) */
        out posEstimada : Real;
    }

    port def PuertoMapaObstaculos {
        doc /* Puerto de entrega del mapa de obstaculos estaticos y dinamicos al computador de autonomia */
        out item mapa : MapaObstaculosDetectados;
    }

    port def PuertoComandoModoDeteccion {
        doc /* Puerto para transmitir la orden de modo de deteccion NORMAL o SIGILOSO (RGEN-09) */
        out item comando : ComandoModoDeteccion;
    }

    port def PuertoConsignaAutonomia {
        doc /* Puerto de envio de consignas de navegacion autonoma hacia el modulo de frenado y actuacion */
        out item consigna : ConsignaNavegacionAutonoma;
    }

    // --- Definiciones de Partes Internas del Subsistema de Navegacion y Control ---
    part def SensorLidar {
        doc /* Sensor LiDAR 3D de tecnologia radiante, desactivable en modo de deteccion SIGILOSO (RGEN-09) */
        attribute emisionActiva : Boolean;
        port puertoLidar : PuertoDatosLidar;
        port powerInput : ElectricalPowerPort;
    }

    part def SensorRadar {
        doc /* Sensor radar de tecnologia radiante para deteccion de obstaculos, desactivable en modo SIGILOSO (RGEN-09) */
        attribute emisionActiva : Boolean;
        port puertoRadar : PuertoDatosRadar;
        port powerInput : ElectricalPowerPort;
    }

    part def SistemaVisionComputador {
        doc /* Sistema de vision por computador de tecnologia no radiante pasiva (RGEN-09) */
        port entradaOptica : ~PuertoVideoOptico;
        port entradaTermica : ~PuertoVideoOptico;
        port puertoVision : PuertoDatosVision;
        port powerInput : ElectricalPowerPort;
    }

    part def CamarasOpticas360 {
        doc /* Suite de camaras opticas de cobertura 360 grados (RGEN-20) */
        port puertoVideo : PuertoVideoOptico;
    }

    part def CamaraTermicaNocturna {
        doc /* Camara termica e infrarroja para vision nocturna (RGEN-22) */
        port puertoVideo : PuertoVideoOptico;
    }

    part def OdometriaVisualInercialVIO {
        doc /* Modulo de posicionamiento por odometria visual-inercial ante GNSS denegado (RNAV-01) */
        port puertoOdometria : PuertoOdometriaVIO;
    }

    part def ModuloDeteccionEvasion {
        doc /* Fusiona datos de LiDAR, radar y vision por computador y gestiona la emision radiante en modo NORMAL/SIGILOSO (RGEN-09, ROPE-06) */
        attribute modoDeteccionActual : ModoDeteccionObstaculos;
        port entradaLidar : ~PuertoDatosLidar;
        port entradaRadar : ~PuertoDatosRadar;
        port entradaVision : ~PuertoDatosVision;
        port entradaModoDeteccion : ~PuertoComandoModoDeteccion;
        port salidaObstaculos : PuertoMapaObstaculos;
    }

    part def ComputadorAutonomia {
        doc /* Computador de navegacion autonoma por waypoints y Follow-Me que recibe obstaculos y comandos de control (ROPE-05, RGEN-09) */
        port entradaObstaculos : ~PuertoMapaObstaculos;
        port entradaOdometria : ~PuertoOdometriaVIO;
        port salidaModoDeteccion : PuertoComandoModoDeteccion;
        port salidaConsigna : PuertoConsignaAutonomia;
        port busComunicaciones : DataBusPort;
    }

    part def ModuloFrenadoSeguridad {
        doc /* Modulo de frenado automatico de emergencia con override manual hacia drive-by-wire (RGEN-17) */
        port entradaConsigna : ~PuertoConsignaAutonomia;
        port salidaActuacion : DataBusPort;
    }

    // --- Acciones de Deteccion de Obstaculos y Navegacion Autonoma (RGEN-09) ---
    action def ConfigurarModoDeteccion {
        doc /* Activa o desactiva las tecnologias radiantes (LiDAR, radar) conmutando entre modo NORMAL y SIGILOSO (RGEN-09) */
        in comando : ComandoModoDeteccion;
        out modoActivo : ModoDeteccionObstaculos;
        out controlRadiante : ControlEmisionRadiante;

        action evaluarComandoModo { out modoSeleccionado : ModoDeteccionObstaculos; }
        action conmutarEmisionRadiante { out estadoRadiantes : Boolean; }
        first evaluarComandoModo then conmutarEmisionRadiante;
    }

    action def DetectarObstaculosNavegacion {
        doc /* Toma informacion de LiDAR, radar y vision por computador para detectar obstaculos estaticos y dinamicos (RGEN-09) */
        in datosLidar : DatosLidar[0..1];
        in datosRadar : DatosRadar[0..1];
        in datosVision : DatosVisionComputador;
        in modoActual : ModoDeteccionObstaculos;
        out obstaculos : MapaObstaculosDetectados;

        action adquirirPercepcionRadiante { out deteccionActiva : Boolean; }
        action adquirirVisionComputador { out deteccionPasiva : Boolean; }
        action fusionarObstaculosEstaticosDinamicos { out mapaActualizado : Boolean; }
        first adquirirPercepcionRadiante then adquirirVisionComputador;
        first adquirirVisionComputador then fusionarObstaculosEstaticosDinamicos;
    }

    action def NavegarAutonomamenteConDeteccion {
        doc /* Navegacion autonoma local alimentada por LiDAR, radar y vision por computador (RGEN-09, ROPE-05, ROPE-06) */
        in datosLidar : DatosLidar[0..1];
        in datosRadar : DatosRadar[0..1];
        in datosVision : DatosVisionComputador;
        in modoActual : ModoDeteccionObstaculos;
        out consigna : ConsignaNavegacionAutonoma;

        action detectarObstaculos : DetectarObstaculosNavegacion;
        action calcularTrayectoriaEvasion { out trayectoriaSegura : Boolean; }
        action generarConsignasControlLocal { out consignaLista : Boolean; }
        first detectarObstaculos then calcularTrayectoriaEvasion;
        first calcularTrayectoriaEvasion then generarConsignasControlLocal;
    }

    // --- Bloque Principal del Subsistema de Navegacion y Control ---
    part def SistemaNavegacionControl {
        // Estado local de modo de deteccion de obstaculos (RGEN-09)
        attribute modoDeteccionActual : ModoDeteccionObstaculos;
        attribute tecnologiasRadiantesActivas : Boolean;

        // Computadores y logica de navegacion
        part computadorAutonomia : ComputadorAutonomia;               // Waypoints georreferenciados y Follow-Me (ROPE-05)
        part moduloDeteccionEvasion : ModuloDeteccionEvasion;         // Detect & Avoid en tiempo real (ROPE-06, RGEN-09)
        part odometriaVisualInercialVIO : OdometriaVisualInercialVIO; // Posicionamiento en GNSS denegado (RNAV-01)
        part moduloFrenadoSeguridad : ModuloFrenadoSeguridad;         // Frenado automatico con override manual (RGEN-17)

        // Sensores de percepcion situacional y deteccion de obstaculos (RGEN-09)
        part camarasOpticas360 : CamarasOpticas360;                   // Cobertura visual 360 grados (RGEN-20)
        part camaraTermicaNocturna : CamaraTermicaNocturna;           // Deteccion termica e infrarroja (RGEN-22)
        part sensoresLidar : SensorLidar;                             // Tecnologia radiante desactivable en modo sigiloso (RGEN-09)
        part sensoresRadar : SensorRadar;                             // Tecnologia radiante desactivable en modo sigiloso (RGEN-09)
        part sistemaVisionComputador : SistemaVisionComputador;       // Tecnologia no radiante pasiva de vision por computador (RGEN-09)

        // Puertos externos del subsistema hacia la plataforma UGV
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort;
        port driveByWireOutput : DataBusPort;

        // Conexiones internas de sensores radiantes y no radiantes hacia deteccion de obstaculos (RGEN-09)
        connection c_lidar_deteccion connect sensoresLidar.puertoLidar to moduloDeteccionEvasion.entradaLidar;
        connection c_radar_deteccion connect sensoresRadar.puertoRadar to moduloDeteccionEvasion.entradaRadar;
        connection c_vision_deteccion connect sistemaVisionComputador.puertoVision to moduloDeteccionEvasion.entradaVision;
        connection c_camaras360_vision connect camarasOpticas360.puertoVideo to sistemaVisionComputador.entradaOptica;
        connection c_termica_vision connect camaraTermicaNocturna.puertoVideo to sistemaVisionComputador.entradaTermica;

        // Conexiones internas entre deteccion de obstaculos, computador de autonomia y odometria VIO
        connection c_obstaculos_autonomia connect moduloDeteccionEvasion.salidaObstaculos to computadorAutonomia.entradaObstaculos;
        connection c_modo_deteccion connect computadorAutonomia.salidaModoDeteccion to moduloDeteccionEvasion.entradaModoDeteccion;
        connection c_vio_autonomia connect odometriaVisualInercialVIO.puertoOdometria to computadorAutonomia.entradaOdometria;
        connection c_autonomia_frenado connect computadorAutonomia.salidaConsigna to moduloFrenadoSeguridad.entradaConsigna;

        // Conexiones con los puertos externos del subsistema (Comunicaciones/Equipos de Control y Drive-by-Wire)
        connection c_bus_comunicaciones connect dataBus to computadorAutonomia.busComunicaciones;
        connection c_frenado_dbw connect moduloFrenadoSeguridad.salidaActuacion to driveByWireOutput;

        // Acciones locales de navegacion y gestion de modo de deteccion (RGEN-09)
        perform action configurarModoDeteccion : ConfigurarModoDeteccion;
        perform action detectarObstaculos : DetectarObstaculosNavegacion;
        perform action navegarAutonomamente : NavegarAutonomamenteConDeteccion;
    }

    part subsistemaGNC : SistemaNavegacionControl;

    requirement def ReqNavegacionGNSSDenegado {
        subject gnc : SistemaNavegacionControl;
        doc /* Navegacion autonoma precisa ante inhibicion de senal satelital (RNAV-01). */
        require constraint { true }
    }

    requirement def ReqDeteccionObstaculosModoSigiloso {
        subject gnc : SistemaNavegacionControl;
        doc /* Deteccion de obstaculos estaticos y dinamicos mediante tecnologias radiantes (LiDAR, radar) y no radiantes (vision por computador), con activacion/desactivacion de tecnologias radiantes entre modo NORMAL y SIGILOSO desde los Equipos de Control en cualquier Modo de Operacion (RGEN-09). */
        require constraint { true }
    }

    satisfy requirement : ReqDeteccionObstaculosModoSigiloso by subsistemaGNC;
}
