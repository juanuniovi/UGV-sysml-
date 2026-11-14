# Tasks

## 1. Actualización del modelo SysML v2

- [x] 1.1 Modificar la definición de `PuertoIntensidadIluminacion` en `Modelos/04_3_iluminacion.sysml` eliminando el calificador `out` para dejar `item intensidad : Intensidad;` como puerto simétrico.
- [x] 1.2 Verificar la coherencia sintáctica y de referencias en `Modelos/04_1_control.sysml`, `Modelos/04_3_iluminacion.sysml`, `Modelos/09_sistema_ugv.sysml` y `Modelos/11_vistas.sysml`.

## 2. Validación y verificación

- [x] 2.1 Ejecutar `openspec validate --all` para asegurar que las especificaciones OpenSpec cumplen los estándares y no presentan discrepancias.
- [x] 2.2 Comprobar la resolución de la conexión `c_control_iluminacion` en Spec42 para verificar que se dibuja correctamente entre `control` e `iluminacion` en las vistas 7 y 8 sin errores de endpoints ni conflictos de dirección.

## Workflow follow-up

- Consolidar especificaciones y archivar el cambio con `openspec archive conexion-simetrica-control-iluminacion`.
- Solicitar confirmación al usuario para la integración final y cierre del bloque funcional.
