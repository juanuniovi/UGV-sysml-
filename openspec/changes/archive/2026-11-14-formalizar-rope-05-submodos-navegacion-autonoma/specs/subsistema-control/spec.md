# subsistema-control Spec Delta

## ADDED Requirements

### Requirement: Submodos de navegación autónoma y comando de misión (ROPE-05)
El paquete `SubsistemaControl` en `Modelos/04_1_control.sysml` SHALL definir `SubmodoNavegacionAutonoma` (con cinco submodos del pliego), el ítem `ComandoSubmodoAutonomia` y el requisito `ReqSubmodosNavegacionAutonoma` (`ROPE-05`), incorporando la relación `satisfy ReqSubmodosNavegacionAutonoma by computadorAutonomia;` en `SistemaControl` y en `PlataformaUGV`, garantizando el soporte formal de los submodos funcionales de autonomía.

#### Scenario: Conmutación y ejecución de submodos de autonomía en ComputadorAutonomia
- **WHEN** `ComputadorAutonomia` recibe por `dataBus` una orden de activación con un submodo de autonomía asignado en `ComandoSubmodoAutonomia`
- **THEN** activa la planificación correspondiente (puntos de paso, punto de destino, regreso a casa, follow-me o shuttle) y emite las consignas de guiado, quedando satisfecho formalmente `ReqSubmodosNavegacionAutonoma` (`ROPE-05`)
