package SubsistemaComunicaciones {
    doc /* Sistema de comunicaciones tacticas embarcadas (RCOM-01..03, RSW-06) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // =========================================================================
    // 1. Items de Datos de Flujo para el Enlace LOS (Grupo 1)
    // =========================================================================
    item def ComandoTelemandoLOS {
        doc /* Consignas de telemando directo procedentes de la Consola CPT (joysticks de direccion y velocidad) */
    }

    item def TelemetriaVideoLOS {
        doc /* Retransmision de video de conduccion en tiempo real y estado basico del UGV hacia la CPT */
    }

    // =========================================================================
    // 2. Definicion de la Parte Transceptora LOS (Grupo 1)
    // =========================================================================
    part def RadioEnlaceTacticoLOS {
        doc /* Transceptor de radiofrecuencia tactico para telemando en linea de vista (RCOM-01) */
        
        // Atributos cuantitativos de enlace
        attribute latenciaMaximaMs : Real = 100.0; // Latencia ultrabaja para control reactivo
        attribute alcanceNominalKm : Real = 1.5;   // Alcance visual directo con la consola de mano
        attribute frecuenciaGhz : Real = 2.4;      // Banda tactica de operacion directa

        // Puertos internos del modulo
        port rfPort : RFPort;
        port dataBusInternal : DataBusPort;
    }

    // =========================================================================
    // 3. Requisito Formal del Pliego (RCOM-01)
    // =========================================================================
    requirement def ReqEnlaceTacticoLOS {
        doc /* El UGV debe disponer de un enlace de radiofrecuencia tactico en linea de vista (LOS)
               con la Consola Portable de Operador (CPT) para telemando con latencia <= 100 ms (RCOM-01). */
        require constraint { true }
    }

    // =========================================================================
    // 4. Bloque Principal del Subsistema de Comunicaciones
    // =========================================================================
    part def SistemaComunicacionesEmbarcado {
        doc /* Subsistema de comunicaciones embarcado del UGV */

        // Componente formalizado del Grupo 1
        part radioEnlaceTacticoLOS : RadioEnlaceTacticoLOS;

        // Componentes reservados para los siguientes grupos
        part radioEnlaceTacticoBLOS; // Grupo 2: Mando a larga distancia y rele con UAV
        part moduloCifradoCOMSEC;    // Grupo 3: Cifrado y ciberseguridad
        part sistemaAntenas;         // Grupo 6: Antenas y mastil en barcaza

        // Puertos externos de contorno del subsistema
        port chassisMount : MechanicalMountPort; // Fijacion y masa en chasis
        port powerInput : ElectricalPowerPort;   // Alimentacion desde planta motriz
        port dataBus : DataBusPort;             // Bus digital hacia GNC (CAN / Ethernet militar)
        port salidaModoDeteccion : DataBusPort; // Control de emisiones hacia navegacion (RGEN-09)
        port salidaInhabilitacionFrenado : DataBusPort; // Enlace de seguridad hacia control (RGEN-17)
        port entradaVideoTeleoperacion : DataBusPort;   // Flujo de video desde navegacion
        port entradaEstadoRodaje : DataBusPort;         // Telemetria de rodaje
        port rfPortLOS : RFPort;                // Puerto RF conectado con Consola CPT
        port rfPortBLOS : RFPort;               // Puerto RF conectado con Puesto de Mando (PMP)

        // Trazabilidad formal del pliego: satisfaccion de RCOM-01
        satisfy requirement : ReqEnlaceTacticoLOS by radioEnlaceTacticoLOS;
    }
}
