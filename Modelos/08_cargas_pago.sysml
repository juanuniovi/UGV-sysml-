package SubsistemaCargasPago {
    doc /* Cargas de pago modulares intercambiables sobre la barcaza (RGEN-28, RLT1-13) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // Definicion base abstracta
    abstract part def CargaPagoModular {
        attribute masaModuloKg : Masa;
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort;
    }

    // Modulo ISTAR: Reconocimiento e Inteligencia
    part def Modulo_ISTAR :> CargaPagoModular {
        doc /* Reconocimiento tactico con mastil telescopico y cabezal electro-optico (UC-01; CP-05, Punto de Interfaz 2, RLT1-13) */
        part mastilTelescopico;
        part cabezalOpticoTermicoGiroestabilizado;
    }

    // Modulo Logistico: Transporte de Carga en Convoy
    part def Modulo_Logistico :> CargaPagoModular {
        doc /* Plataforma para transporte de palets estandarizados (UC-02; CP-07, Punto de Interfaz 3, RLT1-13) */
        part plataformaPortaPalets;
        part sistemaFijacionCarga;
    }

    // Modulo MEDEVAC: Evacuacion Sanitaria
    part def Modulo_MEDEVAC :> CargaPagoModular {
        doc /* Modulo asistencial con soporte vital para evacuacion de heridos (UC-03; CP-08, Punto de Interfaz 3, RLT1-13) */
        part cabinaAsistencialClimatizada;
        part camillasAmortiguadas[2];
        part equipoMonitorizacionVital;
    }

    requirement def ReqMasaMaximaModulo {
        subject modulo : CargaPagoModular;
        doc /* La masa de un modulo de carga de pago no superara 2000 kg, de modo que no exceda
               la capacidad de carga minima exigida a la plataforma (requisito derivado de RLT1-07). */
        require constraint { modulo.masaModuloKg <= 2000.0 }
    }
}
