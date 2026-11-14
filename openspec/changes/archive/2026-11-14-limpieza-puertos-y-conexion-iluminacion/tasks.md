# Tasks

## 1. Actualización del Subsistema de Iluminación

- [x] 1.1 Eliminar los puertos obsoletos `port chassisMount : MechanicalMountPort;` y `port dataBus : DataBusPort;` en `SistemaIluminacion` de [Modelos/04_3_iluminacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_3_iluminacion.sysml), preservando `port powerInput : ElectricalPowerPort;`.
- [x] 1.2 Declarar el tipado simétrico `port entradaIntensidad : PuertoIntensidadIluminacion;` en `SistemaIluminacion` de [Modelos/04_3_iluminacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_3_iluminacion.sysml) para eliminar el fallo de ámbito (`relationship unresolved`) en Spec42.

## 2. Actualización de Interconexiones en Plataforma UGV

- [x] 2.1 Eliminar la conexión mecánica huérfana `c_barcaza_iluminacion connect barcaza.avionicaMount to iluminacion.chassisMount;` en `PlataformaUGV` de [Modelos/09_sistema_ugv.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/09_sistema_ugv.sysml).
- [x] 2.2 Verificar la coherencia sintáctica de las conexiones `c_control_iluminacion` y `c_power_iluminacion` en `PlataformaUGV` de [Modelos/09_sistema_ugv.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/09_sistema_ugv.sysml).

## 3. Verificación de Vistas y Validación

- [x] 3.1 Verificar en [Modelos/11_vistas.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/11_vistas.sysml) que la vista `vistaConexionesNavegacionControl` (línea 93) y `vistaEstructuraNavegacionControl` resuelven limpiamente las partes y conexiones expuestas.
- [x] 3.2 Ejecutar `openspec validate --all` y confirmar que las especificaciones y deltas de OpenSpec son completamente válidos.
