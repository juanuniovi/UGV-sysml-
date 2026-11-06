package SubsistemaTrenRodaje {
    doc /* Tren de rodaje a ruedas independientes, suspension regulable y servodireccion (RLT1-01..05) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // --- Subcomponentes del Tren de Rodaje ---

    part def RuedaTraccionIndependiente {
        doc /* Conjunto de rueda todoterreno con motor electrico de traccion directa e independiente por rueda (RLT1-01, RLT1-04) */
        attribute diametroLlantaPulgadas : Real;
        attribute parNominalNm : Real;
    }

    part def SuspensionNeumaticaRegulable {
        doc /* Sistema de suspension neumatica independiente por brazo de rueda, regulable en altura y retractil para transporte en bodega (RLT1-05) */
        attribute alturaDespejeMinimaMm : Real;
        attribute alturaDespejeMaximaMm : Real;
        attribute esRetractilTransporte : Boolean;
    }

    part def ServodireccionMultieje {
        doc /* Servodireccion electromecanica multieje con capacidad de giro pivotante sobre su propio centro para alta maniobrabilidad (RLT1-03) */
        attribute anguloMaximoGiroGrados : Real;
        attribute capacidadGiroCeroPivotante : Boolean;
    }

    part def SistemaFrenadoServicio {
        doc /* Sistema de frenado electrohidraulico de servicio con regeneracion electrica y bloqueo de estacionamiento redundante */
        attribute presionFrenadoBar : Real;
    }

    // --- Requisitos Trazables del Pliego Oficial (CDTI Anexo I) ---

    requirement def ReqTraccionRuedas {
        subject rodaje : TrenRodajeRuedas;
        doc /* El Sistema UGV a desarrollar se basara en un tren con traccion de ruedas para alcanzar mayores velocidades en terrenos llanos y consolidados (RLT1-01). */
        require constraint { true }
    }

    requirement def ReqConfiguracionMultirrueda {
        subject rodaje : TrenRodajeRuedas;
        doc /* El tren de traccion basado en ruedas podra ser 4x4, 6x6 u 8x8, contando con elevadas capacidades de movilidad off-road (RLT1-02). */
        require constraint { rodaje.numeroRuedas >= 4 and rodaje.numeroRuedas <= 8 }
    }

    requirement def ReqPrestacionesMovilidad {
        subject rodaje : TrenRodajeRuedas;
        doc /* Movilidad todoterreno: velocidad en carretera >= 75 km/h, campo a traves >= 50 km/h, pendiente frontal >= 60% y lateral >= 30% (RLT1-03). */
        require constraint { true }
    }

    requirement def ReqTraccionIndependienteRueda {
        subject rueda : RuedaTraccionIndependiente;
        doc /* Se debera implementar traccion directa e independiente en cada rueda (RLT1-04). */
        require constraint { rueda.parNominalNm > 0.0 }
    }

    requirement def ReqSuspensionRegulableRetractil {
        subject suspension : SuspensionNeumaticaRegulable;
        doc /* Se debera implementar un sistema de suspension neumatica retractil y regulable, independiente en cada brazo de cada rueda con altura >= 350 mm (RLT1-05). */
        require constraint { suspension.alturaDespejeMaximaMm >= 350.0 and suspension.esRetractilTransporte == true }
    }

    // --- Subsistema de Tren de Rodaje Principal ---

    part def TrenRodajeRuedas {
        doc /* Ensamblaje integral del tren de rodaje multirrueda con traccion independiente por rueda (RLT1-01..05) */
        attribute numeroRuedas : Integer;
        attribute alturaLibreSueloMm : Real;

        // Subsistemas de rodaje integrados (RLT1-02: 4x4, 6x6 u 8x8)
        part ruedas : RuedaTraccionIndependiente[4..8];
        part suspensionNeumatica : SuspensionNeumaticaRegulable;
        part servodireccion : ServodireccionMultieje;
        part sistemaFrenadoServicio : SistemaFrenadoServicio;

        // Puertos de interfaz estandar del SoI (compatibles con 09_sistema_ugv.sysml)
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port controlBus : DataBusPort;

        // Relaciones de satisfaccion de requisitos trazables canónicas de Spec42
        satisfy requirement : ReqTraccionRuedas;
        satisfy requirement : ReqConfiguracionMultirrueda;
        satisfy requirement : ReqPrestacionesMovilidad;
        satisfy requirement : ReqTraccionIndependienteRueda by ruedas;
        satisfy requirement : ReqSuspensionRegulableRetractil by suspensionNeumatica;
    }
}
