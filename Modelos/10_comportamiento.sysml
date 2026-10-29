package ComportamientoUGV {
    doc /* Maquina de estados de los modos operacionales del UGV (MagicGrid / Pliego CDTI) */

    state def ModosOperacionUGVStateMachine {
        doc /* Estados de mision: conmutacion entre control remoto, autonomia y sigilo */

        entry; then Apagado;

        state Apagado;
        transition encendido
            first Apagado
            then ModoTeleoperado;

        state ModoTeleoperado {
            doc /* Conduccion remota manual desde Puesto de Mando (PMP) o Consola CPT */
        }
        transition activarAutonomia
            first ModoTeleoperado
            then ModoAutonomo;

        state ModoAutonomo {
            doc /* Guiado automatico por waypoints o seguimiento convoy con Detect & Avoid activo */
        }
        transition activarSigilo
            first ModoAutonomo
            then ModoSigiloso;
        transition retornarTeleoperacion
            first ModoAutonomo
            then ModoTeleoperado;

        state ModoSigiloso {
            doc /* Operacion 100% electrica por baterias con sensores activos (LiDAR/Radar) apagados */
        }
        transition salirSigilo
            first ModoSigiloso
            then ModoAutonomo;

        state ModoDegradado {
            doc /* Falla de enlace o perdida GNSS: frenado preventivo o navegacion inercial VIO */
        }
    }
}
