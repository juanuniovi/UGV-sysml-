package SubsistemaEstacionesControl {
    doc /* Estaciones de control remoto táctico: PMP y Consola CPT (Anexo I §1.3, ROPE-01..03) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // --- Partes Internas de la Consola Portable CPT ---
    part def MandosTacticosJoysticks {
        doc /* Joysticks de dirección, velocidad y parada de emergencia */
        port outComandos : DataBusPort;
    }

    part def PantallaVideoDirecto {
        doc /* Pantalla táctica para vídeo de conducción diurno/térmico */
        port inVideo : DataBusPort;
    }

    part def RadioEnlaceLOSCPT {
        doc /* Transceptor de radiofrecuencia táctico LOS 2.4 GHz */
        port inComandos : DataBusPort;
        port outVideo : DataBusPort;
        port rfPort : RFPort;
    }

    // --- Partes Internas del Puesto de Mando Portable PMP ---
    part def InterfazGraficaLinux {
        doc /* Estación de trabajo C2 para planificación de misión y waypoints */
        port outMandoC2 : DataBusPort;
    }

    part def PantallaTactilMision {
        doc /* Monitores táctiles con mosaico 360° y visor térmico */
        port inVideo360 : DataBusPort;
    }

    part def TerminalRadioBLOSPMP {
        doc /* Terminal radio táctico BLOS MANET / SDR militar */
        port inMandoC2 : DataBusPort;
        port outVideo360 : DataBusPort;
        port rfPort : RFPort;
    }

    // Puesto de Mando Portable (PMP)
    part def PuestoMandoPortable {
        doc /* Supervision tactica remota fuera de linea de vista (BLOS) con GUI Linux */
        part estacionTrabajoRugerizada;
        part pantallaTactilMision : PantallaTactilMision;
        part interfazGraficaLinux : InterfazGraficaLinux;
        part selectorModoDeteccionSigiloso; // Conmutacion modo deteccion NORMAL / SIGILOSO (RGEN-09)
        part terminalRadioBLOS : TerminalRadioBLOSPMP;
        part pergolaYAuxiliares;
        part grupoGeneradorAuxiliar;

        port rfPortBLOS : RFPort;

        // Conexiones internas del PMP
        connection c_pmp_c2 connect interfazGraficaLinux.outMandoC2 to terminalRadioBLOS.inMandoC2;
        connection c_pmp_video connect terminalRadioBLOS.outVideo360 to pantallaTactilMision.inVideo360;
        connection c_pmp_rf connect terminalRadioBLOS.rfPort to rfPortBLOS;
    }

    // Consola Portable de Operador (CPT)
    part def ConsolaPortableCPT {
        doc /* Telemando ligero de mano para control visual directo en linea de vista (LOS) */
        part terminalManoRugerizado;
        part mandosTacticosJoysticks : MandosTacticosJoysticks;
        part pantallaVideoDirecto : PantallaVideoDirecto;
        part selectorModoDeteccionSigiloso; // Conmutacion modo deteccion NORMAL / SIGILOSO (RGEN-09)
        part radioEnlaceLOS : RadioEnlaceLOSCPT;

        port rfPortLOS : RFPort;

        // Conexiones internas de la CPT
        connection c_cpt_joystick connect mandosTacticosJoysticks.outComandos to radioEnlaceLOS.inComandos;
        connection c_cpt_video connect radioEnlaceLOS.outVideo to pantallaVideoDirecto.inVideo;
        connection c_cpt_rf connect radioEnlaceLOS.rfPort to rfPortLOS;
    }
}
