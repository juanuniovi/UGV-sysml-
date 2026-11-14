# Proposal: Incluir SubsistemaIluminacion en la Vista de Conexiones de Navegación y Control

## Why
El requisito contractual **`ROPE-02`** estipula que el modo teleoperado permitirá el control directo de las funciones inherentes del vehículo, incluyendo la iluminación perimetral (`RGEN-20`), la cual brinda soporte directo a las cámaras de visión y consciencia situacional de navegación (`RGEN-22`). Actualmente, en [Modelos/11_vistas.sysml](file:///C:/Users/mario/Desktop/UGV/ugv-sysml-/Modelos/11_vistas.sysml), las vistas conjuntas `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` documentan el requisito `RGEN-20` en su docstring, pero no exponen formalmente la parte `iluminacion` ni su enlace activo de control `c_comms_iluminacion`. El usuario ha solicitado incorporar este subsistema a la vista de conexiones para reflejar de forma completa la topología de aviónica y percepción del Bloque 4.

## What Changes
- **Actualización de `vistaEstructuraNavegacionControl`**: Exponer `SistemaUGV::PlataformaUGV::iluminacion` y su conexión `c_comms_iluminacion`.
- **Actualización de `vistaConexionesNavegacionControl`**: Exponer `SistemaUGV::PlataformaUGV::iluminacion` y su conexión `c_comms_iluminacion`.
- **Sincronización de especificación**: Actualizar la especificación [openspec/specs/subsistema-control/spec.md](file:///C:/Users/mario/Desktop/UGV/ugv-sysml-/openspec/specs/subsistema-control/spec.md) para reflejar la incorporación de iluminación en la vista conjunta de Navegación y Control.

## Capabilities

### New Capabilities
<!-- Ninguna nueva capacidad -->

### Modified Capabilities
- `subsistema-control`: Actualización del requisito de vistas conjuntas en `Modelos/11_vistas.sysml` para incorporar la parte de iluminación y su conexión de telemando (`ROPE-02`, `RGEN-20`).

## Impact
- **Archivos de modelo afectados**: `Modelos/11_vistas.sysml`.
- **Compatibilidad**: No altera la estructura física ni puertos de ningún subsistema existente; mejora la visibilidad arquitectónica y la coherencia con `ROPE-02` y `RGEN-20`.
