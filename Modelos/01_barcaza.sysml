package SubsistemaBarcaza {
    doc /* Definicion del bastidor estructural y barcaza comun del UGV (RGEN-02..05) */
    private import ScalarValues::*;
    private import TiposBase::*;

    part def BarcazaEstructural {
        attribute masa : Masa;

        // Elementos estructurales integrados
        part chasisProtegidoEnV;
        part cabestranteAutoRecuperacion;
        part ganchoRemolqueSTANAG4101;

        // Puertos de montaje mecanico interno
        port rodajeMount : MechanicalMountPort;
        port powertrainMount : MechanicalMountPort;
        port avionicaMount : MechanicalMountPort;

        // Puntos de interfaz normalizados para cargas de pago (RGEN-28)
        port interfazFrontalCarga : MechanicalMountPort;
        port interfazSuperiorCarga : MechanicalMountPort;
        port interfazTraseraCarga : MechanicalMountPort;
    }

    requirement def ReqMasaTaraPlataforma {
        subject barcaza : BarcazaEstructural;
        doc /* La masa en vacio o tara de la plataforma con ruedas debe situarse entre 3500 y 5000 kg (RLT1-06). */
        require constraint { barcaza.masa >= 3500.0 and barcaza.masa <= 5000.0 }
    }
}
