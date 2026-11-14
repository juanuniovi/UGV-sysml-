# Tasks

## 1. Actualización en el Modelo SysML v2

- [x] 1.1 Renombrar en `Modelos/04_1_control.sysml` la definición `part def ControlModoOperacion` a `part def GobiernoControl` y su instancia en `SistemaControl` a `part gobiernoControl : GobiernoControl;`.
- [x] 1.2 Actualizar en `Modelos/04_1_control.sysml` las conexiones internas `c_bus_comms_modo`, `c_modo_habilitacion_consignas` y la relación `satisfy ReqModoTeleoperado by gobiernoControl;`.

## 2. Verificación y Trazabilidad

- [x] 2.1 Verificar mediante búsqueda de texto en `Modelos/` que no queden referencias residuales a `ControlModoOperacion` ni `controlModoOperacion`.
- [x] 2.2 Comprobar la coherencia sintáctica SysML v2 y documentar la validación formal conforme a `AGENTS.md`.
