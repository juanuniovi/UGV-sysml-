# Tasks

## 1. Modelado en `Modelos/01_barcaza.sysml`

- [x] 1.1 Declarar las definiciones tipadas `part def ChasisProtegidoEnV`, `part def CabestranteAutoRecuperacion` y `part def GanchoRemolqueSTANAG` dentro del paquete `SubsistemaBarcaza`.
- [x] 1.2 Actualizar `BarcazaEstructural` para tipar sus partes internas y verificar que los 6 puertos mecánicos preexistentes permanecen intactos.
- [x] 1.3 Formalizar los requisitos `ReqBarcazaComun` (`RGEN-02`), `ReqProteccionCascoEnV` (`RGEN-03`), `ReqCabestranteAutoRecuperacion` (`RGEN-04`), `ReqGanchoSTANAG4101` (`RGEN-05`), preservando `ReqMasaTaraPlataforma` (`RLT1-06`).
- [x] 1.4 Establecer las relaciones de trazabilidad `satisfy` entre las partes estructurales y sus respectivos requisitos del pliego.

## 2. Verificación de compatibilidad e integridad

- [x] 2.1 Comprobar mediante `git diff` que ningún otro archivo del directorio `Modelos/` ha sido modificado y que la interfaz con `Modelos/09_sistema_ugv.sysml` es totalmente coherente.
- [x] 2.2 Ejecutar `openspec validate --changes` para asegurar la validez formal del cambio.
