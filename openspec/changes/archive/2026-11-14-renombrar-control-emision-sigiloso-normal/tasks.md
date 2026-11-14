# Tasks

## 1. Actualización del Modelo SysML v2

- [x] 1.1 Renombrar `item def ControlEmisionRadiante` a `item def ControlEmisionSigilosoNormal` en `Modelos/04_2_navegacion.sysml` y actualizar su docstring asociado verificando que el archivo preserve sintaxis SysML v2 válida.
- [x] 1.2 Actualizar la salida `out controlRadiante : ControlEmisionSigilosoNormal;` en la acción `ConfigurarModoDeteccion` de `Modelos/04_2_navegacion.sysml` y comprobar que compila coherentemente con el resto del subsistema.

## 2. Verificación y Trazabilidad

- [x] 2.1 Ejecutar una búsqueda de texto en todo el directorio `Modelos/` para confirmar que no existen referencias obsoletas a `ControlEmisionRadiante`.
- [x] 2.2 Verificar la trazabilidad del requisito contractual `RGEN-09` y documentar formalmente la validación sintáctica (y el estado de Spec42 según lo dispuesto en `AGENTS.md`).
