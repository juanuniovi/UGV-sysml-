package SistemaUGV {
    doc /* Ensamblado principal del Sistema de Interes (SoI) y topologia de interconexion */
    private import ScalarValues::*;
    private import TiposBase::*;
    private import SubsistemaBarcaza::*;
    private import SubsistemaTrenRodaje::*;
    private import SubsistemaPlantaMotriz::*;
    private import SubsistemaNavegacionControl::*;
    private import SubsistemaComunicaciones::*;
    private import SubsistemaEstacionesControl::*;
    private import SubsistemaUAVCenital::*;
    private import SubsistemaCargasPago::*;

    // --- Definicion del vehiculo terrestre base ---
    part def PlataformaUGV {
        part barcaza : BarcazaEstructural;
        part rodaje : TrenRodajeRuedas;
        part plantaMotriz : PlantaMotrizHibrida;
        part navegacionControl : SistemaNavegacionControl;
        part comunicaciones : SistemaComunicacionesEmbarcado;

        // Conexiones estructurales internas
        connection c_barcaza_rodaje connect barcaza.rodajeMount to rodaje.chassisMount;
        connection c_barcaza_powertrain connect barcaza.powertrainMount to plantaMotriz.chassisMount;
        connection c_barcaza_avionica connect barcaza.avionicaMount to navegacionControl.chassisMount;

        // Conexiones de potencia electrica
        connection c_power_traction connect plantaMotriz.powerOutputTraction to rodaje.powerInput;
        connection c_power_avionics connect plantaMotriz.powerOutputAvionics to navegacionControl.powerInput;
        connection c_power_comms connect plantaMotriz.powerOutputAvionics to comunicaciones.powerInput;

        // Conexiones de bus de datos y drive-by-wire
        connection c_bus_comms_gnc connect comunicaciones.dataBus to navegacionControl.dataBus;
        connection c_drive_by_wire connect navegacionControl.driveByWireOutput to rodaje.controlBus;
        connection c_pms_control connect navegacionControl.dataBus to plantaMotriz.controlBus;
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
        connection c_payload_data connect vehiculo.navegacionControl.dataBus to cargaPagoMision.dataBus;

        // Recarga y sustentacion del UAV cenital en techo del UGV
        connection c_uav_landing connect vehiculo.barcaza.interfazSuperiorCarga to uavCenital.landingMount;
        connection c_uav_power connect vehiculo.plantaMotriz.powerOutputPayload to uavCenital.rechargePower;
    }

    part sistemaUGV : SistemaUGVPesadoDual;
}
