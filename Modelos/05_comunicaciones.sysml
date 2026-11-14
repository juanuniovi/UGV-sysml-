package SubsistemaComunicaciones {
    doc /* Sistema de comunicaciones tacticas embarcadas (RCOM-01..03, RSW-06) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // =========================================================================
    // 1. Items de Datos de Flujo Tipados
    // =========================================================================
    item def ComandoTelemandoLOS {
        doc /* Consignas de telemando directo procedentes de la Consola CPT (joysticks de direccion y velocidad) */
    }

    item def TelemetriaVideoLOS {
        doc /* Retransmision de video de conduccion en tiempo real y estado basico del UGV hacia la CPT */
    }

    item def ComandoControlBLOS {
        doc /* Ordenes C2 estructuradas STANAG 4586 de navegacion autonoma y waypoints procedentes del PMP */
    }

    item def TrazaTacticaBMS {
        doc /* Mensajeria Blue Force Tracking y estado de combate hacia la malla de batallón/brigada BMS-ET */
    }

    item def HeartbeatEnlace {
        doc /* Trama periodica de sincronizacion (200 ms) para supervision y disparo de failsafe RGEN-17 */
    }

    // =========================================================================
    // 2. Definiciones de Partes Transceptoras, Criptograficas y de Gestion
    // =========================================================================
    part def RadioEnlaceTacticoLOS {
        doc /* Transceptor de radiofrecuencia tactico para telemando en linea de vista (RCOM-01) */
        
        // Atributos cuantitativos de enlace
        attribute latenciaMaximaMs : Real = 100.0; // Latencia ultrabaja para control reactivo
        attribute alcanceNominalKm : Real = 1.5;   // Alcance visual directo con la consola de mano
        attribute frecuenciaGhz : Real = 2.4;      // Banda tactica de operacion directa

        // Puertos internos del modulo
        port rfPort : RFPort;
        port dataBusInternal : DataBusPort;
    }

    part def RadioEnlaceTacticoBLOS {
        doc /* Transceptor MANET tactico para enlace fuera de linea de vista y rele aereo con UAV (RCOM-02) */

        attribute alcanceNominalKm : Real = 5.0;   // Alcance nominal para operacion remota con PMP
        attribute latenciaMaximaMs : Real = 150.0; // Latencia admisible para mando C2
        attribute modulacionSDR : Boolean = true;  // Radio definida por software tactica

        port rfPort : RFPort;
        port dataBusInternal : DataBusPort;
    }

    part def RadioTacticaMilitarCNR {
        doc /* Radio de combate militar VHF (PR4G / SDR ESSOR) para C4I/BMS y canal de respaldo extremo */

        attribute bandaOperacionVhfMhz : Real = 30.0; // Banda VHF militar (30-88 MHz)
        attribute saltoFrecuenciaActivo : Boolean = true; // Salto agil FHSS anti-perturbacion

        port rfPort : RFPort;
        port dataBusInternal : DataBusPort;
    }

    part def ModuloCifradoCOMSEC {
        doc /* Criptoprocesador hardware para cifrado militar extremo a extremo y anti-jamming (RCOM-03) */

        attribute algoritmoCifrado : String = "AES-256-GCM";
        attribute cifradoHardwareActivo : Boolean = true;

        port puertoEntradaDatos : DataBusPort;
        port puertoDatosLOS : DataBusPort;
        port puertoDatosBLOS : DataBusPort;
        port puertoDatosCNR : DataBusPort;
    }

    part def GestorRedundanciaYQoS {
        doc /* Planificador de colas de calidad de servicio (QoS) y priorizacion estricta (RSW-06) */

        attribute prioridadTelemando : Integer = 1; // Prioridad maxima: joysticks y freno
        attribute prioridadVideo : Integer = 4;     // Prioridad degenerable: video 360
        attribute tiempoHisteresisRetornoS : Real = 3.0; // Estabilidad requerida para retornar de canal

        port puertoBusEntrada : DataBusPort;
        port puertoVideoEntrada : DataBusPort;
        port puertoSalidaCifrado : DataBusPort;
        port puertoControlEmisiones : DataBusPort;
    }

    part def SupervisorEnlaceWatchdog {
        doc /* Temporizador de latido de enlace para disparo de parada de emergencia failsafe (RGEN-17) */

        attribute periodoHeartbeatMs : Real = 200.0;  // Frecuencia de emision de latido (5 Hz)
        attribute timeoutFailsafeMs : Real = 1000.0;  // Umbral de disparo de frenado seguro (1.0 s)

        port puertoBusMonitoreo : DataBusPort;
        port puertoDisparoFrenado : DataBusPort;
    }

    part def SistemaAntenasEmbarcado {
        doc /* Conjunto de antenas omnidireccionales en techo de barcaza resistentes a vadeo (RLT1-10) */

        attribute rugerizacion : String = "MIL-STD-810H";
        attribute estanqueidadVadeoM : Real = 0.75;

        port puertoEntradaLOS : RFPort;
        port puertoEntradaBLOS : RFPort;
        port puertoEntradaCNR : RFPort;
        port puertoExteriorLOS : RFPort;
        port puertoExteriorBLOS : RFPort;
        port puertoExteriorCNR : RFPort;
    }

    // =========================================================================
    // 3. Requisitos Formales del Pliego Oficial (RCOM-01..03, RSW-06)
    // =========================================================================
    requirement def ReqEnlaceTacticoLOS {
        doc /* El UGV debe disponer de un enlace de radiofrecuencia tactico en linea de vista (LOS)
               con la Consola Portable de Operador (CPT) para telemando con latencia <= 100 ms (RCOM-01). */
        require constraint { true }
    }

    requirement def ReqEnlaceTacticoBLOS {
        doc /* El UGV debe disponer de un enlace de radiofrecuencia tactico fuera de linea de vista (BLOS)
               para control a larga distancia desde el Puesto de Mando (PMP) y compatibilidad de rele
               aereo a traves del transpondedor del UAV cenital embarcado (RCOM-02). */
        require constraint { true }
    }

    requirement def ReqSeguridadComunicacionesCOMSEC {
        doc /* El subsistema de comunicaciones debe implementar cifrado hardware militar punto a punto
               (COMSEC), proteccion anti-jamming y salto agil de frecuencia FHSS (RCOM-03). */
        require constraint { true }
    }

    requirement def ReqProtocolosTacticosYQoS {
        doc /* Arquitectura de transporte y protocolos tacticos con calidad de servicio (QoS) estricta
               que priorice de forma no bloqueante las ordenes criticas de guiado y frenado frente a los
               flujos multimedia pesados de video (RSW-06). */
        require constraint { true }
    }

    // =========================================================================
    // 4. Bloque Principal del Subsistema de Comunicaciones
    // =========================================================================
    part def SistemaComunicacionesEmbarcado {
        doc /* Subsistema de comunicaciones embarcado del UGV con redundancia, QoS y topologia IBD completa */

        // Subpartes especificas tipadas del subsistema
        part radioEnlaceTacticoLOS : RadioEnlaceTacticoLOS;
        part radioEnlaceTacticoBLOS : RadioEnlaceTacticoBLOS;
        part radioTacticaMilitarCNR : RadioTacticaMilitarCNR;
        part moduloCifradoCOMSEC : ModuloCifradoCOMSEC;
        part gestorRedundanciaYQoS : GestorRedundanciaYQoS;
        part supervisorEnlaceWatchdog : SupervisorEnlaceWatchdog;
        part sistemaAntenas : SistemaAntenasEmbarcado;

        // Puertos externos de contorno del subsistema
        port chassisMount : MechanicalMountPort; // Fijacion y masa en chasis
        port powerInput : ElectricalPowerPort;   // Alimentacion desde planta motriz
        port dataBus : DataBusPort;             // Bus digital hacia GNC (CAN / Ethernet militar)
        port salidaModoDeteccion : DataBusPort; // Control de emisiones hacia navegacion (RGEN-09)
        port salidaInhabilitacionFrenado : DataBusPort; // Enlace de seguridad hacia control (RGEN-17)
        port entradaVideoTeleoperacion : DataBusPort;   // Flujo de video desde camaras de navegacion
        port entradaEstadoRodaje : DataBusPort;         // Telemetria de rodaje
        port rfPortLOS : RFPort;                // Puerto RF conectado con Consola CPT
        port rfPortBLOS : RFPort;               // Puerto RF conectado con Puesto de Mando (PMP) / Relé UAV

        // Conexiones internas de interconexion (Topologia IBD)
        connection c_bus_to_qos connect dataBus to gestorRedundanciaYQoS.puertoBusEntrada;
        connection c_video_to_qos connect entradaVideoTeleoperacion to gestorRedundanciaYQoS.puertoVideoEntrada;
        connection c_qos_to_crypto connect gestorRedundanciaYQoS.puertoSalidaCifrado to moduloCifradoCOMSEC.puertoEntradaDatos;
        connection c_crypto_to_los connect moduloCifradoCOMSEC.puertoDatosLOS to radioEnlaceTacticoLOS.dataBusInternal;
        connection c_crypto_to_blos connect moduloCifradoCOMSEC.puertoDatosBLOS to radioEnlaceTacticoBLOS.dataBusInternal;
        connection c_crypto_to_cnr connect moduloCifradoCOMSEC.puertoDatosCNR to radioTacticaMilitarCNR.dataBusInternal;
        connection c_los_to_antena connect radioEnlaceTacticoLOS.rfPort to sistemaAntenas.puertoEntradaLOS;
        connection c_blos_to_antena connect radioEnlaceTacticoBLOS.rfPort to sistemaAntenas.puertoEntradaBLOS;
        connection c_cnr_to_antena connect radioTacticaMilitarCNR.rfPort to sistemaAntenas.puertoEntradaCNR;
        connection c_antena_to_ext_los connect sistemaAntenas.puertoExteriorLOS to rfPortLOS;
        connection c_antena_to_ext_blos connect sistemaAntenas.puertoExteriorBLOS to rfPortBLOS;
        connection c_watchdog_monitor connect dataBus to supervisorEnlaceWatchdog.puertoBusMonitoreo;
        connection c_watchdog_frenado connect supervisorEnlaceWatchdog.puertoDisparoFrenado to salidaInhabilitacionFrenado;
        connection c_modo_emisiones connect gestorRedundanciaYQoS.puertoControlEmisiones to salidaModoDeteccion;

        // Trazabilidad formal del pliego: satisfaccion de requisitos
        satisfy requirement : ReqEnlaceTacticoLOS by radioEnlaceTacticoLOS;
        satisfy requirement : ReqEnlaceTacticoBLOS by radioEnlaceTacticoBLOS;
        satisfy requirement : ReqSeguridadComunicacionesCOMSEC by moduloCifradoCOMSEC;
        satisfy requirement : ReqProtocolosTacticosYQoS by gestorRedundanciaYQoS;
    }
}
