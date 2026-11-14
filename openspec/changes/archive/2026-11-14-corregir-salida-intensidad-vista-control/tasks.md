# Tasks

## 1. Actualización de Semántica de Flujo en Subsistema de Iluminación

- [x] 1.1 Restaurar la dirección de flujo `out item intensidad : Intensidad;` en `PuertoIntensidadIluminacion` de [Modelos/04_3_iluminacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_3_iluminacion.sysml).
- [x] 1.2 Restituir la conjugación `port entradaIntensidad : ~PuertoIntensidadIluminacion;` en `SistemaIluminacion` de [Modelos/04_3_iluminacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_3_iluminacion.sysml) y verificar coherencia sintáctica.

## 2. Normalización de Delegación de Enlaces de Intensidad en Subsistema de Control

- [x] 2.1 Normalizar el binding interno en `ComputadorAutonomia` de [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml) estableciendo `binding b_plan_intensidad bind salidaIntensidad = subsistemaPlanificacionEvaluacion.salidaIntensidad;`.
- [x] 2.2 Normalizar el binding de contorno en `SistemaControl` de [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml) estableciendo `binding b_ctrl_intensidad bind salidaIntensidad = computadorAutonomia.salidaIntensidad;`.

## 3. Validación y Verificación de Vistas con Spec42

- [x] 3.1 Comprobar que `vistaConexionesNavegacionControl` (línea 93 de [Modelos/11_vistas.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/11_vistas.sysml)) resuelve ambos extremos de `c_control_iluminacion` sin advertencias de limitación de proyección (`projection limitation`).
- [x] 3.2 Verificar que en Spec42 el puerto `salidaIntensidad` se visualiza en `control` (y sus subpartes) y que la línea de conexión `c_control_iluminacion` dibuja el flujo de `intensidad` hacia `iluminacion.entradaIntensidad`.
- [x] 3.3 Confirmar que la trazabilidad de requisitos `RGEN-20`, `ROPE-01` y `ROPE-02` se mantiene íntegra y sin regresiones.

## Workflow follow-up

- Archivar el cambio OpenSpec tras la aprobación y validación exitosa.
