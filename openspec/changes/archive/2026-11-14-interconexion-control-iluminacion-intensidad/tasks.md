# Tasks

## 1. Definición de Tipos y Puertos de Iluminación

- [x] 1.1 Definir `item def Intensidad` y `port def PuertoIntensidadIluminacion` en `Modelos/04_3_iluminacion.sysml`, y dotar a `SistemaIluminacion` del puerto `entradaIntensidad : ~PuertoIntensidadIluminacion;`. Verificar que el archivo parsea correctamente.

## 2. Incorporación de Salida de Intensidad en Control y Computador de Autonomía

- [x] 2.1 Importar `SubsistemaIluminacion` en `Modelos/04_1_control.sysml` y añadir `port salidaIntensidad : PuertoIntensidadIluminacion;` a `SubsistemaPlanificacionEvaluacion`, documentando el gobierno de intensidad desde telemando en modo teleoperado y modulación autónoma en navegación.
- [x] 2.2 Exponer `salidaIntensidad : PuertoIntensidadIluminacion;` en `ComputadorAutonomia` y `SistemaControl`, conectándolos mediante bindings internos (`b_plan_intensidad` y `b_ctrl_intensidad`).

## 3. Actualización de Interconexión en Plataforma UGV y Vistas

- [x] 3.1 Actualizar `Modelos/09_sistema_ugv.sysml` reemplazando `c_comms_iluminacion` por `connection c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`.
- [x] 3.2 Actualizar `Modelos/11_vistas.sysml` en `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` reemplazando `c_comms_iluminacion` por `c_control_iluminacion`.
- [x] 3.3 Verificar trazabilidad, sintaxis y coherencia integral de las conexiones de los subsistemas 4.1 y 4.3.

## Workflow follow-up

- Ejecutar opsx-archive para sincronizar especificaciones y archivar el cambio.
- Confirmar con el usuario el estado del bloque funcional y la integración en la rama.
