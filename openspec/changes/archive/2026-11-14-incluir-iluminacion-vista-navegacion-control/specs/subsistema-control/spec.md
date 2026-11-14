# Spec Delta: subsistema-control

## MODIFIED Requirements

### Requirement: Vista conjunta de Control y Navegación en VistasUGV
El paquete `VistasUGV` en `Modelos/11_vistas.sysml` SHALL representar conjuntamente `SubsistemaControl`, `SubsistemaNavegacion` y `SubsistemaIluminacion` en las vistas `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView`, incluyendo la parte `SistemaUGV::PlataformaUGV::iluminacion` y su enlace `SistemaUGV::PlataformaUGV::c_comms_iluminacion` para supervisión del soporte lumínico perimetral y su gobierno en teleoperación (`ROPE-02`, `RGEN-20`).

#### Scenario: Renderizado conjunto de Control y Navegación en Spec42
- **WHEN** se procesan las vistas `VistasUGV::vistaEstructuraNavegacionControl` y `VistasUGV::vistaConexionesNavegacionControl` con Spec42
- **THEN** se visualizan en una misma vista la parte de Control (`control`), Navegación (`navegacion`), Iluminación (`iluminacion`), Comunicaciones (`comunicaciones`) y sus conexiones de bus y vídeo sin errores ni advertencias
