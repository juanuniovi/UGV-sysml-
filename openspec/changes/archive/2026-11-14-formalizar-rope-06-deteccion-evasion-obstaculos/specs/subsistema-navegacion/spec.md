# subsistema-navegacion Spec Delta

## ADDED Requirements

### Requirement: Detección y evasión de obstáculos en modo autónomo (ROPE-06)
El paquete `SubsistemaNavegacion` en `Modelos/04_2_navegacion.sysml` SHALL definir `ReqDeteccionEvasionObstaculos` con `subject nav : SistemaNavegacion;` conteniendo la cita contractual de `ROPE-06`, y `SistemaNavegacion` SHALL incorporar la relación `satisfy ReqDeteccionEvasionObstaculos by moduloDeteccionEvasion;` (con satisfacción formal en `PlataformaUGV`), garantizando la capacidad de detectar y evadir obstáculos estáticos y dinámicos tanto en modo NORMAL como SIGILOSO.

#### Scenario: Detección y evasión de obstáculos en modo autónomo
- **WHEN** el UGV opera en modo `AUTÓNOMO` en modo de detección `NORMAL` o `SIGILOSO`
- **THEN** `moduloDeteccionEvasion` fusiona el entorno y emite `salidaObstaculos` permitiendo el recálculo de trayectorias y maniobras de evasión, quedando satisfecho formalmente `ReqDeteccionEvasionObstaculos` (`ROPE-06`)
