package SubsistemaIluminacion {
    doc /* Subsistema 4.3 de Iluminacion y Soporte Optico Perimetral (RGEN-20) */
    private import ScalarValues::*;
    private import TiposBase::*;

    // --- Items y Puertos de Control de Intensidad (ROPE-01, ROPE-02, RGEN-20) ---
    item def Intensidad {
        doc /* Item de consigna de intensidad luminica perimetral (0.0 a 100.0 %) comandada por el sistema de control */
        attribute nivelPorcentaje : Real;
    }

    port def PuertoIntensidadIluminacion {
        doc /* Puerto de envio de consigna de intensidad luminica */
        out item intensidad : Intensidad;
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

        // Atributos de iluminacion perimetral 360 grados (RGEN-20)
        attribute anguloCoberturaDeg : Real = 360.0;
        attribute potenciaConsumoWatts : Potencia;
        attribute alcanceEfectivoMetros : Longitud;

        // Puertos externos hacia la plataforma UGV, control y alimentacion
        port powerInput : ElectricalPowerPort;
        port entradaIntensidad : PuertoIntensidadIluminacion; // Recepcion de intensidad desde SistemaControl

        // Accion local de iluminacion perimetral 360 grados
        perform action iluminar360Grados : Iluminar360Grados;

        // Satisfaccion formal de requisitos
        satisfy requirement : ReqConscienciaSituacionalIluminacion360;
    }
}
