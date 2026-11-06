# Tasks

## 1. Modelado en `Modelos/02_tren_rodaje.sysml`

- [x] 1.1 Declarar las definiciones tipadas `RuedaTraccionIndependiente`, `SuspensionNeumaticaRegulable`, `ServodireccionMultieje` y `SistemaFrenadoServicio` con documentación del pliego de referencia (`RLT1-01..05`).
- [x] 1.2 Actualizar `TrenRodajeRuedas` para instanciar las partes tipadas y verificar que los puertos `chassisMount`, `powerInput` y `controlBus` permanecen intactos.
- [x] 1.3 Formalizar los bloques `requirement def` para `ReqTraccionRuedas` (`RLT1-01`), `ReqConfiguracionMultirrueda` (`RLT1-02`), `ReqPrestacionesMovilidad` (`RLT1-03`), `ReqTraccionIndependienteRueda` (`RLT1-04`) y `ReqSuspensionRegulableRetractil` (`RLT1-05`).
- [x] 1.4 Establecer las relaciones de trazabilidad `satisfy requirement : ...` dentro de `TrenRodajeRuedas` siguiendo la sintaxis canónica de Spec42.

## 2. Verificación de compilación y compatibilidad

- [x] 2.1 Ejecutar `spec42 check Modelos` y asegurar que el resultado es `0 errors, 0 warnings` en todo el repositorio.
- [x] 2.2 Comprobar mediante `git diff` que ningún otro archivo del directorio `Modelos/` ha sufrido alteraciones y que las conexiones en `09_sistema_ugv.sysml` se mantienen válidas.
- [x] 2.3 Ejecutar `openspec validate --changes` para verificar formalmente los artefactos del cambio.
