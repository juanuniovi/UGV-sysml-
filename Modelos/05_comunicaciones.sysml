package SubsistemaComunicaciones {
    doc /* Sistema de comunicaciones tácticas embarcadas con arquitectura redundante Plan PACE,
           gestión estricta de QoS, cifrado COMSEC y topología completa IBD (RCOM-01..03, RSW-06) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // =========================================================================
    // 1. Items de Datos de Flujo Tipados y Protocolos Tácticos
    // =========================================================================
    item def ComandoTelemandoLOS {
        doc /* Consignas de telemando directo procedentes de la Consola CPT (joysticks de dirección y velocidad) */
        attribute protocolo : String = "UDP + micro-DDS con FEC";
        attribute tasaRefrescoHz : Real = 50.0;
        attribute latenciaMaximaMs : Real = 20.0;
        attribute prioridadQoS : Integer = 1; // Prioridad máxima en cola Expedited Forwarding
    }

    item def TelemetriaVideoLOS {
        doc /* Retransmisión de vídeo de conducción y cámaras panorámicas 360° hacia CPT y PMP */
        attribute protocolo : String = "STANAG 4609 (H.265 / HEVC + KLV MISB ST 0601)";
        attribute resolucionNominal : String = "1080p @ 30 fps";
        attribute caudalEstimadoMbps : Real = 6.0;
        attribute prioridadQoS : Integer = 4; // Prioridad baja degradable Best Effort
    }

    item def ComandoControlBLOS {
        doc /* Órdenes C2 estructuradas de navegación autónoma, waypoints y misión procedentes del PMP */
        attribute protocolo : String = "STANAG 4586 (Edición 4) / JAUS";
        attribute acuseReciboGarantizado : Boolean = true;
        attribute latenciaMaximaMs : Real = 150.0;
        attribute prioridadQoS : Integer = 2;
    }

    item def TrazaTacticaBMS {
        doc /* Mensajería Blue Force Tracking (BFT) y estado táctico hacia la red de combate del batallón */
        attribute protocolo : String = "BMS-ET / MIP Militar";
        attribute bandaPortadora : String = "VHF Militar (30-88 MHz)";
        attribute prioridadQoS : Integer = 3;
    }

    item def HeartbeatEnlace {
        doc /* Trama periódica de sincronización de latido para supervisión y disparo de failsafe RGEN-17 */
        attribute frecuenciaEnvioHz : Real = 5.0; // 1 pulso cada 200 ms
        attribute timeoutFailsafeMs : Real = 1000.0; // Disparo automático si se pierden 5 latidos
        attribute prioridadQoS : Integer = 1;
    }

    // =========================================================================
    // 2. Definiciones de Partes Transceptoras, Criptográficas y de Gestión
    // =========================================================================
    part def RadioEnlaceTacticoLOS {
        doc /* Transceptor de radiofrecuencia táctico para telemando reactivo en línea de vista (RCOM-01) */
        attribute protocoloTransporte : String = "UDP + FEC";
        attribute frecuenciaGhz : Real = 2.4;
        attribute latenciaMaximaMs : Real = 100.0;
        attribute alcanceNominalKm : Real = 1.5;
        attribute puertoSocket : Integer = 5001;

        port rfPort : RFPort;
        port dataBusInternal : DataBusPort;
    }

    part def RadioEnlaceTacticoBLOS {
        doc /* Transceptor MANET táctico para mando C2 a larga distancia y relé aéreo con UAV (RCOM-02) */
        attribute protocoloTransporte : String = "STANAG 4586 sobre MANET IP";
        attribute bandaFrecuencia : String = "UHF / Banda C militar";
        attribute alcanceNominalKm : Real = 5.0;
        attribute latenciaMaximaMs : Real = 150.0;
        attribute soporteReleUAV : Boolean = true;
        attribute modulacionSDR : Boolean = true;

        port rfPort : RFPort;
        port dataBusInternal : DataBusPort;
    }

    part def RadioTacticaMilitarCNR {
        doc /* Radio de combate militar VHF (PR4G / SDR ESSOR) para C4I/BMS y canal de respaldo extremo */
        attribute protocoloTransporte : String = "Telegramas binarios BMS-ET con salto FHSS";
        attribute bandaOperacionVhfMhz : Real = 30.0; // Rango 30-88 MHz con difracción terrestre
        attribute saltoFrecuenciaActivo : Boolean = true;
        attribute politicaVideo : String = "Video 100% apagado (0 Mbps) para reservar canal al telemando";

        port rfPort : RFPort;
        port dataBusInternal : DataBusPort;
    }

    part def ModuloCifradoCOMSEC {
        doc /* Criptoprocesador hardware para cifrado militar punto a punto y protección anti-jamming (RCOM-03) */
        attribute algoritmoCifrado : String = "AES-256-GCM";
        attribute cifradoHardwareActivo : Boolean = true;
        attribute proteccionAntiJamming : Boolean = true;

        port puertoEntradaDatos : DataBusPort;
        port puertoDatosLOS : DataBusPort;
        port puertoDatosBLOS : DataBusPort;
        port puertoDatosCNR : DataBusPort;
    }

    part def GestorRedundanciaYQoS {
        doc /* Planificador de colas QoS y máquina de estados de conmutación ante fallos Plan PACE (RSW-06) */
        attribute planPACE_1_Principal : String = "1º Orden: Radio LOS 2.4 GHz (Consola CPT)";
        attribute planPACE_2_Alternativo : String = "2º Orden: Radio MANET BLOS (Puesto PMP)";
        attribute planPACE_3_Contingencia : String = "3º Orden: Relé Aéreo con Transpondedor UAV Cenital";
        attribute planPACE_4_RespaldoMilitar : String = "4º Orden: Radio Militar VHF CNR (PR4G/ESSOR)";
        attribute planPACE_5_Emergencia : String = "5º Orden: Heartbeat Timeout -> Frenado automático RGEN-17";
        attribute tiempoHisteresisRetornoS : Real = 3.0; // Estabilidad ininterrumpida antes de retornar de canal

        port puertoBusEntrada : DataBusPort;
        port puertoVideoEntrada : DataBusPort;
        port puertoSalidaCifrado : DataBusPort;
        port puertoControlEmisiones : DataBusPort;
    }

    part def SupervisorEnlaceWatchdog {
        doc /* Temporizador de latido de enlace para disparo directo de parada de seguridad failsafe (RGEN-17) */
        attribute periodoHeartbeatMs : Real = 200.0;
        attribute timeoutFailsafeMs : Real = 1000.0;
        attribute accionDisparo : String = "Orden inmediata a ModuloFrenadoSeguridad para clavar frenos en GNC";

        port puertoBusMonitoreo : DataBusPort;
        port puertoDisparoFrenado : DataBusPort;
    }

    part def SistemaAntenasEmbarcado {
        doc /* Conjunto de antenas omnidireccionales en techo de barcaza resistentes a vadeo y MIL-STD-810H (RLT1-10) */
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
        doc /* El UGV debe disponer de un enlace de radiofrecuencia táctico en línea de vista (LOS)
               con la Consola Portable de Operador (CPT) para telemando con latencia <= 100 ms (RCOM-01). */
        require constraint { true }
    }

    requirement def ReqEnlaceTacticoBLOS {
        doc /* El UGV debe disponer de un enlace de radiofrecuencia táctico fuera de línea de vista (BLOS)
               para control a larga distancia desde el Puesto de Mando (PMP) y compatibilidad de relé
               aéreo a través del transpondedor del UAV cenital embarcado (RCOM-02). */
        require constraint { true }
    }

    requirement def ReqSeguridadComunicacionesCOMSEC {
        doc /* El subsistema de comunicaciones debe implementar cifrado hardware militar punto a punto
               (COMSEC), protección anti-jamming y salto ágil de frecuencia FHSS (RCOM-03). */
        require constraint { true }
    }

    requirement def ReqProtocolosTacticosYQoS {
        doc /* Arquitectura de transporte y protocolos tácticos con calidad de servicio (QoS) estricta
               que priorice de forma no bloqueante las órdenes críticas de guiado y frenado frente a los
               flujos multimedia pesados de vídeo (RSW-06). */
        require constraint { true }
    }

    // =========================================================================
    // 4. Bloque Principal del Subsistema de Comunicaciones
    // =========================================================================
    part def SistemaComunicacionesEmbarcado {
        doc /* Subsistema de comunicaciones embarcado del UGV con redundancia Plan PACE, QoS y topología IBD completa */

        // Subpartes específicas tipadas del subsistema
        part radioEnlaceTacticoLOS : RadioEnlaceTacticoLOS;
        part radioEnlaceTacticoBLOS : RadioEnlaceTacticoBLOS;
        part radioTacticaMilitarCNR : RadioTacticaMilitarCNR;
        part moduloCifradoCOMSEC : ModuloCifradoCOMSEC;
        part gestorRedundanciaYQoS : GestorRedundanciaYQoS;
        part supervisorEnlaceWatchdog : SupervisorEnlaceWatchdog;
        part sistemaAntenas : SistemaAntenasEmbarcado;

        // Puertos externos de contorno del subsistema
        port chassisMount : MechanicalMountPort; // Fijación y masa en chasis
        port powerInput : ElectricalPowerPort;   // Alimentación desde planta motriz
        port dataBus : DataBusPort;             // Bus digital hacia GNC (consignas joysticks y C2)
        port salidaModoDeteccion : DataBusPort; // Control de emisiones hacia navegación (RGEN-09)
        port salidaInhabilitacionFrenado : DataBusPort; // Enlace de seguridad directa hacia frenado GNC (RGEN-17)
        port entradaVideoTeleoperacion : DataBusPort;   // Flujo físico de vídeo desde cámaras de navegación
        port entradaEstadoRodaje : DataBusPort;         // Telemetría de rodaje
        port rfPortLOS : RFPort;                // Puerto RF conectado con Consola CPT
        port rfPortBLOS : RFPort;               // Puerto RF conectado con Puesto de Mando (PMP) / Relé UAV
        port rfPortCNR : RFPort;                // Puerto RF conectado con Antena VHF Militar (Red Batallón)

        // Conexiones internas de interconexión (Topología IBD)
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
        connection c_antena_to_ext_cnr connect sistemaAntenas.puertoExteriorCNR to rfPortCNR;
        connection c_watchdog_monitor connect dataBus to supervisorEnlaceWatchdog.puertoBusMonitoreo;
        connection c_watchdog_frenado connect supervisorEnlaceWatchdog.puertoDisparoFrenado to salidaInhabilitacionFrenado;
        connection c_modo_emisiones connect gestorRedundanciaYQoS.puertoControlEmisiones to salidaModoDeteccion;

        // Trazabilidad formal del pliego: satisfacción de requisitos
        satisfy requirement : ReqEnlaceTacticoLOS by radioEnlaceTacticoLOS;
        satisfy requirement : ReqEnlaceTacticoBLOS by radioEnlaceTacticoBLOS;
        satisfy requirement : ReqSeguridadComunicacionesCOMSEC by moduloCifradoCOMSEC;
        satisfy requirement : ReqProtocolosTacticosYQoS by gestorRedundanciaYQoS;
    }
}
