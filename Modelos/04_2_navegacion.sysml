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

    // --- Bloque Principal del Subsistema 4.2 de Navegacion ---
    part def SistemaNavegacion {
        doc /* Ensamblaje de sensores radiantes, no radiantes, fusion de obstaculos y odometria VIO (RGEN-09, RNAV-01, ROPE-06) */
        attribute modoDeteccionActual : ModoDeteccionObstaculos;
        attribute tecnologiasRadiantesActivas : Boolean;

        // Modulos de fusion de obstaculos y posicionamiento inercial-visual
        part moduloDeteccionEvasion : ModuloDeteccionEvasion;         // Detect & Avoid en tiempo real (ROPE-06, RGEN-09)
        part odometriaVisualInercialVIO : OdometriaVisualInercialVIO; // Posicionamiento en GNSS denegado (RNAV-01)

        // Sensores de percepcion situacional y deteccion de obstaculos (RGEN-09)
        part camarasOpticas360 : CamarasOpticas360;                   // Cobertura visual 360 grados (RGEN-20)
        part camaraTermicaNocturna : CamaraTermicaNocturna;           // Deteccion termica e infrarroja (RGEN-22)
        part sensoresLidar : SensorLidar;                             // Tecnologia radiante desactivable en modo sigiloso (RGEN-09)
        part sensoresRadar : SensorRadar;                             // Tecnologia radiante desactivable en modo sigiloso (RGEN-09)
        part sistemaVisionComputador : SistemaVisionComputador;       // Tecnologia no radiante pasiva de vision por computador (RGEN-09)

        // Puertos externos del subsistema hacia la plataforma UGV, Comunicaciones y el Subsistema 4.1 de Control
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port salidaObstaculos : PuertoMapaObstaculos;
        port salidaOdometria : PuertoOdometriaVIO;
        port entradaModoDeteccion : DataBusPort;

        // Conexiones internas de sensores radiantes y no radiantes hacia deteccion de obstaculos (RGEN-09)
        connection c_lidar_deteccion connect sensoresLidar.puertoLidar to moduloDeteccionEvasion.entradaLidar;
        connection c_radar_deteccion connect sensoresRadar.puertoRadar to moduloDeteccionEvasion.entradaRadar;
        connection c_vision_deteccion connect sistemaVisionComputador.puertoVision to moduloDeteccionEvasion.entradaVision;
        connection c_camaras360_vision connect camarasOpticas360.puertoVideo to sistemaVisionComputador.entradaOptica;
        connection c_termica_vision connect camaraTermicaNocturna.puertoVideo to sistemaVisionComputador.entradaTermica;

        // Conexiones de apagado/encendido de LiDAR y radar desde el puerto de modo de deteccion (RGEN-09)
        connection c_modo_lidar connect entradaModoDeteccion to sensoresLidar.controlModoDeteccion;
        connection c_modo_radar connect entradaModoDeteccion to sensoresRadar.controlModoDeteccion;

        // Conexiones internas hacia los puertos de contorno que enlazan con SubsistemaControl
        binding c_salida_obstaculos_interno bind moduloDeteccionEvasion.salidaObstaculos = salidaObstaculos;
        binding c_salida_vio_interno bind odometriaVisualInercialVIO.puertoOdometria = salidaOdometria;

        // Acciones locales de deteccion y gestion de modo de deteccion (RGEN-09)
        perform action configurarModoDeteccion : ConfigurarModoDeteccion;
        perform action detectarObstaculos : DetectarObstaculosNavegacion;
    }
}
