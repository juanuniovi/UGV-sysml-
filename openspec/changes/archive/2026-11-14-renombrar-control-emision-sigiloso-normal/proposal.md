# Proposal: Renombrar ControlEmisionRadiante a ControlEmisionSigilosoNormal

## Why
El modelo del subsistema de navegación (`Modelos/04_2_navegacion.sysml`) define actualmente el ítem `ControlEmisionRadiante` para gestionar la activación/desactivación de los sensores radiantes (LiDAR y radar) según el requisito contractual `RGEN-09`. El usuario ha solicitado explícitamente renombrar este elemento para que refleje de forma directa y unívoca su propósito operativo y sus modos asociados (`SIGILOSO/NORMAL`), adoptando el identificador sintácticamente válido en SysML v2 `ControlEmisionSigilosoNormal`.

## What Changes
- **Renombrado de definición de ítem**: En `Modelos/04_2_navegacion.sysml`, renombrar `item def ControlEmisionRadiante` a `item def ControlEmisionSigilosoNormal`.
- **Actualización de puertos/acciones**: En la acción `ConfigurarModoDeteccion`, actualizar el parámetro de salida `out controlRadiante : ControlEmisionSigilosoNormal;`.
- **Actualización de documentación interna**: Ajustar los docstrings asociados en SysML v2 y la especificación de navegación para reflejar el nuevo nombre y su coherencia con el requisito `RGEN-09`.

## Capabilities

### New Capabilities
<!-- Ninguna nueva capacidad -->

### Modified Capabilities
- `subsistema-navegacion`: Actualización de la especificación del subsistema de navegación para referenciar el ítem de control de emisión radiante bajo su nueva nomenclatura `ControlEmisionSigilosoNormal` en el flujo de conmutación entre modo NORMAL y SIGILOSO (`RGEN-09`).

## Impact
- **Archivos de modelo afectados**: `Modelos/04_2_navegacion.sysml`.
- **Compatibilidad**: No altera la lógica funcional ni la interconexión con otros subsistemas (`PlataformaUGV`, `SistemaControl`, `SistemaComunicacionesEmbarcado`), ya que los puertos externos de conexión utilizan `DataBusPort` y las conexiones a nivel de plataforma no se ven comprometidas.
- **Trazabilidad**: Mantiene total compatibilidad y satisfacción con `RGEN-09`.
