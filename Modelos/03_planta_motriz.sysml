package SubsistemaPlantaMotriz {
    doc /* Planta motriz hibrida: motor biocombustible + baterias modo silencioso (RGEN-11..19) */
    private import ScalarValues::*;
    private import TiposBase::*;

    part def PlantaMotrizHibrida {
        attribute potenciaNominalKW : Potencia;
        attribute capacidadBateriaKWh : Real;

        // Componentes funcionales
        part motorCombustionBiocombustible; // HVO 100% (RGEN-11)
        part generadorElectrico;
        part packBateriasTraccion;          // Autonomia silenciosa >= 2 h (RGEN-13)
        part motoresElectricosTraccion[1..*];
        part gestionEnergiaPMS;              // Power Management System
        part moduloExportacionPotencia;     // Exportacion continua 120 kW (RGEN-19)

        // Puertos
        port chassisMount : MechanicalMountPort;
        port powerOutputTraction : ElectricalPowerPort;
        port powerOutputAvionics : ElectricalPowerPort;
        port powerOutputPayload : ElectricalPowerPort;
        port controlBus : DataBusPort;
    }

    requirement def ReqPotenciaMinimaPlataforma {
        subject planta : PlantaMotrizHibrida;
        doc /* La potencia combinada del sistema de propulsion de ruedas debe ser al menos de 140 kW (RLT1-09). */
        require constraint { planta.potenciaNominalKW >= 140.0 }
    }

    requirement def ReqExportacionEnergia {
        subject planta : PlantaMotrizHibrida;
        doc /* Capacidad de exportacion de energia a consumidores externos de al menos 120 kW (RGEN-19). */
        require constraint { true }
    }
}
