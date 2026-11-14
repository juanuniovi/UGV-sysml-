# Design

## Context

En el modelo actual (`Modelos/04_3_iluminacion.sysml`), el paquete `SubsistemaIluminacion` definía un `part def Iluminacion360` instanciado como subparte interna `part iluminacion360 : Iluminacion360` dentro de `part def SistemaIluminacion`. Al exponer `SistemaUGV::PlataformaUGV::iluminacion` en las vistas 7 (`vistaEstructuraNavegacionControl`) y 8 (`vistaConexionesNavegacionControl`) de `Modelos/11_vistas.sysml`, los analizadores gráficos y visores de diagramas SysML v2 proyectan tanto el contenedor `iluminacion` como una caja exterior flotante e inconexa para `iluminacion 360`, debido a la relación `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion360;` (siendo el `subject` de dicho requisito `SistemaIluminacion`). Véase `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**
- Aplanar `SistemaIluminacion` para que agrupe directamente sus atributos de iluminación 360° (`anguloCoberturaDeg`, `potenciaConsumoWatts`, `alcanceEfectivoMetros`) y la acción `iluminar360Grados`.
- Eliminar `part def Iluminacion360` y la subparte `iluminacion360`, suprimiendo el nodo duplicado huérfano en los diagramas de Spec42 y vistas SysML v2.
- Alinear la cláusula de satisfacción interna de `ReqConscienciaSituacionalIluminacion360` para que el sujeto (`SistemaIluminacion`) satisfaga directamente el requisito.
- Mantener inalteradas las conexiones externas en `PlataformaUGV` (`c_barcaza_iluminacion`, `c_power_iluminacion`, `c_comms_iluminacion`) y la satisfacción contractual de `RGEN-20`.

**Non-Goals:**
- No modificar puertos, conectores ni asignaciones de pines en barcaza, planta motriz o comunicaciones.
- No alterar requisitos contractuales ni introducir nuevas exigencias ópticas o funcionales.
- No modificar el alcance ni los filtros de las vistas en `Modelos/11_vistas.sysml`.

## Decisions

### Decisión 1: Aplanamiento directo en `SistemaIluminacion`
- **Elección**: Definir los atributos `anguloCoberturaDeg : Real = 360.0`, `potenciaConsumoWatts : Potencia` y `alcanceEfectivoMetros : Longitud` directamente en `part def SistemaIluminacion`, eliminando la estructura `part def Iluminacion360`.
- **Justificación**: A diferencia de subsistemas complejos como Navegación (que agrupa cámaras, LiDAR, radar y computador en subpartes diferenciadas), Iluminación es un subsistema unifuncional enfocado exclusivamente en la cobertura perimetral 360° requerida por `RGEN-20`. Una subparte intermedia es artificial, redundante y causa problemas de anidamiento visual en herramientas SysML v2.
- **Alternativa descartada**: Mantener `part def Iluminacion360` y filtrar por estereotipo o nombre en `11_vistas.sysml`. Descartada porque complejiza las directivas de las vistas y no resuelve la incoherencia de tener un `subject : SistemaIluminacion` satisfecho por una subparte interna sin puertos propios.

### Decisión 2: Corrección de la cláusula de satisfacción
- **Elección**: En `SistemaIluminacion`, declarar `satisfy requirement : ReqConscienciaSituacionalIluminacion360;`. En `PlataformaUGV`, se mantiene `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;`.
- **Justificación**: Se ajusta a la semántica estricta de SysML v2 donde el bloque que satisface coincide con el tipo especificado en el `subject` del requisito.

## Risks / Trade-offs

- **Riesgo**: Que algún elemento externo referencie `iluminacion.iluminacion360`.
  - **Mitigación**: Verificado mediante búsqueda textual en todo el repositorio (`Modelos/*.sysml`, `openspec/**`); ninguna otra parte del modelo ni de las conexiones referencia esa subparte interna.
