# Proposal

## Why

En la visualización gráfica de los diagramas del UGV (vistas 7 y 8 en `Modelos/11_vistas.sysml`), el bloque `iluminacion` aparece conteniendo la subparte `iluminacion360`, pero simultáneamente aparece un nodo duplicado e inconexo de `iluminacion360` flotando en el lienzo. Este comportamiento se debe a la doble jerarquía artificial introducida al definir `part def Iluminacion360` y la subparte `part iluminacion360 : Iluminacion360` dentro de `SistemaIluminacion` junto con una cláusula `satisfy ... by iluminacion360`, mientras que el `subject` de `ReqConscienciaSituacionalIluminacion360` es `SistemaIluminacion`. Dado que el subsistema 4.3 está dedicado exclusivamente a la iluminación perimetral en 360 grados (`RGEN-20`), aplanar `SistemaIluminacion` para que contenga directamente los atributos y la acción de cobertura 360° elimina la duplicidad y resuelve el artefacto visual sin alterar en modo alguno los requisitos contractuales ni las interfaces externas.

## What Changes

- **Simplificación y aplanado de `SubsistemaIluminacion::SistemaIluminacion` (`Modelos/04_3_iluminacion.sysml`)**:
  - Eliminar la definición `part def Iluminacion360` y la subparte interna `part iluminacion360 : Iluminacion360`.
  - Incorporar directamente en `SistemaIluminacion` los atributos característicos de iluminación 360°: `anguloCoberturaDeg : Real = 360.0`, `potenciaConsumoWatts : Potencia` y `alcanceEfectivoMetros : Longitud`.
  - Vincular la acción `perform action iluminar360Grados : Iluminar360Grados` directamente al bloque `SistemaIluminacion`.
  - Corregir la satisfacción del requisito `ReqConscienciaSituacionalIluminacion360` dentro de `SistemaIluminacion` para que apunte directamente a `self` (o al propio `SistemaIluminacion`), concordando plenamente con su `subject ilum : SistemaIluminacion;` y con la satisfacción ya declarada en `PlataformaUGV` (`satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;`).
- **Eliminación del nodo flotante en vistas SysML v2**:
  - Al no existir una definición de parte ni subparte separada `iluminacion360`, los motores de renderizado de diagramas (Spec42 / visores SysML v2) representan un único bloque nítido y acoplado `iluminacion : SistemaIluminacion` con sus puertos hacia comunicaciones (`c_comms_iluminacion`), barcaza (`c_barcaza_iluminacion`) y planta motriz (`c_power_iluminacion`).

## Capabilities

### New Capabilities
*(Ninguna)*

### Modified Capabilities
- `subsistema-iluminacion`: Se modifica la especificación de la estructura interna del subsistema 4.3 para que los atributos de 360 grados pertenezcan directamente a `SistemaIluminacion`, eliminando la subparte intermedia `iluminacion360` y unificando la satisfacción formal del requisito `RGEN-20`.

## Impact

- **Código y modelos afectados**:
  - `Modelos/04_3_iluminacion.sysml`: Eliminación de `part def Iluminacion360` y de `part iluminacion360`, trasladando sus atributos a `SistemaIluminacion`.
  - `Modelos/09_sistema_ugv.sysml`: Ningún cambio de interfaz (conserva `part iluminacion : SistemaIluminacion`, puertos y conexiones idénticas).
  - `Modelos/11_vistas.sysml`: Desaparición del nodo huérfano `iluminacion 360` en las vistas 7 (`vistaEstructuraNavegacionControl`) y 8 (`vistaConexionesNavegacionControl`).
- **Requisitos contractuales**: Se mantiene íntegra y estricta la trazabilidad con `RGEN-20` (cobertura 360°, apoyo visual y consciencia situacional). No se altera, relaja ni vulnera ningún requisito.
