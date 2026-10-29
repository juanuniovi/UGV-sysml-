package SubsistemaEstacionesControl {
    doc /* Estaciones de control remoto táctico: PMP y Consola CPT (Anexo I §1.3, ROPE-01..03) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // Puesto de Mando Portable (PMP)
    part def PuestoMandoPortable {
        doc /* Supervision tactica remota fuera de linea de vista (BLOS) con GUI Linux */
        part estacionTrabajoRugerizada;
        part pantallaTactilMision;
        part interfazGraficaLinux;
        part terminalRadioBLOS;
        part pergolaYAuxiliares;
        part grupoGeneradorAuxiliar;

        port rfPortBLOS : RFPort;
    }

    // Consola Portable de Operador (CPT)
    part def ConsolaPortableCPT {
        doc /* Telemando ligero de mano para control visual directo en linea de vista (LOS) */
        part terminalManoRugerizado;
        part mandosTacticosJoysticks;
        part pantallaVideoDirecto;
        part radioEnlaceLOS;

        port rfPortLOS : RFPort;
    }
}
