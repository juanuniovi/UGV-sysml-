package SubsistemaNavegacionControl {
    doc /* Sistema de Guiado, Navegacion y Control (GNC) y Suite de Sensores (ROPE, RNAV) */
    private import ScalarValues::*;
    private import TiposBase::*;

    part def SistemaNavegacionControl {
        // Computadores y logica de navegacion
        part computadorAutonomia;        // Waypoints georreferenciados y Follow-Me (ROPE-05)
        part moduloDeteccionEvasion;     // Detect & Avoid en tiempo real (ROPE-06)
        part odometriaVisualInercialVIO; // Posicionamiento en GNSS denegado (RNAV-01)
        part moduloFrenadoSeguridad;     // Frenado automatico con override manual (RGEN-17)

        // Sensores de percepcion situacional
        part camarasOpticas360;          // Cobertura visual 360 grados (RGEN-20)
        part camaraTermicaNocturna;      // Deteccion termica e infrarroja (RGEN-22)
        part sensoresLidar;              // Desactivables en modo sigiloso (RGEN-09)

        // Puertos
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort;
        port driveByWireOutput : DataBusPort;
    }

    requirement def ReqNavegacionGNSSDenegado {
        subject gnc : SistemaNavegacionControl;
        doc /* Navegacion autonoma precisa ante inhibicion de senal satelital (RNAV-01). */
        require constraint { true }
    }
}
