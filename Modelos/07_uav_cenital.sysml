package SubsistemaUAVCenital {
    doc /* Subsistema UAV Cenital: exploracion aerea y rele de comunicaciones (Anexo I §1.3) */
    private import ScalarValues::*;
    private import TiposBase::*;

    part def UAVApoyoCenital {
        part dronAereoExploracion;
        part camaraGiroestabilizadaOptica;
        part transpondedorReleRadio;
        part estacionRecargaTechoUGV; // Interfaz de amarre y carga en techo del UGV

        port landingMount : MechanicalMountPort;
        port rechargePower : ElectricalPowerPort;
        port rfPortRelay : RFPort;
    }
}
