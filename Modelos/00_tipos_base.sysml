package TiposBase {
    doc /* Tipos de datos, magnitudes fisicas y definiciones de puertos comunes para el UGV */
    private import ScalarValues::*;

    // --- Magnitudes Fisicas ---
    attribute def Masa :> Real;
    attribute def Potencia :> Real;
    attribute def Tension :> Real;
    attribute def Velocidad :> Real;
    attribute def Longitud :> Real;

    // --- Definiciones de Puertos Fisicos y Logicos ---
    port def MechanicalMountPort {
        doc /* Puerto de montaje y fijacion mecanica estructural */
    }

    port def ElectricalPowerPort {
        doc /* Puerto de transmision de potencia electrica (alta o baja tension) */
    }

    port def DataBusPort {
        doc /* Puerto de comunicaciones por bus de datos embarcado (CAN Bus / Ethernet militar) */
    }

    port def RFPort {
        doc /* Puerto de enlace inalambrico por radiofrecuencia (LOS / BLOS) */
    }
}
