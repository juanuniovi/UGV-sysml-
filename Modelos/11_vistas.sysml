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
    private import SistemaUGV::*;
    private import ComportamientoUGV::*;

    // Vista 1: Estructura general del Sistema de Interés Completo - SoI (equivalente a BDD)
    view vistaEstructuraSoI : GeneralView {
        doc /* Muestra la jerarquía de partes y puertos del Sistema UGV Pesado Dual completo (Vehículo + PMP + CPT + UAV + Carga de Pago) */
        expose SistemaUGVPesadoDual;
        filter @SysML::PartUsage or @SysML::PartDefinition
            or @SysML::PortUsage or @SysML::PortDefinition;
    }

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
        doc /* Muestra conjuntamente las dos partes (control y navegacion) con sus bloques internos (computador de autonomía y sus tres subsistemas ROS 2, frenado, LiDAR, radar, visión por computador, cámaras, detección/evasión y odometría VIO), sus puertos y conexiones (RGEN-09, RNAV-01, ROPE-05, ROPE-06, RGEN-17) */
        expose SistemaUGV::PlataformaUGV::control;
        expose SubsistemaControl::SistemaControl::computadorAutonomia;
        expose SistemaUGV::PlataformaUGV::navegacion;
        expose SistemaUGV::PlataformaUGV::comunicaciones;
        expose SistemaUGV::PlataformaUGV::c_nav_obstaculos_ctrl;
        expose SistemaUGV::PlataformaUGV::c_nav_vio_ctrl;
        expose SistemaUGV::PlataformaUGV::c_comms_modo_nav;
        expose SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl;
        expose SistemaUGV::PlataformaUGV::c_bus_comms_control;
        filter @SysML::PartUsage or @SysML::PortUsage
            or @SysML::ConnectionUsage or @SysML::BindingConnectorAsUsage;
    }

    // Vista 8: Interconexiones conjuntas de los Subsistemas 4.1 Control y 4.2 Navegación (equivalente a IBD)
    view vistaConexionesNavegacionControl : InterconnectionView {
        doc /* Muestra conjuntamente ambas partes (control y navegacion), el interior de computadorAutonomia (fusión y estado, planificación y evaluación, y supervisor de seguridad), sus puertos y las conexiones tanto internas como con Comunicaciones y entre Navegación y Control (RGEN-09, RNAV-01, RGEN-17) */
        expose SistemaUGV::PlataformaUGV::control;
        expose SubsistemaControl::SistemaControl::computadorAutonomia;
        expose SistemaUGV::PlataformaUGV::navegacion;
        expose SistemaUGV::PlataformaUGV::comunicaciones;
        expose SistemaUGV::PlataformaUGV::c_nav_obstaculos_ctrl;
        expose SistemaUGV::PlataformaUGV::c_nav_vio_ctrl;
        expose SistemaUGV::PlataformaUGV::c_comms_modo_nav;
        expose SistemaUGV::PlataformaUGV::c_comms_frenado_ctrl;
        expose SistemaUGV::PlataformaUGV::c_bus_comms_control;
    }
}
