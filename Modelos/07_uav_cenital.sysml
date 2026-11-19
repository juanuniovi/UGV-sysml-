package SubsistemaUAVCenital {
    doc /* Subsistema UAV Cenital: exploracion aerea y rele de comunicaciones (Anexo I §1.3) */
    private import ScalarValues::*;
    private import TiposBase::*;

    part def TranspondedorReleRadio {
        doc /* Repetidor de radiofrecuencia aéreo embarcado para enlace BLOS (RCOM-02) */
        port rfPort : RFPort;
    }

    part def UAVApoyoCenital {
        doc /* Dron aéreo de exploración y relé de comunicaciones embarcado en techo del UGV */
        part dronAereoExploracion;
        part camaraGiroestabilizadaOptica;
        part transpondedorReleRadio : TranspondedorReleRadio;
        part estacionRecargaTechoUGV; // Interfaz de amarre y carga en techo del UGV

        port landingMount : MechanicalMountPort;
        port rechargePower : ElectricalPowerPort;
        port rfPortRelay : RFPort;

        connection c_uav_rf connect transpondedorReleRadio.rfPort to rfPortRelay;
    }
}
