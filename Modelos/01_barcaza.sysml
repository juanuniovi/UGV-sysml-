package SubsistemaBarcaza {
    doc /* Definicion del bastidor estructural y barcaza comun del UGV (RGEN-02..05, RLT1-06) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // --- Subcomponentes Estructurales ---

    part def ChasisProtegidoEnV {
        doc /* Casco inferior con geometria en V para deflexion de onda expansiva contra minas terrestres e IEDs (RGEN-03) */
        attribute nivelProteccionSTANAG : Integer;
    }

    part def CabestranteAutoRecuperacion {
        doc /* Sistema de traccion mecanica motorizada para auto-rescate en pendientes y terreno farragoso (RGEN-04) */
        attribute capacidadTiroKN : Real;
    }

    part def GanchoRemolqueSTANAG {
        doc /* Dispositivo de enganche y recuperacion normalizado militar compatible STANAG 4101 (RGEN-05) */
        attribute normaSTANAG : String;
    }

    // --- Subsistema de Barcaza Principal ---

    part def BarcazaEstructural {
        attribute masa : Masa;

        // Elementos estructurales integrados
        part chasisProtegidoEnV : ChasisProtegidoEnV;
        part cabestranteAutoRecuperacion : CabestranteAutoRecuperacion;
        part ganchoRemolqueSTANAG4101 : GanchoRemolqueSTANAG;

        // Puertos de montaje mecanico interno
        port rodajeMount : MechanicalMountPort;
        port powertrainMount : MechanicalMountPort;
        port avionicaMount : MechanicalMountPort;

        // Puntos de interfaz normalizados para cargas de pago (RGEN-28)
        port interfazFrontalCarga : MechanicalMountPort;
        port interfazSuperiorCarga : MechanicalMountPort;
        port interfazTraseraCarga : MechanicalMountPort;
    }

    // --- Requisitos Trazables del Pliego ---

    requirement def ReqBarcazaComun {
        subject barcaza : BarcazaEstructural;
        doc /* La plataforma debe basarse en una arquitectura de barcaza comun y modular para toda la familia de variantes (RGEN-02). */
        require constraint { true }
    }

    requirement def ReqProteccionCascoEnV {
        subject chasis : ChasisProtegidoEnV;
        doc /* El chasis inferior debe incorporar geometria en V para desviar la onda de choque de minas e IEDs (RGEN-03). */
        require constraint { chasis.nivelProteccionSTANAG >= 1 }
    }

    requirement def ReqCabestranteAutoRecuperacion {
        subject cabestrante : CabestranteAutoRecuperacion;
        doc /* Capacidad de auto-recuperacion del vehiculo mediante cabestrante motorizado (RGEN-04). */
        require constraint { cabestrante.capacidadTiroKN >= 50.0 }
    }

    requirement def ReqGanchoSTANAG4101 {
        subject gancho : GanchoRemolqueSTANAG;
        doc /* Puntos de anclaje de remolque compatibles con el estandar militar STANAG 4101 (RGEN-05). */
        require constraint { true }
    }

    requirement def ReqMasaTaraPlataforma {
        subject barcaza : BarcazaEstructural;
        doc /* La masa en vacio o tara de la plataforma con ruedas debe situarse entre 3500 y 5000 kg (RLT1-06). */
        require constraint { barcaza.masa >= 3500.0 and barcaza.masa <= 5000.0 }
    }

    // --- Relaciones de Trazabilidad (Satisfy) ---

    satisfy ReqBarcazaComun by BarcazaEstructural;
    satisfy ReqProteccionCascoEnV by ChasisProtegidoEnV;
    satisfy ReqCabestranteAutoRecuperacion by CabestranteAutoRecuperacion;
    satisfy ReqGanchoSTANAG4101 by GanchoRemolqueSTANAG;
}
