# Design: Incluir SubsistemaIluminacion en la Vista de Conexiones de Navegación y Control

## Context
En `Modelos/11_vistas.sysml`, `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` muestran la interconexión entre `control`, `navegacion` y `comunicaciones`. El subsistema de iluminación (`SubsistemaIluminacion` en `Modelos/04_3_iluminacion.sysml`) proporciona iluminación 360° perimetral (`RGEN-20`) que apoya a las cámaras ópticas de navegación (`RGEN-22`) y es gobernable desde el modo teleoperado (`ROPE-02`). Véase `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**
- Añadir `expose SistemaUGV::PlataformaUGV::iluminacion;` y `expose SistemaUGV::PlataformaUGV::c_comms_iluminacion;` a `vistaEstructuraNavegacionControl` en `Modelos/11_vistas.sysml`.
- Añadir `expose SistemaUGV::PlataformaUGV::iluminacion;` y `expose SistemaUGV::PlataformaUGV::c_comms_iluminacion;` a `vistaConexionesNavegacionControl` en `Modelos/11_vistas.sysml`.
- Mantener la sintaxis SysML v2 válida en `11_vistas.sysml`.

**Non-Goals:**
- No alterar las conexiones ya existentes en `Modelos/09_sistema_ugv.sysml` ni en `04_3_iluminacion.sysml`.

## Decisions

### Decisión 1: Incorporación directa en ambas vistas del Bloque 4
- **Elección**: Exponer la parte `iluminacion` y su conexión `c_comms_iluminacion` tanto en la vista estructural (BDD) como en la vista de interconexiones (IBD).
- **Justificación**: Da coherencia total al Bloque 4 (4.1 Control, 4.2 Navegación, 4.3 Iluminación), demostrando cómo el operador controla las luces desde Comunicaciones en modo teleoperado (`ROPE-02`) para dar soporte a las cámaras (`RGEN-20`, `RGEN-22`).
