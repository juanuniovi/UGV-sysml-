package SistemaUGV {
    doc /* Ensamblado principal del Sistema de Interes (SoI) y topologia de interconexion */
    private import ScalarValues::*;
    private import TiposBase::*;
    private import SubsistemaBarcaza::*;
    private import SubsistemaTrenRodaje::*;
    private import SubsistemaPlantaMotriz::*;
    private import SubsistemaControl::*;
    private import SubsistemaNavegacion::*;
    private import SubsistemaComunicaciones::*;
    private import SubsistemaEstacionesControl::*;
    private import SubsistemaUAVCenital::*;
    private import SubsistemaCargasPago::*;

    // --- Requisitos Generales Trazables del Pliego Oficial (CDTI Anexo I §3.1 y §3.2.1) ---

    requirement def ReqMasaMaximaOrdenMision {
        subject ugv : PlataformaUGV;
        doc /* El peso total del UGV en orden de mision no debera superar, en ningun caso, los 9000 kg (RLT1-08). */
        require constraint { ugv.masaOrdenMisionKg <= 9000.0 }
    }

    requirement def ReqCapacidadCargaMinimaPlataforma {
        subject ugv : PlataformaUGV;
        doc /* La capacidad de carga util del UGV sera de 2000 kg como minimo (RLT1-07). */
        require constraint { ugv.capacidadCargaUtilKg >= 2000.0 }
    }

    requirement def ReqCapacidadArrastreRemolque {
        subject ugv : PlataformaUGV;
        doc /* El UGV debera poder incorporar y arrastrar un remolque trasero con un peso de al menos 3000 kg mediante enganche STANAG 4101 (RGEN-10, RLT1-14). */
        require constraint { ugv.capacidadArrastreRemolqueKg >= 3000.0 }
    }

    requirement def ReqVelocidadRemolcadoPasivo {
        subject ugv : PlataformaUGV;
        doc /* El UGV debera poder ser remolcado por otros vehiculos de las unidades a una velocidad maxima de al menos 65 km/h (RGEN-16). */
        require constraint { ugv.velocidadRemolcadoKmh >= 65.0 }
    }

    requirement def ReqCapacidadVadeo {
        subject ugv : PlataformaUGV;
        doc /* Capacidad de vadeo en profundidad sin preparacion de al menos 0.75 m tanto en agua dulce como salada (RLT1-10). */
        require constraint { ugv.profundidadVadeoM >= 0.75 }
    }

    requirement def ReqAutonomiaTotalPlataforma {
        subject ugv : PlataformaUGV;
        doc /* La autonomia total del UGV sera de al menos 8 horas de funcionamiento o 400 km (RGEN-14). */
        require constraint { ugv.autonomiaTotalHoras >= 8.0 and ugv.autonomiaTotalKm >= 400.0 }
    }

    requirement def ReqAutonomiaModoElectrico {
        subject ugv : PlataformaUGV;
        doc /* La autonomia del UGV funcionando en modo puramente electrico sigiloso sera de al menos 2 horas o 100 km (RGEN-15). */
        require constraint { ugv.autonomiaElectricaHoras >= 2.0 and ugv.autonomiaElectricaKm >= 100.0 }
    }

    requirement def ReqConcepcionNativaNoTripulada {
        subject soi : SistemaUGVPesadoDual;
        doc /* Plataforma concebida desde el inicio como robot autonomo sin habitaculo de tripulacion, gobernada y supervisada remotamente desde el Puesto de Mando Portable (RGEN-01, RGEN-04). */
        require constraint { true }
    }

    requirement def ReqResistenciaAmbiental {
        subject ugv : PlataformaUGV;
        doc /* Resistencia del UGV y sus subsistemas frente a agentes ambientales extremos: temperatura, lluvia, humedad, corrosion y radiacion solar (RGEN-06). */
        require constraint { true }
    }

    requirement def ReqEstibaTransporteEstrategico {
        subject ugv : PlataformaUGV;
        doc /* Puntos de amarre y estiba dimensionados para aerotransporte en ala fija segun STANAG 3400 y transporte terrestre segun UNE-EN 12195 (RGEN-24, RGEN-25). */
        require constraint { true }
    }

    requirement def ReqEstabilidadPuntosInterfaz {
        subject ugv : PlataformaUGV;
        doc /* Los puntos de interfaz mecanicos, electricos y logicos no comprometeran la estabilidad del UGV ni con carga de pago acoplada ni sin ella (RGEN-28, RGEN-29). */
        require constraint { true }
    }

    // --- Definicion del vehiculo terrestre base ---
    part def PlataformaUGV {
        // Atributos globales de masa y prestaciones de plataforma (Anexo I §3.1 y §3.2.1)
        attribute masaOrdenMisionKg : Masa;
        attribute capacidadCargaUtilKg : Masa;
        attribute capacidadArrastreRemolqueKg : Masa;
        attribute velocidadRemolcadoKmh : Real;
        attribute profundidadVadeoM : Real;
        attribute autonomiaTotalHoras : Real;
        attribute autonomiaTotalKm : Real;
        attribute autonomiaElectricaHoras : Real;
        attribute autonomiaElectricaKm : Real;

        part barcaza : BarcazaEstructural;
        part rodaje : TrenRodajeRuedas;
        part plantaMotriz : PlantaMotrizHibrida;
        part control : SistemaControl;
        part navegacion : SistemaNavegacion;
        part comunicaciones : SistemaComunicacionesEmbarcado;

        // Conexiones estructurales internas
        connection c_barcaza_rodaje connect barcaza.rodajeMount to rodaje.chassisMount;
        connection c_barcaza_powertrain connect barcaza.powertrainMount to plantaMotriz.chassisMount;
        connection c_barcaza_control connect barcaza.avionicaMount to control.chassisMount;
        connection c_barcaza_navegacion connect barcaza.avionicaMount to navegacion.chassisMount;

        // Conexiones de potencia electrica
        connection c_power_traction connect plantaMotriz.powerOutputTraction to rodaje.powerInput;
        connection c_power_control connect plantaMotriz.powerOutputAvionics to control.powerInput;
        connection c_power_navegacion connect plantaMotriz.powerOutputAvionics to navegacion.powerInput;
        connection c_power_comms connect plantaMotriz.powerOutputAvionics to comunicaciones.powerInput;

        // Conexiones de bus de datos y drive-by-wire
        connection c_bus_comms_control connect comunicaciones.dataBus to control.dataBus;
        connection c_drive_by_wire connect control.driveByWireOutput to rodaje.controlBus;
        connection c_pms_control connect control.dataBus to plantaMotriz.controlBus;

        // Conexiones entre el Subsistema 4.2 de Navegacion, Comunicaciones y el Subsistema 4.1 de Control (RGEN-09, RNAV-01, ROPE-06, RGEN-17, RGEN-22)
        connection c_nav_obstaculos_ctrl connect navegacion.salidaObstaculos to control.entradaObstaculos;
        connection c_nav_vio_ctrl connect navegacion.salidaOdometria to control.entradaOdometria;
        connection c_comms_modo_nav connect comunicaciones.salidaModoDeteccion to navegacion.entradaModoDeteccion;
        connection c_comms_frenado_ctrl connect comunicaciones.salidaInhabilitacionFrenado to control.entradaInhabilitacionFrenado;
        connection c_nav_video_comms connect navegacion.salidaVideoTeleoperacion to comunicaciones.entradaVideoTeleoperacion;
        connection c_nav_rodaje_comms connect navegacion.salidaEstadoRodaje to comunicaciones.entradaEstadoRodaje;

        // Relaciones de satisfaccion de requisitos generales de plataforma
        satisfy requirement : ReqMasaMaximaOrdenMision;
        satisfy requirement : ReqCapacidadCargaMinimaPlataforma;
        satisfy requirement : ReqCapacidadArrastreRemolque;
        satisfy requirement : ReqVelocidadRemolcadoPasivo;
        satisfy requirement : ReqCapacidadVadeo;
        satisfy requirement : ReqAutonomiaTotalPlataforma;
        satisfy requirement : ReqAutonomiaModoElectrico;
        satisfy requirement : ReqResistenciaAmbiental;
        satisfy requirement : ReqEstibaTransporteEstrategico;
        satisfy requirement : ReqEstabilidadPuntosInterfaz;
        satisfy requirement : ReqNavegacionGNSSDenegado by navegacion;
        satisfy requirement : ReqDeteccionObstaculosModoSigiloso by navegacion;
        satisfy requirement : ReqConcienciaSituacionalVisionSensores by navegacion;
        satisfy requirement : ReqFrenadoAutomaticoColision by control;
    }

    // --- Sistema de Interes Completo (SoI) ---
    part def SistemaUGVPesadoDual {
        doc /* SoI completo contratado: Vehiculo + Puesto Mando + CPT + UAV + Carga de Pago */

        part vehiculo : PlataformaUGV;
        part puestoMando : PuestoMandoPortable;
        part consolaCPT : ConsolaPortableCPT;
        part uavCenital : UAVApoyoCenital;
        part cargaPagoMision : CargaPagoModular[0..1];

        // Enlaces de radiofrecuencia táctica
        connection c_rf_blos connect puestoMando.rfPortBLOS to vehiculo.comunicaciones.rfPortBLOS;
        connection c_rf_los connect consolaCPT.rfPortLOS to vehiculo.comunicaciones.rfPortLOS;
        connection c_rf_uav connect uavCenital.rfPortRelay to vehiculo.comunicaciones.rfPortBLOS;

        // Acople fisico, energetico y logico de carga de pago instalada
        connection c_payload_mount connect vehiculo.barcaza.interfazSuperiorCarga to cargaPagoMision.chassisMount;
        connection c_payload_power connect vehiculo.plantaMotriz.powerOutputPayload to cargaPagoMision.powerInput;
        connection c_payload_data connect vehiculo.control.dataBus to cargaPagoMision.dataBus;

        // Recarga y sustentacion del UAV cenital en techo del UGV
        connection c_uav_landing connect vehiculo.barcaza.interfazSuperiorCarga to uavCenital.landingMount;
        connection c_uav_power connect vehiculo.plantaMotriz.powerOutputPayload to uavCenital.rechargePower;

        // Satisfaccion de requisito general de concepcion nativa y gobierno remoto del SoI
        satisfy requirement : ReqConcepcionNativaNoTripulada;
    }

    part sistemaUGV : SistemaUGVPesadoDual;
}
