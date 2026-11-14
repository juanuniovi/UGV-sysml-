# Tasks

## 1. Declaración de Tipos y Componente de Control de Modo

- [x] 1.1 Declarar en `Modelos/04_1_control.sysml` la enumeración `ModoOperacionConduccion` (`TELEOPERADO`, `NAVEGACION`), el ítem `ComandoModoOperacion` y el bloque `part def ControlModoOperacion` con sus puertos de bus de datos y control de habilitación.
- [x] 1.2 Actualizar `SubsistemaPlanificacionEvaluacion` en `Modelos/04_1_control.sysml` incorporando el atributo `consignasHabilitadas : Boolean` y el puerto de control de modo conectado a través de `ComputadorAutonomia`.

## 2. Integración en SistemaControl y Trazabilidad ROPE-01

- [x] 2.1 Instanciar `part controlModoOperacion : ControlModoOperacion;` dentro de `part def SistemaControl`, enlazando su puerto de órdenes con `dataBus` y su salida de habilitación con `computadorAutonomia`.
- [x] 2.2 Formalizar en `Modelos/04_1_control.sysml` el requisito `requirement def ReqModoTeleoperado` (`ROPE-01`) y vincular su relación de satisfacción `satisfy requirement : ReqModoTeleoperado by controlModoOperacion;`.
- [x] 2.3 Verificar la coherencia sintáctica SysML v2 de `Modelos/04_1_control.sysml`, comprobar que no se introducen regresiones en otros subsistemas y documentar la validación formal conforme a `AGENTS.md`.
