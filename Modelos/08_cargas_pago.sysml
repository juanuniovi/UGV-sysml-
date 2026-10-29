package SubsistemaCargasPago {
    doc /* Cargas de pago modulares intercambiables sobre la barcaza (RGEN-28, RLT1-12..14) */
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
        doc /* Reconocimiento tactico con mastil telescopico y cabezal electro-optico (UC-01) */
        part mastilTelescopico;
        part cabezalOpticoTermicoGiroestabilizado;
    }

    // Modulo Logistico: Transporte de Carga en Convoy
    part def Modulo_Logistico :> CargaPagoModular {
        doc /* Plataforma para transporte de palets estandarizados (UC-02) */
        part plataformaPortaPalets;
        part sistemaFijacionCarga;
    }

    // Modulo MEDEVAC: Evacuacion Sanitaria
    part def Modulo_MEDEVAC :> CargaPagoModular {
        doc /* Modulo asistencial con soporte vital para evacuacion de heridos (UC-03) */
        part cabinaAsistencialClimatizada;
        part camillasAmortiguadas[2];
        part equipoMonitorizacionVital;
    }

    requirement def ReqCapacidadCargaUtilPlataforma {
        subject modulo : CargaPagoModular;
        doc /* La plataforma de ruedas debe transportar al menos 2000 kg de carga util continua (RLT1-07). */
        require constraint { modulo.masaModuloKg <= 2000.0 }
    }
}
