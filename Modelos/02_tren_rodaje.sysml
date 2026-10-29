package SubsistemaTrenRodaje {
    doc /* Tren de rodaje a ruedas independientes y suspension regulable (RLT1-01..05) */
    private import ScalarValues::*;
    private import TiposBase::*;

    part def TrenRodajeRuedas {
        attribute numeroRuedas : Integer;
        attribute alturaLibreSueloMm : Real;

        // Subsistemas de rodaje
        part ruedas[4..8];
        part suspensionNeumaticaRegulable;
        part servodireccion;
        part sistemaFrenadoServicio;

        // Puertos
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port controlBus : DataBusPort;
    }

    requirement def ReqSuspensionRegulable {
        subject rodaje : TrenRodajeRuedas;
        doc /* La suspension neumatica debe permitir variacion de altura libre y retraccion para transporte (RLT1-05). */
        require constraint { rodaje.alturaLibreSueloMm >= 350.0 }
    }
}
