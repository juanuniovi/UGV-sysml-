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

    // =========================================================================
    // 4. FASE 0 - ANALISIS DE CAJA NEGRA (Black Box) de la planta motriz
    //    Requirements (necesidades) / Structure (contexto) /
    //    Behavior (casos de uso) / Parameters (MoEs)
    //    Sin soluciones tecnicas: no referencia la estructura interna anterior.
    // =========================================================================
    package CajaNegraPlantaMotriz {
        doc /* Fase 0 (caja negra) de la planta motriz hibrida (Issue #4): mision, entorno y actores
             * de la planta vista como un unico bloque, sin hablar de soluciones tecnicas internas.
             * Fuente: Anexo I del pliego, clausulas RGEN-06..19 y RLT1-01..14 auditadas el 2026-11-19. */
        private import ScalarValues::*;
        private import TiposBase::*;

        // ---------------------------------------------------------------------
        // 4.1 REQUIREMENTS: partes interesadas y necesidades (Stakeholder Needs)
        // ---------------------------------------------------------------------
        part def OperadorMision {
            doc /* Operador humano que planifica y conduce la mision desde el Puesto de Mando Portable (PMP)
                 * o la Consola CPT. No actua sobre la planta directamente: ordena modos a traves de Control (RGEN-01). */
            port mando : ~DataBusPort;
        }

        part def MantenedorPrimerEscalon {
            doc /* Personal de mantenimiento de primer escalon: repostaje, puesta a carga de baterias,
                 * diagnostico e intervenciones sencillas sobre la planta (RGEN-07, RGEN-08). */
            port acceso : ~PuertoAccesoMantenimiento;
        }

        part def LogisticaCombustible {
            doc /* Cadena logistica que suministra el biocombustible (HVO) en la zona de operaciones
                 * y opera el medio de suministro externo (RGEN-11). */
        }

        part def ClienteContratante {
            doc /* Organismo contratante (CDTI / usuario final militar o civil) que fija la mision,
                 * las prestaciones exigidas y los criterios de aceptacion del pliego. */
        }

        requirement def NecMovilidadHibridaBiocombustible {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder cliente : ClienteContratante;
            doc /* El cliente necesita que el UGV se mueva con una propulsion hibrida (baterias + motor electrico
                 * + motor de combustion) capaz de funcionar con biocombustible 100 % (RGEN-11). */
        }

        requirement def NecRecargaAutonomaBaterias {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder operador : OperadorMision;
            doc /* El operador necesita que las baterias se recarguen solas durante la mision, con el motor de
                 * combustion y con la energia de las frenadas, sin depender de infraestructura (RGEN-12). */
        }

        requirement def NecOperacionSigilosa {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder operador : OperadorMision;
            doc /* El operador necesita poder mover el UGV solo con energia electrica, sin motor de combustion,
                 * para operar con firma termica y acustica reducida (RGEN-13). */
        }

        requirement def NecAutonomiaMision {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder operador : OperadorMision;
            doc /* El operador necesita que la energia embarcada alcance para toda la mision: autonomia total de
                 * 8 h o 400 km (RGEN-14) y autonomia en modo electrico de 2 h o 100 km (RGEN-15). */
        }

        requirement def NecPotenciaMovilidadYArrastre {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder operador : OperadorMision;
            doc /* El operador necesita potencia suficiente para la movilidad exigida y para arrastrar un remolque
                 * de hasta 3000 kg: potencia total de propulsion de al menos 140 kW (RLT1-09, RGEN-10). */
        }

        requirement def NecAlimentacionEquiposEmbarcados {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder operador : OperadorMision;
            doc /* El operador necesita que los equipos de control, navegacion, comunicaciones e iluminacion, y las
                 * cargas de pago y el UAV acoplados en los puntos de interfaz, reciban energia (RGEN-01, RGEN-28). */
        }

        requirement def NecExportacionEnergia {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder cliente : ClienteContratante;
            doc /* [OPCIONAL en el pliego] El cliente desea que el UGV pueda exportar energia a sistemas externos a la
                 * plataforma con una capacidad de generacion de al menos 120 kW (RGEN-19). */
        }

        requirement def NecRecargaEnchufable {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder mantenedor : MantenedorPrimerEscalon;
            stakeholder logistica : LogisticaCombustible;
            doc /* [OPCIONAL en el pliego] Mantenimiento y logistica desean poder recargar las baterias enchufando
                 * el UGV a puntos de recarga externos (movilidad hibrida enchufable, RGEN-18). */
        }

        requirement def NecRepostajeYMantenimientoSencillo {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder mantenedor : MantenedorPrimerEscalon;
            stakeholder logistica : LogisticaCombustible;
            doc /* Mantenimiento y logistica necesitan repostar y mantener la planta de forma sencilla y economica
                 * (RGEN-07), con la minima variedad de herramientas de primer escalon ([OPCIONAL] RGEN-08). */
        }

        requirement def NecRobustezAmbientalYVadeo {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder cliente : ClienteContratante;
            doc /* El cliente necesita que la planta resista temperaturas extremas, lluvia, humedad, corrosion y
                 * radiacion solar (RGEN-06) y siga funcionando al vadear 0,75 m en agua dulce o salada (RLT1-10). */
        }

        requirement def NecRemolcadoConPlantaInactiva {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder operador : OperadorMision;
            doc /* El operador necesita que el UGV pueda ser remolcado por otros vehiculos a al menos 65 km/h,
                 * tambien con la planta motriz parada o averiada (RGEN-16). */
        }

        requirement def NecContencionMasa {
            subject planta : PlantaMotrizCajaNegra;
            stakeholder cliente : ClienteContratante;
            doc /* El cliente necesita que el UGV en orden de mision no supere 9000 kg (RLT1-08); la planta motriz
                 * debe contribuir a ese limite. El pliego no asigna una cuota de masa a la planta. */
        }

        // ---------------------------------------------------------------------
        // 4.2 STRUCTURE: items de intercambio, interfaces externas y contexto
        // ---------------------------------------------------------------------
        // --- Items de intercambio con el exterior (materia, energia, informacion) ---
        item def Biocombustible { doc /* Materia: combustible HVO / biocombustible 100 % suministrado desde el exterior (RGEN-11) */ }
        item def AireAdmision { doc /* Materia: aire tomado de la atmosfera para la combustion */ }
        item def GasesEscape { doc /* Materia: gases de combustion expulsados a la atmosfera */ }
        item def EnergiaElectrica { doc /* Energia: potencia electrica intercambiada con consumidores, tren de rodaje o red externa */ }
        item def CalorResidual { doc /* Energia: calor disipado al entorno; determina la firma termica (RGEN-13) */ }
        item def EmisionAcustica { doc /* Energia: ruido emitido al entorno; determina la firma acustica (RGEN-13) */ }
        item def OrdenModoEnergia { doc /* Informacion: orden de modo energetico (hibrido, solo electrico, exportacion, parada) desde Control */ }
        item def EstadoEnergia { doc /* Informacion: estado de energia (carga, combustible, modo activo, potencia disponible) hacia Control */ }
        item def AlarmaEnergia { doc /* Informacion: alarma o aviso de fallo de la planta (bateria agotada, sin combustible, entrada de agua) */ }

        // --- Puertos de interfaz externa propios de la caja negra ---
        port def PuertoBocaRepostaje {
            doc /* Interfaz de materia: boca de llenado por la que entra el biocombustible (RGEN-11) */
            in item combustible : Biocombustible;
        }

        port def PuertoAtmosfera {
            doc /* Interfaz de materia y energia con la atmosfera: admision de aire, escape, calor y ruido (firma, RGEN-13) */
            in item aire : AireAdmision;
            out item escape : GasesEscape;
            out item calor : CalorResidual;
            out item ruido : EmisionAcustica;
        }

        port def PuertoExposicionAmbiental {
            doc /* Interfaz de exposicion al entorno: temperatura, lluvia, humedad, corrosion, radiacion solar (RGEN-06)
                 * y agua de vadeo dulce o salada hasta 0,75 m (RLT1-10). No transporta flujos utiles. */
        }

        port def PuertoAccesoMantenimiento {
            doc /* Interfaz de acceso humano para mantenimiento de primer escalon: diagnostico, alarmas e intervencion (RGEN-07) */
            out item diagnostico : EstadoEnergia;
            out item alarmas : AlarmaEnergia;
        }

        // --- Sistema de interes (SoI) visto como caja negra ---
        part def PlantaMotrizCajaNegra {
            doc /* Planta motriz hibrida vista como caja negra (System of Interest).
                 * DENTRO de la frontera: convertir combustible en electricidad, almacenar energia y gestionarla y
                 * distribuirla hacia los consumidores.
                 * FUERA de la frontera: los motores de traccion por rueda (RLT1-04, tren de rodaje), el control de mision,
                 * la avionica, las cargas de pago, el UAV, los puntos de recarga, la logistica de combustible y el entorno. */

            // Energia
            port potenciaTraccion : ElectricalPowerPort;   // Bidireccional: entrega traccion y recibe energia regenerada en frenadas (RGEN-12)
            port potenciaAvionica : ElectricalPowerPort;   // Control, navegacion, comunicaciones e iluminacion
            port potenciaCargaPago : ElectricalPowerPort;  // Cargas de pago y recarga del UAV (RGEN-28)
            port exportacionExterna : ElectricalPowerPort; // [OPCIONAL] Consumidores externos a la plataforma (RGEN-19)
            port recargaExterna : ElectricalPowerPort;     // [OPCIONAL] Punto de recarga enchufable (RGEN-18)
            // Materia
            port bocaRepostaje : PuertoBocaRepostaje;      // Entrada de biocombustible (RGEN-11)
            port intercambioAtmosfera : PuertoAtmosfera;   // Aire, escape, calor y ruido (RGEN-13)
            port exposicionAmbiental : PuertoExposicionAmbiental; // RGEN-06, RLT1-10
            // Mecanica
            port fijacionChasis : MechanicalMountPort;     // Montaje en la barcaza
            // Informacion
            port enlaceControl : DataBusPort;              // Ordenes de modo y estado de energia con Control
            port accesoMantenimiento : PuertoAccesoMantenimiento;

            // 4.4 PARAMETERS: medidas de efectividad (MoEs) vistas desde el cliente
            attribute potenciaPropulsionKW : Potencia { @MedidaEfectividad; }           // RLT1-09
            attribute autonomiaTotalHoras : Real { @MedidaEfectividad; }                // RGEN-14 (h)
            attribute autonomiaTotalKm : Real { @MedidaEfectividad; }                   // RGEN-14 (km)
            attribute autonomiaElectricaHoras : Real { @MedidaEfectividad; }            // RGEN-15 (h)
            attribute autonomiaElectricaKm : Real { @MedidaEfectividad; }               // RGEN-15 (km)
            attribute fraccionBiocombustibleAdmisible : Real { @MedidaEfectividad; }    // RGEN-11 (%)
            attribute recargaPorMotorYRegeneracion : Boolean { @MedidaEfectividad; }    // RGEN-12
            attribute potenciaExportableKW : Potencia { @MedidaEfectividad; }           // RGEN-19 [OPCIONAL]
            attribute recargaEnchufable : Boolean { @MedidaEfectividad; }               // RGEN-18 [OPCIONAL]
            attribute profundidadVadeoM : Longitud { @MedidaEfectividad; }              // RLT1-10 (m)
            attribute masaPlantaKg : Masa { @MedidaEfectividad; }                       // RLT1-08 (kg, cuota sin fijar)
        }

        // --- Sistemas externos (representan a otros subsistemas solo por su interfaz) ---
        part def SubsistemaControlExterno {
            doc /* Representa al subsistema de Control (04_1_control.sysml): ordena modos de energia y recibe el estado */
            port enlacePlanta : ~DataBusPort;
            port mandoOperador : DataBusPort;
        }

        part def TrenRodajeExterno {
            doc /* Representa al tren de rodaje (02_tren_rodaje.sysml) con sus motores de traccion por rueda (RLT1-04):
                 * consume potencia de traccion y devuelve energia regenerada en las frenadas (RGEN-12) */
            port potenciaTraccion : ~ElectricalPowerPort;
        }

        part def BarcazaExterna {
            doc /* Representa a la barcaza estructural (01_barcaza.sysml) sobre la que se monta la planta */
            port montaje : ~MechanicalMountPort;
        }

        part def AvionicaExterna {
            doc /* Representa a los consumidores de baja tension: control, navegacion, comunicaciones e iluminacion */
            port alimentacion : ~ElectricalPowerPort;
        }

        part def CargaPagoYUAVExterno {
            doc /* Representa a las cargas de pago (08_cargas_pago.sysml) y a la recarga del UAV cenital (07_uav_cenital.sysml) */
            port alimentacion : ~ElectricalPowerPort;
        }

        part def ConsumidorExterno {
            doc /* [OPCIONAL] Sistema externo a la plataforma que recibe energia exportada (RGEN-19) */
            port alimentacion : ~ElectricalPowerPort;
        }

        part def PuntoRecargaExterno {
            doc /* [OPCIONAL] Punto de recarga externo para la movilidad hibrida enchufable (RGEN-18) */
            port suministro : ~ElectricalPowerPort;
        }

        part def SuministroCombustibleExterno {
            doc /* Medio de suministro de biocombustible (surtidor, bidon o cisterna) operado por la logistica de combustible */
            port boquerel : ~PuertoBocaRepostaje;
        }

        // --- Entorno ---
        part def AgentesAmbientales {
            doc /* Entorno: temperaturas extremas, lluvia, humedad, corrosion y radiacion solar (RGEN-06) */
            port exposicion : ~PuertoExposicionAmbiental;
        }

        part def AguaVadeo {
            doc /* Entorno: agua dulce o salada durante el vadeo sin preparacion de hasta 0,75 m (RLT1-10) */
            port exposicion : ~PuertoExposicionAmbiental;
        }

        part def Atmosfera {
            doc /* Entorno: aire de admision y receptor del escape, el calor y el ruido (firma termica y acustica, RGEN-13) */
            port intercambio : ~PuertoAtmosfera;
        }

        // --- Contexto: la planta como bloque central rodeada de actores, sistemas externos y entorno ---
        part def ContextoPlantaMotriz {
            doc /* Contexto de la planta motriz hibrida en caja negra (equivalente a BDD/IBD de contexto) */
            part planta : PlantaMotrizCajaNegra;

            // Actores humanos
            part operador : OperadorMision;
            part mantenedor : MantenedorPrimerEscalon;
            part logistica : LogisticaCombustible;

            // Sistemas externos
            part control : SubsistemaControlExterno;
            part trenRodaje : TrenRodajeExterno;
            part barcaza : BarcazaExterna;
            part avionica : AvionicaExterna;
            part cargaPagoYUAV : CargaPagoYUAVExterno;
            part consumidorExterno : ConsumidorExterno;
            part puntoRecarga : PuntoRecargaExterno;
            part suministroCombustible : SuministroCombustibleExterno;

            // Entorno
            part agentesAmbientales : AgentesAmbientales;
            part aguaVadeo : AguaVadeo;
            part atmosfera : Atmosfera;

            // Interfaces de energia
            connection ctx_traccion connect planta.potenciaTraccion to trenRodaje.potenciaTraccion;
            connection ctx_avionica connect planta.potenciaAvionica to avionica.alimentacion;
            connection ctx_carga_pago connect planta.potenciaCargaPago to cargaPagoYUAV.alimentacion;
            connection ctx_exportacion connect planta.exportacionExterna to consumidorExterno.alimentacion;
            connection ctx_recarga connect planta.recargaExterna to puntoRecarga.suministro;
            // Interfaces de materia y entorno
            connection ctx_repostaje connect planta.bocaRepostaje to suministroCombustible.boquerel;
            connection ctx_atmosfera connect planta.intercambioAtmosfera to atmosfera.intercambio;
            connection ctx_ambiente connect planta.exposicionAmbiental to agentesAmbientales.exposicion;
            connection ctx_vadeo connect planta.exposicionAmbiental to aguaVadeo.exposicion;
            // Interfaz mecanica
            connection ctx_montaje connect planta.fijacionChasis to barcaza.montaje;
            // Interfaces de informacion
            connection ctx_control connect planta.enlaceControl to control.enlacePlanta;
            connection ctx_mantenimiento connect planta.accesoMantenimiento to mantenedor.acceso;
            connection ctx_operador_control connect operador.mando to control.mandoOperador;
        }

        // ---------------------------------------------------------------------
        // 4.3 BEHAVIOR: casos de uso (Use Cases) con especificacion textual
        // ---------------------------------------------------------------------
        use case def UC1_PropulsarModoHibrido {
            doc /* Objetivo: entregar potencia de traccion quemando biocombustible mientras se mantienen las baterias.
                 * Actores: Control, Tren de rodaje, Atmosfera.
                 * Precondiciones: planta operativa; combustible disponible; Control ordena el modo hibrido.
                 * Postcondiciones: el tren de rodaje dispone de la potencia demandada y Control conoce el estado de energia.
                 * Escenario principal: 1. Control envia la orden de modo hibrido. 2. La planta confirma el modo.
                 *   3. La planta toma aire y combustible y entrega potencia de traccion al tren de rodaje.
                 *   4. La planta expulsa gases, calor y ruido a la atmosfera. 5. La planta informa periodicamente del estado.
                 * Escenarios alternativos / excepcion: A1. Demanda de pico (pendiente o remolque): la planta suma baterias
                 *   y motor hasta la potencia maxima. E1. Falta de combustible: la planta pasa a entregar solo desde baterias
                 *   y envia una alarma a Control. E2. Entrada de agua durante el vadeo: alarma a Control.
                 * Trazabilidad: RGEN-11, RLT1-09, RGEN-10, RLT1-10. */
            subject planta : PlantaMotrizCajaNegra;
            actor control : SubsistemaControlExterno;
            actor trenRodaje : TrenRodajeExterno;
            actor atmosfera : Atmosfera;
            objective { doc /* Mover el UGV con propulsion hibrida y biocombustible 100 % */ }
        }

        use case def UC2_PropulsarModoElectricoSigiloso {
            doc /* Objetivo: mover el UGV solo con baterias, sin motor de combustion, con firma termica y acustica reducida.
                 * Actores: Control, Tren de rodaje.
                 * Precondiciones: carga de baterias suficiente; Control ordena el modo puramente electrico.
                 * Postcondiciones: el tren de rodaje recibe potencia solo de baterias y no hay escape de gases.
                 * Escenario principal: 1. Control envia la orden de modo solo electrico. 2. La planta confirma o rechaza
                 *   segun la carga disponible. 3. La planta detiene la combustion. 4. La planta entrega potencia de traccion
                 *   solo desde baterias. 5. La planta informa periodicamente del estado de carga y de la autonomia restante.
                 * Escenarios alternativos / excepcion: A1. Carga insuficiente al recibir la orden: la planta rechaza el modo
                 *   e informa del estado. E1. Bateria agotada durante la mision: la planta avisa a Control con una alarma y
                 *   solicita el paso a modo hibrido.
                 * Trazabilidad: RGEN-13, RGEN-15. */
            subject planta : PlantaMotrizCajaNegra;
            actor control : SubsistemaControlExterno;
            actor trenRodaje : TrenRodajeExterno;
            objective { doc /* Operar sigilosamente con propulsion puramente electrica */ }
        }

        use case def UC3_RecargarBateriasEnMarcha {
            doc /* Objetivo: recuperar carga de baterias durante la mision sin infraestructura externa.
                 * Actores: Control, Tren de rodaje.
                 * Precondiciones: planta en modo hibrido o vehiculo frenando.
                 * Postcondiciones: el estado de carga de las baterias aumenta y Control lo conoce.
                 * Escenario principal: 1. El tren de rodaje devuelve energia regenerada en la frenada. 2. La planta la
                 *   almacena. 3. En modo hibrido, la planta recarga ademas con el motor de combustion. 4. La planta informa
                 *   del estado de carga.
                 * Escenarios alternativos / excepcion: A1. Baterias llenas: la planta deja de aceptar energia regenerada e
                 *   informa a Control. E1. Fallo de recarga: alarma a Control.
                 * Trazabilidad: RGEN-12. */
            subject planta : PlantaMotrizCajaNegra;
            actor control : SubsistemaControlExterno;
            actor trenRodaje : TrenRodajeExterno;
            objective { doc /* Recargar baterias con el motor de combustion y la frenada regenerativa */ }
        }

        use case def UC4_AlimentarEquiposEmbarcados {
            doc /* Objetivo: mantener alimentados la avionica, las cargas de pago y la recarga del UAV.
                 * Actores: Avionica, Carga de pago y UAV.
                 * Precondiciones: planta operativa en cualquier modo.
                 * Postcondiciones: los equipos embarcados reciben la energia que demandan.
                 * Escenario principal: 1. Los equipos demandan energia. 2. La planta la entrega por sus salidas de avionica
                 *   y de carga de pago. 3. La planta informa del consumo a Control.
                 * Escenarios alternativos / excepcion: A1. Energia limitada: se prioriza la avionica frente a las cargas de
                 *   pago. E1. Sobreconsumo de una carga: la planta la desconecta y envia una alarma.
                 * Trazabilidad: RGEN-01, RGEN-28. */
            subject planta : PlantaMotrizCajaNegra;
            actor avionica : AvionicaExterna;
            actor cargaPagoYUAV : CargaPagoYUAVExterno;
            objective { doc /* Alimentar los equipos y cargas embarcados */ }
        }

        use case def UC5_ExportarEnergia {
            doc /* [OPCIONAL en el pliego] Objetivo: entregar energia a un sistema externo a la plataforma.
                 * Actores: Operador (a traves de Control), Consumidor externo.
                 * Precondiciones: consumidor externo conectado; el operador solicita la exportacion por medio de Control.
                 * Postcondiciones: el consumidor recibe energia y la movilidad del UGV queda garantizada.
                 * Escenario principal: 1. Control envia la orden de exportar. 2. La planta acepta. 3. La planta entrega
                 *   energia al consumidor externo. 4. La planta informa periodicamente del estado. 5. Control ordena el fin de
                 *   la exportacion y la planta la detiene.
                 * Escenarios alternativos / excepcion: E1. La exportacion comprometeria la traccion o la autonomia: la planta
                 *   rechaza o limita la exportacion e informa del estado a Control.
                 * Trazabilidad: RGEN-19. */
            subject planta : PlantaMotrizCajaNegra;
            actor operador : OperadorMision;
            actor control : SubsistemaControlExterno;
            actor consumidor : ConsumidorExterno;
            objective { doc /* Exportar energia a sistemas externos (objetivo: 120 kW) */ }
        }

        use case def UC6_RecargarDesdePuntoExterno {
            doc /* [OPCIONAL en el pliego] Objetivo: recargar las baterias enchufando el UGV a un punto de recarga.
                 * Actores: Mantenedor, Punto de recarga.
                 * Precondiciones: UGV detenido; punto de recarga compatible disponible.
                 * Postcondiciones: baterias recargadas y punto de recarga desconectado.
                 * Escenario principal: 1. El mantenedor conecta el punto de recarga. 2. La planta acepta la energia y recarga.
                 *   3. La planta muestra el progreso por el acceso de mantenimiento. 4. El mantenedor desconecta al finalizar.
                 * Escenarios alternativos / excepcion: E1. Punto de recarga incompatible o con fallo: la planta rechaza la
                 *   recarga y muestra una alarma.
                 * Trazabilidad: RGEN-18. */
            subject planta : PlantaMotrizCajaNegra;
            actor mantenedor : MantenedorPrimerEscalon;
            actor puntoRecarga : PuntoRecargaExterno;
            objective { doc /* Recargar baterias desde la red (movilidad hibrida enchufable) */ }
        }

        use case def UC7_RepostarYMantener {
            doc /* Objetivo: reponer biocombustible y realizar el mantenimiento de primer escalon.
                 * Actores: Mantenedor, Logistica de combustible, Suministro de combustible.
                 * Precondiciones: UGV detenido y en zona segura; biocombustible disponible.
                 * Postcondiciones: deposito repuesto y planta diagnosticada sin alarmas pendientes.
                 * Escenario principal: 1. La logistica dispone el suministro. 2. El mantenedor reposta por la boca de
                 *   repostaje. 3. El mantenedor consulta el diagnostico por el acceso de mantenimiento. 4. El mantenedor
                 *   resuelve las intervenciones de primer escalon.
                 * Escenarios alternativos / excepcion: A1. Combustible no conforme: no se reposta y se registra la incidencia.
                 *   E1. Alarma no resoluble en primer escalon: se escala al siguiente nivel de mantenimiento.
                 * Trazabilidad: RGEN-11, RGEN-07, RGEN-08. */
            subject planta : PlantaMotrizCajaNegra;
            actor mantenedor : MantenedorPrimerEscalon;
            actor logistica : LogisticaCombustible;
            actor suministro : SuministroCombustibleExterno;
            objective { doc /* Repostar y mantener la planta de forma sencilla */ }
        }

        use case def UC8_SoportarRemolcadoInactivo {
            doc /* Objetivo: permitir que otro vehiculo remolque el UGV con la planta parada o averiada.
                 * Actores: Operador, Tren de rodaje.
                 * Precondiciones: planta parada o averiada; el operador decide remolcar.
                 * Postcondiciones: el UGV llega remolcado a destino sin danos en la planta.
                 * Escenario principal: 1. El operador ordena el modo de remolcado. 2. La planta queda inactiva y no ofrece
                 *   resistencia a la traccion. 3. El tren de rodaje gira arrastrado hasta 65 km/h.
                 * Escenarios alternativos / excepcion: A1. Planta parcialmente operativa: la planta admite la energia regenerada
                 *   en el remolcado sin sobrecargar las baterias. E1. Planta sin comunicacion: se queda inactiva por defecto.
                 * Trazabilidad: RGEN-16. */
            subject planta : PlantaMotrizCajaNegra;
            actor operador : OperadorMision;
            actor trenRodaje : TrenRodajeExterno;
            objective { doc /* Ser remolcado con la planta inactiva */ }
        }

        // --- Secuencias de contexto caja negra (mensajes que entran y salen de la planta) ---
        occurrence def SecuenciaUC1_ModoHibrido {
            doc /* Secuencia caja negra de UC1: solo participantes externos y la planta */
            part control : SubsistemaControlExterno;
            part planta : PlantaMotrizCajaNegra;
            part trenRodaje : TrenRodajeExterno;
            part atmosfera : Atmosfera;

            message ordenHibrido of OrdenModoEnergia from control to planta;
            message confirmacionModo of EstadoEnergia from planta to control;
            message tomaAire of AireAdmision from atmosfera to planta;
            message entregaTraccion of EnergiaElectrica from planta to trenRodaje;
            message energiaRegenerada of EnergiaElectrica from trenRodaje to planta;
            message expulsionEscape of GasesEscape from planta to atmosfera;
            message estadoPeriodico of EstadoEnergia from planta to control;

            first ordenHibrido then confirmacionModo;
            first confirmacionModo then tomaAire;
            first tomaAire then entregaTraccion;
            first entregaTraccion then energiaRegenerada;
            first energiaRegenerada then expulsionEscape;
            first expulsionEscape then estadoPeriodico;
        }

        occurrence def SecuenciaUC2_ModoElectricoSigiloso {
            doc /* Secuencia caja negra de UC2: orden de modo, confirmacion o rechazo, traccion solo desde baterias,
                 * estado periodico y, como excepcion, alarma de bateria agotada */
            part control : SubsistemaControlExterno;
            part planta : PlantaMotrizCajaNegra;
            part trenRodaje : TrenRodajeExterno;

            message ordenSoloElectrico of OrdenModoEnergia from control to planta;
            message confirmacionORechazo of EstadoEnergia from planta to control;
            message entregaTraccionBaterias of EnergiaElectrica from planta to trenRodaje;
            message estadoPeriodico of EstadoEnergia from planta to control;
            message alarmaBateriaAgotada of AlarmaEnergia from planta to control;

            first ordenSoloElectrico then confirmacionORechazo;
            first confirmacionORechazo then entregaTraccionBaterias;
            first entregaTraccionBaterias then estadoPeriodico;
            first estadoPeriodico then alarmaBateriaAgotada;
        }

        occurrence def SecuenciaUC5_ExportarEnergia {
            doc /* [OPCIONAL] Secuencia caja negra de UC5: orden de exportar, aceptacion, entrega, estado y fin */
            part control : SubsistemaControlExterno;
            part planta : PlantaMotrizCajaNegra;
            part consumidor : ConsumidorExterno;

            message ordenExportar of OrdenModoEnergia from control to planta;
            message aceptacionExportacion of EstadoEnergia from planta to control;
            message entregaEnergia of EnergiaElectrica from planta to consumidor;
            message estadoPeriodico of EstadoEnergia from planta to control;
            message ordenFinExportacion of OrdenModoEnergia from control to planta;

            first ordenExportar then aceptacionExportacion;
            first aceptacionExportacion then entregaEnergia;
            first entregaEnergia then estadoPeriodico;
            first estadoPeriodico then ordenFinExportacion;
        }

        // ---------------------------------------------------------------------
        // 4.4 PARAMETERS: medidas de efectividad (MoEs), umbral y objetivo
        // ---------------------------------------------------------------------
        metadata def MedidaEfectividad {
            doc /* Marca un atributo como medida de efectividad (MoE): metrica de exito desde la perspectiva del cliente */
        }

        part def MoEsPlantaMotriz {
            doc /* Tabla de MoEs de la planta motriz: umbral (threshold, minimo aceptable segun el pliego) y
                 * objetivo (objective, valor deseable). Un objetivo sin valor esta "sin fijar" (lo decide el equipo).
                 * Candidatas pendientes sin valor en el pliego (a fijar por el equipo): disponibilidad, MTBF y
                 * coste de ciclo de vida (LCC). Tampoco hay cuota de masa de la planta dentro de los 9000 kg (RLT1-08). */
            // Potencia de propulsion (RLT1-09)
            attribute umbralPotenciaPropulsionKW : Potencia = 140.0;
            attribute objetivoPotenciaPropulsionKW : Potencia;            // sin fijar
            // Autonomia total (RGEN-14): 8 h o 400 km
            attribute umbralAutonomiaTotalHoras : Real = 8.0;
            attribute umbralAutonomiaTotalKm : Real = 400.0;
            attribute objetivoAutonomiaTotalHoras : Real;                 // sin fijar
            // Autonomia en modo electrico (RGEN-15): 2 h o 100 km
            attribute umbralAutonomiaElectricaHoras : Real = 2.0;
            attribute umbralAutonomiaElectricaKm : Real = 100.0;
            attribute objetivoAutonomiaElectricaHoras : Real;             // sin fijar
            // Biocombustible (RGEN-11)
            attribute umbralFraccionBiocombustible : Real = 100.0;
            attribute objetivoFraccionBiocombustible : Real = 100.0;
            // Recarga por motor y regeneracion (RGEN-12)
            attribute umbralRecargaPorMotorYRegeneracion : Boolean = true;
            // Exportacion de energia (RGEN-19, OPCIONAL): sin umbral obligatorio
            attribute objetivoPotenciaExportableKW : Potencia = 120.0;
            // Recarga enchufable (RGEN-18, OPCIONAL): sin umbral obligatorio
            attribute objetivoRecargaEnchufable : Boolean = true;
            // Vadeo sin preparacion (RLT1-10)
            attribute umbralProfundidadVadeoM : Longitud = 0.75;
            attribute objetivoProfundidadVadeoM : Longitud;               // sin fijar
            // Masa de la planta (RLT1-08): sin valor en el pliego
            attribute umbralMasaPlantaKg : Masa;                          // sin valor en el pliego; a fijar por el equipo
        }

        requirement def UmbralPotenciaPropulsion {
            subject planta : PlantaMotrizCajaNegra;
            doc /* MoE umbral: la potencia total del sistema de propulsion sera de 140 kW (190 CV) como minimo (RLT1-09). */
            require constraint { planta.potenciaPropulsionKW >= 140.0 }
        }

        requirement def UmbralAutonomiaTotal {
            subject planta : PlantaMotrizCajaNegra;
            doc /* MoE umbral: autonomia total de 8 h de funcionamiento o 400 km como minimo (RGEN-14).
                 * Se respeta la disyuncion "o" del pliego. */
            require constraint { planta.autonomiaTotalHoras >= 8.0 or planta.autonomiaTotalKm >= 400.0 }
        }

        requirement def UmbralAutonomiaElectrica {
            subject planta : PlantaMotrizCajaNegra;
            doc /* MoE umbral: autonomia en modo puramente electrico de 2 h o 100 km como minimo (RGEN-15).
                 * Se respeta la disyuncion "o" del pliego. */
            require constraint { planta.autonomiaElectricaHoras >= 2.0 or planta.autonomiaElectricaKm >= 100.0 }
        }

        requirement def UmbralBiocombustible {
            subject planta : PlantaMotrizCajaNegra;
            doc /* MoE umbral: el motor de combustion podra utilizar biocombustible 100 % (RGEN-11). */
            require constraint { planta.fraccionBiocombustibleAdmisible >= 100.0 }
        }

        requirement def UmbralRecargaPorMotorYRegeneracion {
            subject planta : PlantaMotrizCajaNegra;
            doc /* MoE umbral: baterias recargables por el motor de combustion y por la energia regenerada en las frenadas (RGEN-12). */
            require constraint { planta.recargaPorMotorYRegeneracion }
        }

        requirement def UmbralProfundidadVadeo {
            subject planta : PlantaMotrizCajaNegra;
            doc /* MoE umbral: la planta debe seguir operativa en un vadeo sin preparacion de 0,75 m como minimo,
                 * en agua dulce y salada (RLT1-10). */
            require constraint { planta.profundidadVadeoM >= 0.75 }
        }
    }
}
