package SubsistemaIluminacion {
    doc /* Subsistema 4.3 de Iluminacion y Soporte Optico Perimetral (RGEN-20) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // --- Subparte de Iluminacion 360 Grados (RGEN-20) ---
    part def Iluminacion360 {
        doc /* Subparte de iluminacion perimetral en 360 grados para apoyo visual y consciencia situacional (RGEN-20) */
        attribute anguloCoberturaDeg : Real = 360.0;
        attribute potenciaConsumoWatts : Potencia;
        attribute alcanceEfectivoMetros : Longitud;
    }

    // --- Accion de Iluminacion 360 Grados (RGEN-20) ---
    action def Iluminar360Grados {
        doc /* Accion de activacion y emision luminica perimetral en 360 grados (RGEN-20) */
        out emisionActiva : Boolean;
    }

    // --- Requisito Trazable del Pliego Oficial (RGEN-20) ---
    requirement def ReqConscienciaSituacionalIluminacion360 {
        subject ilum : SistemaIluminacion;
        doc /* El UGV debera disponer de medios de iluminacion perimetral en 360 grados para apoyar la consciencia situacional del operador y el trabajo nocturno o en baja visibilidad (RGEN-20). */
        require constraint { true }
    }

    // --- Bloque Principal del Subsistema 4.3 de Iluminacion ---
    part def SistemaIluminacion {
        doc /* Ensamblaje del subsistema de iluminacion perimetral del UGV (RGEN-20) */

        // Subparte de iluminacion 360 (RGEN-20)
        part iluminacion360 : Iluminacion360; // Subparte de iluminacion perimetral 360 grados (RGEN-20)

        // Puertos externos hacia la plataforma UGV y comunicaciones
        port chassisMount : MechanicalMountPort;
        port powerInput : ElectricalPowerPort;
        port dataBus : DataBusPort; // Enlace directo con el bus de comunicaciones

        // Accion local de iluminacion perimetral 360 grados
        perform action iluminar360Grados : Iluminar360Grados;

        // Satisfaccion formal de requisitos
        satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion360;
    }
}
