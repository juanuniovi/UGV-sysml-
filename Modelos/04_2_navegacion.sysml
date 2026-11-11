package SubsistemaNavegacion {
    doc /* Subsistema 4.2 de Navegacion, Percepcion y Deteccion de Obstaculos (RNAV-01, ROPE-06, RGEN-09, RGEN-20, RGEN-22) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // --- Modos de Deteccion de Obstaculos (RGEN-09) ---
    enum def ModoDeteccionObstaculos {
        doc /* Modos de deteccion del UGV: NORMAL (radiantes + no radiantes) o SIGILOSO (solo no radiantes) */
        enum NORMAL;
        enum SIGILOSO;
    }

    // --- Items de Informacion Sensorial y Control de Emision (RGEN-09) ---
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
        doc /* Orden de conmutacion entre modo de deteccion NORMAL y SIGILOSO desde Equipos de Control via SubsistemaControl (RGEN-09) */
        attribute modoObjetivo : ModoDeteccionObstaculos;
    }

    item def ControlEmisionRadiante {
        doc /* Senal de activacion o desactivacion de emision hacia sensores radiantes LiDAR y radar (RGEN-09) */
        attribute emitir : Boolean;
    }

    item def DatosEstadoRodaje {
        doc /* Informacion en tiempo real del estado del tren de rodaje adquirida por transductores de contacto y dinamicos (RGEN-22) */
    }

    // --- Definiciones de Puertos con Flujo de Items (RGEN-09, RNAV-01) ---
    port def PuertoDatosLidar {
        doc /* Puerto de salida de datos LiDAR hacia fusion de obstaculos */
        out item datos : DatosLidar;
    }

    port def PuertoDatosRadar {
        doc /* Puerto de salida de datos radar hacia fusion de obstaculos */
        out item datos : DatosRadar;
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
        doc /* Puerto de entrega del mapa de obstaculos estaticos y dinamicos hacia el Subsistema de Control */
        out item mapa : MapaObstaculosDetectados;
    }

    port def PuertoComandoModoDeteccion {
        doc /* Puerto para transmitir la orden de modo de deteccion NORMAL o SIGILOSO (RGEN-09) */
        out item comando : ComandoModoDeteccion;
    }

    // --- Definiciones de Partes Internas del Subsistema 4.2 de Navegacion ---
    part def SensorLidar {
        doc /* Sensor LiDAR 3D de tecnologia radiante, desactivable en modo de deteccion SIGILOSO desde Comunicaciones (RGEN-09) */
        attribute emisionActiva : Boolean;
        port puertoLidar : PuertoDatosLidar;
        port controlModoDeteccion : DataBusPort;
        port powerInput : ElectricalPowerPort;
    }

    part def SensorRadar {
        doc /* Sensor radar de tecnologia radiante para deteccion de obstaculos, desactivable en modo SIGILOSO desde Comunicaciones (RGEN-09) */
        attribute emisionActiva : Boolean;
        port puertoRadar : PuertoDatosRadar;
        port controlModoDeteccion : DataBusPort;
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
        doc /* Suite de camaras opticas de cobertura 360 grados con vision de profundidad que permite el movimiento en 360 grados (RGEN-20, RGEN-22) */
        attribute visionProfundidad360 : Boolean;
        port puertoVideo : PuertoVideoOptico;
        port salidaVideoComms : DataBusPort;
    }

    part def CamaraLateralImplementos {
        doc /* Camara lateral independiente que proporciona informacion de los implementos y vision lateral del estado del UGV (RGEN-22) */
        port puertoVideo : PuertoVideoOptico;
        port salidaVideoComms : DataBusPort;
    }

    part def CamaraTermicaNocturna {
        doc /* Camara termica e infrarroja para vision nocturna que tiene como objetivo identificar puntos calientes (RGEN-22) */
        attribute identificaPuntosCalientes : Boolean;
        port puertoVideo : PuertoVideoOptico;
        port salidaVideoComms : DataBusPort;
    }

    part def TransductoresContactoDinamicos {
        doc /* Sensores fisicos de transductores de contacto y dinamicos que proporcionan informacion en tiempo real del estado del tren de rodaje (RGEN-22) */
        port salidaEstadoRodaje : DataBusPort;
    }

    part def SubsistemaCamaras {
        doc /* Subparte que agrupa todas las camaras y medios de video para vision por computador y teleoperacion desde Comunicaciones (RGEN-20, RGEN-22) */
        part camarasOpticas360 : CamarasOpticas360;                 // Cobertura 360 grados con vision de profundidad (RGEN-20, RGEN-22)
        part camaraLateralIzquierda : CamaraLateralImplementos;     // Vision lateral izquierda e implementos (RGEN-22)
        part camaraLateralDerecha : CamaraLateralImplementos;       // Vision lateral derecha e implementos (RGEN-22)
        part camaraTermicaNocturna : CamaraTermicaNocturna;         // Vision nocturna e identificacion de puntos calientes (RGEN-22)

        port salidaOptica : PuertoVideoOptico;
        port salidaTermica : PuertoVideoOptico;
        port salidaVideoTeleoperacion : DataBusPort;

        // Enlaces hacia el sistema de vision por computador (exterior a camaras)
        binding c_optica360_vision bind camarasOpticas360.puertoVideo = salidaOptica;
        binding c_lat_izq_vision bind camaraLateralIzquierda.puertoVideo = salidaOptica;
        binding c_lat_der_vision bind camaraLateralDerecha.puertoVideo = salidaOptica;
        binding c_termica_vision_out bind camaraTermicaNocturna.puertoVideo = salidaTermica;

        // Concentracion de toda la informacion de video hacia el puerto de teleoperacion para Comunicaciones (RGEN-22)
        connection c_video360_comms connect camarasOpticas360.salidaVideoComms to salidaVideoTeleoperacion;
        connection c_video_izq_comms connect camaraLateralIzquierda.salidaVideoComms to salidaVideoTeleoperacion;
        connection c_video_der_comms connect camaraLateralDerecha.salidaVideoComms to salidaVideoTeleoperacion;
        connection c_video_termica_comms connect camaraTermicaNocturna.salidaVideoComms to salidaVideoTeleoperacion;
    }

    part def SubsistemaSensores {
        doc /* Subparte que agrupa LiDAR, radar y los transductores de contacto y dinamicos del tren de rodaje (RGEN-09, RGEN-22) */
        part sensoresLidar : SensorLidar;                           // Tecnologia radiante desactivable en modo sigiloso (RGEN-09)
        part sensoresRadar : SensorRadar;                           // Tecnologia radiante desactivable en modo sigiloso (RGEN-09)
        part transductoresRodaje : TransductoresContactoDinamicos;  // Supervision en tiempo real del estado del tren de rodaje (RGEN-22)

        port salidaLidar : PuertoDatosLidar;
        port salidaRadar : PuertoDatosRadar;
        port controlModoDeteccion : DataBusPort;
        port salidaEstadoRodaje : DataBusPort;

        // Enlaces de salida de percepcion radiante y estado de rodaje
        binding c_lidar_out bind sensoresLidar.puertoLidar = salidaLidar;
        binding c_radar_out bind sensoresRadar.puertoRadar = salidaRadar;
        connection c_rodaje_out connect transductoresRodaje.salidaEstadoRodaje to salidaEstadoRodaje;

        // Distribucion de la orden de apagado/encendido en modo sigiloso a LiDAR y radar (RGEN-09)
        connection c_modo_lidar connect controlModoDeteccion to sensoresLidar.controlModoDeteccion;
        connection c_modo_radar connect controlModoDeteccion to sensoresRadar.controlModoDeteccion;
    }

    part def OdometriaVisualInercialVIO {
        doc /* Modulo de posicionamiento por odometria visual-inercial ante GNSS denegado (RNAV-01) */
        port puertoOdometria : PuertoOdometriaVIO;
    }

    part def ModuloDeteccionEvasion {
        doc /* Fusiona datos de LiDAR, radar y vision por computador para obtener el mapa de obstaculos (RGEN-09, ROPE-06) */
        attribute modoDeteccionActual : ModoDeteccionObstaculos;
        port entradaLidar : ~PuertoDatosLidar;
        port entradaRadar : ~PuertoDatosRadar;
        port entradaVision : ~PuertoDatosVision;
        port salidaObstaculos : PuertoMapaObstaculos;
    }

    // --- Acciones de Deteccion de Obstaculos y Gestion de Emision Radiante (RGEN-09) ---
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

    requirement def ReqNavegacionGNSSDenegado {
        subject nav : SistemaNavegacion;
        doc /* Navegacion autonoma precisa ante inhibicion de senal satelital (RNAV-01). */
        require constraint { true }
    }

    requirement def ReqDeteccionObstaculosModoSigiloso {
        subject nav : SistemaNavegacion;
        doc /* Deteccion de obstaculos estaticos y dinamicos mediante tecnologias radiantes (LiDAR, radar) y no radiantes (vision por computador), con activacion/desactivacion de tecnologias radiantes entre modo NORMAL y SIGILOSO desde los Equipos de Control en cualquier Modo de Operacion (RGEN-09). */
        require constraint { true }
    }

    requirement def ReqConcienciaSituacionalVisionSensores {
        subject nav : SistemaNavegacion;
        doc /* El UGV dispondra de medios de captacion de imagen y sensores que aporten conciencia situacional, faciliten la teleoperacion y el trabajo con implementos, incluyendo visualizacion de implementos y estado del tren de rodaje mediante transductores de contacto y dinamicos, imagenes independientes de cada lateral, vision de profundidad en 360 grados y camara termica que identifique puntos calientes (RGEN-22). */
        require constraint { true }
    }

    // --- Bloque Principal del Subsistema 4.2 de Navegacion ---
    part def SistemaNavegacion {
        doc /* Ensamblaje de las subpartes camaras y sensores, sistema de vision por computador, fusion de obstaculos y odometria VIO (RGEN-09, RNAV-01, ROPE-06, RGEN-20, RGEN-22) */
        attribute modoDeteccionActual : ModoDeteccionObstaculos;
        attribute tecnologiasRadiantesActivas : Boolean;

        // Subpartes de camaras y sensores (RGEN-09, RGEN-20, RGEN-22)
        part camaras : SubsistemaCamaras;                             // Agrupa camaras 360 con profundidad, 2 laterales y termica de puntos calientes (RGEN-20, RGEN-22)
        part sensores : SubsistemaSensores;                           // Agrupa LiDAR, radar y transductores de contacto y dinamicos de rodaje (RGEN-09, RGEN-22)

        // Sistema de vision por computador (fuera de camaras), fusion de obstaculos y posicionamiento inercial-visual
        part sistemaVisionComputador : SistemaVisionComputador;       // Tecnologia no radiante pasiva de vision por computador (RGEN-09)
        part moduloDeteccionEvasion : ModuloDeteccionEvasion;         // Detect & Avoid en tiempo real (ROPE-06, RGEN-09)
        part odometriaVisualInercialVIO : OdometriaVisualInercialVIO; // Posicionamiento en GNSS denegado (RNAV-01)

        // Puertos externos del subsistema hacia la plataforma UGV, Comunicaciones y el Subsistema 4.1 de Control
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port salidaObstaculos : PuertoMapaObstaculos;
        port salidaOdometria : PuertoOdometriaVIO;
        port entradaModoDeteccion : DataBusPort;
        port salidaVideoTeleoperacion : DataBusPort;
        port salidaEstadoRodaje : DataBusPort;

        // Conexiones internas desde sensores y vision por computador hacia deteccion de obstaculos (RGEN-09, RGEN-22)
        connection c_lidar_deteccion connect sensores.salidaLidar to moduloDeteccionEvasion.entradaLidar;
        connection c_radar_deteccion connect sensores.salidaRadar to moduloDeteccionEvasion.entradaRadar;
        connection c_vision_deteccion connect sistemaVisionComputador.puertoVision to moduloDeteccionEvasion.entradaVision;
        connection c_camaras_optica_vision connect camaras.salidaOptica to sistemaVisionComputador.entradaOptica;
        connection c_camaras_termica_vision connect camaras.salidaTermica to sistemaVisionComputador.entradaTermica;

        // Conexion de apagado/encendido de LiDAR y radar hacia la subparte sensores (RGEN-09)
        connection c_modo_sensores connect entradaModoDeteccion to sensores.controlModoDeteccion;

        // Conexiones internas de video de camaras y estado de rodaje hacia los puertos de contorno para Comunicaciones (RGEN-22)
        connection c_video_teleop_interno connect camaras.salidaVideoTeleoperacion to salidaVideoTeleoperacion;
        connection c_estado_rodaje_interno connect sensores.salidaEstadoRodaje to salidaEstadoRodaje;

        // Conexiones internas hacia los puertos de contorno que enlazan con SubsistemaControl
        binding c_salida_obstaculos_interno bind moduloDeteccionEvasion.salidaObstaculos = salidaObstaculos;
        binding c_salida_vio_interno bind odometriaVisualInercialVIO.puertoOdometria = salidaOdometria;

        // Acciones locales de deteccion y gestion de modo de deteccion (RGEN-09)
        perform action configurarModoDeteccion : ConfigurarModoDeteccion;
        perform action detectarObstaculos : DetectarObstaculosNavegacion;
    }
}
