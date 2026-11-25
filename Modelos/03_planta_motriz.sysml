package SubsistemaPlantaMotriz {
    doc /* Planta motriz hibrida: motor biocombustible + baterias modo silencioso (RGEN-11..19) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // =========================================================================
    // 1. Puertos locales del subsistema
    // =========================================================================
    port def PuertoCombustible {
        doc /* Suministro de combustible (HVO / biocombustible) desde el deposito hacia el motor de combustion */
    }

    port def PuertoEjeMecanico {
        doc /* Transmision de par y giro mecanico desde el motor de combustion hacia el generador electrico */
    }

    // =========================================================================
    // 2. Bloques generales de la planta motriz (estructura, sin dimensionado)
    // =========================================================================
    part def DepositoCombustible {
        doc /* Deposito de combustible que alimenta al motor de combustion con biocombustible 100 % (RGEN-11) */
        port salidaCombustible : PuertoCombustible;
        port datosGestion : DataBusPort;         // Nivel de combustible hacia el PMS
    }

    part def MotorCombustionBiocombustible {
        doc /* Motor de combustion interna compatible con biocombustible 100 % que acciona exclusivamente el generador electrico: arquitectura hibrida serie (RGEN-11) */
        port entradaCombustible : ~PuertoCombustible;
        port ejeSalida : PuertoEjeMecanico;
        port datosGestion : DataBusPort;         // Arranque, parada y estado hacia el PMS
    }

    part def GeneradorElectrico {
        doc /* Generador accionado por el motor de combustion que produce la potencia electrica del bus de alta tension y recarga las baterias (RGEN-11) */
        port ejeEntrada : ~PuertoEjeMecanico;
        port salidaPotencia : ElectricalPowerPort;
        port datosGestion : DataBusPort;
    }

    part def PackBateriasTraccion {
        doc /* Pack de baterias de traccion recargable que permite el modo puramente electrico sigiloso sin motor de combustion (RGEN-13) */
        port puertoPotencia : ElectricalPowerPort; // Carga y descarga (bidireccional)
        port datosGestion : DataBusPort;           // BMS: estado de carga y salud hacia el PMS
    }

    part def UnidadDistribucionPotencia {
        doc /* Bus de alta tension que reune la potencia del generador y de las baterias y la reparte hacia traccion, baja tension y exportacion (RLT1-09). La energia regenerada en las frenadas vuelve desde el tren de rodaje por la salida de traccion hacia las baterias. */
        port entradaGenerador : ElectricalPowerPort;
        port puertoBaterias : ElectricalPowerPort;
        port salidaTraccion : ElectricalPowerPort;
        port salidaBajaTension : ElectricalPowerPort;
        port salidaExportacion : ElectricalPowerPort;
        port datosGestion : DataBusPort;
    }

    part def ConvertidorBajaTension {
        doc /* Convertidor de alta a baja tension que alimenta la avionica embarcada (control, navegacion y comunicaciones) */
        port entradaAltaTension : ElectricalPowerPort;
        port salidaBajaTension : ElectricalPowerPort;
        port datosGestion : DataBusPort;
    }

    part def GestionEnergiaPMS {
        doc /* Sistema de gestion de energia (PMS): decide que fuentes aportan y que consumidores reciben potencia segun el modo de operacion ordenado por Control, incluido el modo sigiloso solo electrico (RGEN-09, RGEN-13) */
        port busExterno : DataBusPort;           // Ordenes y estado con el subsistema de Control
        port enlaceDeposito : DataBusPort;
        port enlaceMotor : DataBusPort;
        port enlaceGenerador : DataBusPort;
        port enlaceBaterias : DataBusPort;
        port enlaceDistribucion : DataBusPort;
        port enlaceConvertidor : DataBusPort;
        port enlaceExportacion : DataBusPort;
    }

    part def ModuloExportacionPotencia {
        doc /* Modulo de exportacion de potencia hacia cargas de pago, recarga del UAV y consumidores externos a la plataforma (RGEN-19) */
        port entradaPotencia : ElectricalPowerPort;
        port salidaPotencia : ElectricalPowerPort;
        port datosGestion : DataBusPort;
    }

    // =========================================================================
    // 3. Bloque principal de la planta motriz hibrida
    // =========================================================================
    part def PlantaMotrizHibrida {
        attribute potenciaNominalKW : Potencia;
        attribute capacidadBateriaKWh : Real;

        // Componentes funcionales
        part depositoCombustible : DepositoCombustible;
        part motorCombustionBiocombustible : MotorCombustionBiocombustible; // HVO 100% (RGEN-11)
        part generadorElectrico : GeneradorElectrico;
        part packBateriasTraccion : PackBateriasTraccion;          // Autonomia silenciosa >= 2 h (RGEN-13)
        part distribucionPotencia : UnidadDistribucionPotencia;
        part convertidorBajaTension : ConvertidorBajaTension;
        part gestionEnergiaPMS : GestionEnergiaPMS;              // Power Management System
        part moduloExportacionPotencia : ModuloExportacionPotencia;     // Exportacion continua 120 kW (RGEN-19)

        // Puertos
        port chassisMount : MechanicalMountPort;
        port powerOutputTraction : ElectricalPowerPort;
        port powerOutputAvionics : ElectricalPowerPort;
        port powerOutputPayload : ElectricalPowerPort;
        port controlBus : DataBusPort;

        // Cadena de generacion termica (combustible -> eje -> electricidad)
        connection c_deposito_motor connect depositoCombustible.salidaCombustible to motorCombustionBiocombustible.entradaCombustible;
        connection c_motor_generador connect motorCombustionBiocombustible.ejeSalida to generadorElectrico.ejeEntrada;
        connection c_generador_distribucion connect generadorElectrico.salidaPotencia to distribucionPotencia.entradaGenerador;

        // Almacenamiento y reparto de potencia electrica
        connection c_baterias_distribucion connect packBateriasTraccion.puertoPotencia to distribucionPotencia.puertoBaterias;
        connection c_distribucion_convertidor connect distribucionPotencia.salidaBajaTension to convertidorBajaTension.entradaAltaTension;
        connection c_distribucion_exportacion connect distribucionPotencia.salidaExportacion to moduloExportacionPotencia.entradaPotencia;

        // Enlaces de datos del sistema de gestion de energia (PMS)
        connection c_pms_deposito connect gestionEnergiaPMS.enlaceDeposito to depositoCombustible.datosGestion;
        connection c_pms_motor connect gestionEnergiaPMS.enlaceMotor to motorCombustionBiocombustible.datosGestion;
        connection c_pms_generador connect gestionEnergiaPMS.enlaceGenerador to generadorElectrico.datosGestion;
        connection c_pms_baterias connect gestionEnergiaPMS.enlaceBaterias to packBateriasTraccion.datosGestion;
        connection c_pms_distribucion connect gestionEnergiaPMS.enlaceDistribucion to distribucionPotencia.datosGestion;
        connection c_pms_convertidor connect gestionEnergiaPMS.enlaceConvertidor to convertidorBajaTension.datosGestion;
        connection c_pms_exportacion connect gestionEnergiaPMS.enlaceExportacion to moduloExportacionPotencia.datosGestion;

        // Enlaces con los puertos de contorno de la planta motriz
        binding b_salida_traccion bind powerOutputTraction = distribucionPotencia.salidaTraccion;
        binding b_salida_avionica bind powerOutputAvionics = convertidorBajaTension.salidaBajaTension;
        binding b_salida_carga bind powerOutputPayload = moduloExportacionPotencia.salidaPotencia;
        binding b_bus_control bind controlBus = gestionEnergiaPMS.busExterno;
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
