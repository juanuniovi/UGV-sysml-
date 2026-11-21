package SubsistemaComunicaciones {
    doc /* Subsistema de Comunicaciones Tácticas: Cadena de fallo de 5 protocolos (Plan PACE) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // =========================================================================
    // 1. Los 5 Protocolos Principales de Conmutación ante Fallo (Plan PACE)
    // =========================================================================
    part def Canal1_LOS_CPT {
        doc /* 1º ORDEN (Principal): Radio LOS 2.4 GHz con Consola CPT (RCOM-01) */
        attribute protocolo : String = "UDP + micro-DDS con FEC";
        attribute latenciaMs : Real = 20.0;
        attribute estadoVideo : String = "1080p @ 30 fps";

        port rfPort : RFPort;
    }

    part def Canal2_BLOS_PMP {
        doc /* 2º ORDEN (Alternativo): Radio MANET BLOS con Puesto de Mando PMP */
        attribute protocolo : String = "STANAG 4586 / JAUS";
        attribute latenciaMs : Real = 150.0;
        attribute estadoVideo : String = "1080p adaptativo";

        port rfPort : RFPort;
    }

    part def Canal3_Rele_UAV {
        doc /* 3º ORDEN (Contingencia): Relé aéreo a través de UAV Cenital (RCOM-02) */
        attribute protocolo : String = "STANAG 4586";
        attribute estadoVideo : String = "720p @ 15 fps";

        port rfPort : RFPort;
    }

    part def Canal4_CNR_Militar {
        doc /* 4º ORDEN (Respaldo Militar): Radio táctica militar VHF 30-88 MHz */
        attribute protocolo : String = "Telegramas BMS-ET / C2";
        attribute estadoVideo : String = "APAGADO (0 Mbps para reservar telemando)";

        port rfPort : RFPort;
    }

    part def Canal5_Failsafe_Freno {
        doc /* 5º ORDEN (Failsafe Crítico): Parada automática si no hay latido en 1.000 ms (RGEN-17) */
        attribute timeoutFailsafeMs : Real = 1000.0;
        attribute accion : String = "Bloqueo inmediato de frenos en GNC";

        port salidaFreno : DataBusPort;
    }

    // =========================================================================
    // 2. Requisitos Contractuales del Pliego Oficial
    // =========================================================================
    requirement def ReqEnlaceLOS {
        subject comms : SistemaComunicacionesEmbarcado;
        doc /* Enlace tactico en linea de vista con CPT (RCOM-01) */
        require constraint { true }
    }

    requirement def ReqEnlaceBLOS {
        subject comms : SistemaComunicacionesEmbarcado;
        doc /* Enlace fuera de linea de vista y rele UAV (RCOM-02) */
        require constraint { true }
    }

    requirement def ReqSeguridadCOMSEC {
        subject comms : SistemaComunicacionesEmbarcado;
        doc /* Seguridad COMSEC y proteccion electronica (RCOM-03) */
        require constraint { true }
    }

    requirement def ReqProtocolosPACE {
        subject comms : SistemaComunicacionesEmbarcado;
        doc /* Pila de protocolos tacticos Plan PACE y prioridad de telemando (RSW-06) */
        require constraint { true }
    }

    requirement def ReqFailsafeEnlace {
        subject comms : SistemaComunicacionesEmbarcado;
        doc /* Parada de seguridad por perdida de enlace (RGEN-17) */
        require constraint { true }
    }

    // =========================================================================
    // 3. Bloque Principal: Subsistema de Comunicaciones Embarcado
    // =========================================================================
    part def SistemaComunicacionesEmbarcado {
        doc /* Ensamblaje del subsistema de comunicaciones con la cadena de 5 canales PACE */

        // Los 5 canales de conmutación jerárquica
        part canal1_LOS : Canal1_LOS_CPT;
        part canal2_BLOS : Canal2_BLOS_PMP;
        part canal3_UAV : Canal3_Rele_UAV;
        part canal4_CNR : Canal4_CNR_Militar;
        part canal5_Failsafe : Canal5_Failsafe_Freno;

        // Puertos hacia la plataforma UGV y estaciones externas
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort;
        port salidaModoDeteccion : DataBusPort;
        port salidaInhabilitacionFrenado : DataBusPort;
        port entradaVideoTeleoperacion : DataBusPort;
        port entradaEstadoRodaje : DataBusPort;
        port rfPortLOS : RFPort;
        port rfPortBLOS : RFPort;

        // Conexiones directas
        connection c_los connect canal1_LOS.rfPort to rfPortLOS;
        connection c_blos connect canal2_BLOS.rfPort to rfPortBLOS;
        connection c_uav connect canal3_UAV.rfPort to rfPortBLOS;
        connection c_frenado connect canal5_Failsafe.salidaFreno to salidaInhabilitacionFrenado;

        // Satisfacción formal de requisitos del pliego
        satisfy requirement : ReqEnlaceLOS;
        satisfy requirement : ReqEnlaceBLOS;
        satisfy requirement : ReqSeguridadCOMSEC;
        satisfy requirement : ReqProtocolosPACE;
        satisfy requirement : ReqFailsafeEnlace;
    }
}
