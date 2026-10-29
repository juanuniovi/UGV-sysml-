package SubsistemaComunicaciones {
    doc /* Sistema de comunicaciones tacticas embarcadas (RCOM-01..03, RSW-06) */
    private import ScalarValues::*;
    private import TiposBase::*;

    part def SistemaComunicacionesEmbarcado {
        part radioEnlaceTacticoBLOS; // Largo alcance fuera de linea de vista
        part radioEnlaceTacticoLOS;  // Corto alcance linea de vista (CPT)
        part moduloCifradoCOMSEC;    // Criptografia y proteccion de senal
        part sistemaAntenas;

        // Puertos
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort;
        port rfPortBLOS : RFPort;
        port rfPortLOS : RFPort;
    }
}
