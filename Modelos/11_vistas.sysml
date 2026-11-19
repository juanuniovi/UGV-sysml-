package VistasUGV {
    doc /* Definición de vistas y diagramas arquitectónicos del Sistema UGV Pesado Dual */
    private import StandardViewDefinitions::*;
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
    private import SubsistemaIluminacion::*;
    private import SistemaUGV::*;
    private import ComportamientoUGV::*;



    // Vista 2: Estructura interna de la Plataforma Vehículo UGV (equivalente a BDD)
    view vistaEstructuraPlataforma : GeneralView {
        doc /* Muestra la descomposición interna de la plataforma terrestre (Barcaza, Rodaje, Planta Motriz, GNC y Comunicaciones) */
        expose PlataformaUGV;
        filter @SysML::PartUsage or @SysML::PartDefinition
            or @SysML::PortUsage or @SysML::PortDefinition;
    }

    // Vista 3: Interconexiones del Sistema de Interés Completo - SoI (equivalente a IBD)
    view vistaConexionesSoI : InterconnectionView {
        doc /* Muestra los enlaces RF tácticos, acople de cargas de pago y conexiones del UAV cenital con el vehículo */
        expose SistemaUGVPesadoDual;
    }

    // Vista 4: Interconexiones internas de la Plataforma Vehículo UGV (equivalente a IBD)
    view vistaConexionesPlataforma : InterconnectionView {
        doc /* Muestra las conexiones mecánicas sobre barcaza, distribución eléctrica y buses de datos internos del vehículo */
        expose PlataformaUGV;
    }

    // Vista 5: Requisitos recopilados automáticamente de todos los paquetes del UGV
    // Nota: Si en el futuro se crea un paquete nuevo, añadir aquí 'expose NuevoPaquete::*;'
    view vistaRequisitos : GeneralView {
        doc /* Recopila automáticamente cualquier requisito definido en los paquetes de subsistemas y sistema del UGV */
        expose SubsistemaBarcaza::*;
        expose SubsistemaTrenRodaje::*;
        expose SubsistemaPlantaMotriz::*;
        expose SubsistemaControl::*;
        expose SubsistemaNavegacion::*;
        expose SubsistemaComunicaciones::*;
        expose SubsistemaEstacionesControl::*;
        expose SubsistemaUAVCenital::*;
        expose SubsistemaCargasPago::*;
        expose SubsistemaIluminacion::*;
        expose SistemaUGV::*;
        filter @SysML::RequirementDefinition
            or @SysML::RequirementUsage
            or @SysML::SatisfyRequirementUsage;
    }

    // Vista 6: Máquina de estados de los modos operacionales del UGV (equivalente a STM)
    view vistaModosOperacion : StateTransitionView {
        doc /* Muestra los estados operativos de misión del UGV (Apagado, Teleoperado, Autónomo, Sigiloso y Degradado) y sus transiciones */
        expose ComportamientoUGV::ModosOperacionUGVStateMachine;
    }

    // Vista 7: Estructura conjunta de los Subsistemas 4.1 Control y 4.2 Navegación (equivalente a BDD)
    view vistaEstructuraNavegacionControl : GeneralView {
        doc /* Muestra conjuntamente las dos partes (control y navegacion) con sus bloques internos (computador de autonomía y sus tres subsistemas ROS 2, frenado, subpartes camaras y sensores con LiDAR, radar, transductores de rodaje, cámaras 360 con profundidad, cámaras laterales y térmica de puntos calientes, visión por computador, detección/evasión y odometría VIO), subsistema de iluminacion 360, sus puertos y conexiones (RGEN-09, RNAV-01, ROPE-05, ROPE-06, RGEN-17, RGEN-20, RGEN-22) */
        expose SistemaUGV::PlataformaUGV::control;
        expose SistemaUGV::PlataformaUGV::navegacion;
        expose SistemaUGV::PlataformaUGV::iluminacion;
        expose SistemaUGV::PlataformaUGV::comunicaciones;
        expose SistemaUGV::PlataformaUGV::c_nav_obstaculos_ctrl;
        expose SistemaUGV::PlataformaUGV::c_nav_vio_ctrl;
        expose SistemaUGV::PlataformaUGV::c_comms_modo_nav;
        expose SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl;
        expose SistemaUGV::PlataformaUGV::c_nav_video_comms;
        expose SistemaUGV::PlataformaUGV::c_nav_rodaje_comms;
        expose SistemaUGV::PlataformaUGV::c_bus_comms_control;
        expose SistemaUGV::PlataformaUGV::c_control_iluminacion;
        filter @SysML::PartUsage or @SysML::PortUsage
            or @SysML::ConnectionUsage or @SysML::BindingConnectorAsUsage;
    }

    // Vista 8: Interconexiones conjuntas de los Subsistemas 4.1 Control y 4.2 Navegación (equivalente a IBD)
    view vistaConexionesNavegacionControl : InterconnectionView {
        doc /* Muestra conjuntamente las partes de control, navegacion e iluminacion, el interior de computadorAutonomia y de las subpartes camaras y sensores, sus puertos y las conexiones tanto internas como con Comunicaciones y entre Navegación y Control (RGEN-09, RNAV-01, RGEN-17, RGEN-20, RGEN-22) */
        expose SistemaUGV::PlataformaUGV::control;
        expose SistemaUGV::PlataformaUGV::navegacion;
        expose SistemaUGV::PlataformaUGV::iluminacion;
        expose SistemaUGV::PlataformaUGV::comunicaciones;
        expose SistemaUGV::PlataformaUGV::c_nav_obstaculos_ctrl;
        expose SistemaUGV::PlataformaUGV::c_nav_vio_ctrl;
        expose SistemaUGV::PlataformaUGV::c_comms_modo_nav;
        expose SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl;
        expose SistemaUGV::PlataformaUGV::c_nav_video_comms;
        expose SistemaUGV::PlataformaUGV::c_nav_rodaje_comms;
        expose SistemaUGV::PlataformaUGV::c_bus_comms_control;
        expose SistemaUGV::PlataformaUGV::c_control_iluminacion;
    }

    // Vista 9: Interconexiones completas del Sistema de Comunicaciones (equivalente a IBD de extremo a extremo)
    view vistaConexionesComunicaciones : InterconnectionView {
        doc /* Muestra la topología completa de comunicaciones entre las estaciones externas (Puesto de Mando PMP, Consola CPT, UAV Cenital) y el UGV, con sus enlaces de RF, cámaras de navegación y computador/frenado de control (RCOM-01..03, RSW-06, RGEN-09, RGEN-17, RGEN-20) */
        expose SistemaUGV::SistemaUGVPesadoDual::puestoMando;
        expose SistemaUGV::SistemaUGVPesadoDual::consolaCPT;
        expose SistemaUGV::SistemaUGVPesadoDual::uavCenital;
        expose SistemaUGV::SistemaUGVPesadoDual::vehiculo;
        expose SistemaUGV::SistemaUGVPesadoDual::c_rf_los;
        expose SistemaUGV::SistemaUGVPesadoDual::c_rf_blos;
        expose SistemaUGV::SistemaUGVPesadoDual::c_rf_uav;
        expose SistemaUGV::PlataformaUGV::comunicaciones;
        expose SistemaUGV::PlataformaUGV::navegacion;
        expose SistemaUGV::PlataformaUGV::control;
        expose SistemaUGV::PlataformaUGV::c_nav_video_comms;
        expose SistemaUGV::PlataformaUGV::c_bus_comms_control;
        expose SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl;
        expose SistemaUGV::PlataformaUGV::c_comms_modo_nav;
    }

    // Vista 10: Interconexión interna detallada del Subsistema de Comunicaciones Embarcado (IBD interno)
    view vistaInternaComunicaciones : InterconnectionView {
        doc /* Muestra la arquitectura interna de transceptores (LOS, BLOS, CNR), módulo criptográfico COMSEC, gestor de redundancia QoS/PACE, supervisor watchdog de frenado failsafe y matriz de antenas del UGV (RCOM-01..03, RSW-06, RGEN-09, RGEN-17, RLT1-10) */
        expose SubsistemaComunicaciones::SistemaComunicacionesEmbarcado;
    }

    // Vista 10: Interconexiones internas de la Planta Motriz Hibrida (equivalente a IBD)
    view vistaConexionesPlantaMotriz : InterconnectionView {
        doc /* Muestra los bloques generales de la planta motriz hibrida serie y sus flujos internos de combustible, eje mecanico, potencia electrica y datos de gestion del PMS (RGEN-11, RGEN-13, RGEN-19, RLT1-09) */
        expose SubsistemaPlantaMotriz::PlantaMotrizHibrida;
    }

    // Vista 11: Estructura de la Planta Motriz Hibrida (equivalente a BDD)
    view vistaEstructuraPlantaMotriz : GeneralView {
        doc /* Muestra la jerarquia de bloques generales de la planta motriz hibrida y sus puertos */
        expose SubsistemaPlantaMotriz::*;
        filter @SysML::PartUsage or @SysML::PartDefinition
            or @SysML::PortUsage or @SysML::PortDefinition;
    }

    // Vista 12: Planta Motriz integrada con los subsistemas que alimenta (equivalente a IBD)
    view vistaConexionesPlantaMotrizSistema : InterconnectionView {
        doc /* Muestra la planta motriz junto con control, navegacion, comunicaciones, carga de pago y UAV, y las conexiones de potencia y datos entre ellos. El montaje en barcaza (c_barcaza_powertrain) y la traccion hacia el tren de rodaje (c_power_traction) se muestran en vistaConexionesPlataforma */
        expose SistemaUGV::PlataformaUGV::plantaMotriz;
        expose SistemaUGV::PlataformaUGV::control;
        expose SistemaUGV::PlataformaUGV::navegacion;
        expose SistemaUGV::PlataformaUGV::comunicaciones;
        expose SistemaUGV::PlataformaUGV::iluminacion;
        expose SistemaUGV::PlataformaUGV::c_power_control;
        expose SistemaUGV::PlataformaUGV::c_power_navegacion;
        expose SistemaUGV::PlataformaUGV::c_power_comms;
        expose SistemaUGV::PlataformaUGV::c_power_iluminacion;
        expose SistemaUGV::PlataformaUGV::c_pms_control;
        expose SistemaUGV::SistemaUGVPesadoDual::cargaPagoMision;
        expose SistemaUGV::SistemaUGVPesadoDual::uavCenital;
        expose SistemaUGV::SistemaUGVPesadoDual::c_payload_power;
        expose SistemaUGV::SistemaUGVPesadoDual::c_uav_power;
    }
}
