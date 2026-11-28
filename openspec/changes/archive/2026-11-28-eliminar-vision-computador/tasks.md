# Tasks

## 1. Refactorización de SubsistemaNavegacion (`Modelos/04_2_navegacion.sysml`)

- [x] 1.1 Sustituir `DatosVisionComputador` por `DatosVideoCamaras`, actualizar `PuertoVideoOptico` para usar `DatosVideoCamaras` y eliminar `PuertoDatosVision` y `part def SistemaVisionComputador`, verificando que no queden definiciones huérfanas en `Modelos/04_2_navegacion.sysml`.
- [x] 1.2 Actualizar `ModuloDeteccionEvasion` reemplazando `entradaVision : ~PuertoDatosVision` por `entradaOptica : ~PuertoVideoOptico` y `entradaTermica : ~PuertoVideoOptico`, y actualizar `SubsistemaCamaras` (`doc` y comentarios de bindings) para reflejar el enlace directo hacia `ModuloDeteccionEvasion`.
- [x] 1.3 En `SistemaNavegacion`, eliminar `part sistemaVisionComputador : SistemaVisionComputador;` y las conexiones `c_vision_deteccion`, `c_camaras_optica_vision` y `c_camaras_termica_vision`, sustituyéndolas por `c_camaras_optica_deteccion` (`camaras.salidaOptica` → `moduloDeteccionEvasion.entradaOptica`) y `c_camaras_termica_deteccion` (`camaras.salidaTermica` → `moduloDeteccionEvasion.entradaTermica`).
- [x] 1.4 Actualizar `DetectarObstaculosNavegacion` (`datosCamaras : DatosVideoCamaras`, `adquirirPercepcionCamaras`) y el `doc` de `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`), verificando que la trazabilidad `RGEN-09`, `RGEN-20`, `RGEN-22`, `ROPE-06` y `RNAV-01` permanece íntegra.

## 2. Actualización de referencias en Control y Vistas

- [x] 2.1 Actualizar el `doc` de `SubsistemaFusionEstado` en `Modelos/04_1_control.sysml` y las descripciones de `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` en `Modelos/11_vistas.sysml` para eliminar menciones a `visión por computador`, comprobando con búsqueda en `Modelos/*.sysml` que no queden referencias obsoletas.

## 3. Verificación con Spec42 y trazabilidad

- [x] 3.1 Ejecutar la validación completa de los modelos con Spec42 (o documentar si la herramienta no estuviera disponible) y confirmar 0 errores y 0 avisos en `Modelos/*.sysml` y en las vistas afectadas.
- [x] 3.2 Regenerar/actualizar las vistas gráficas en `Vistas graficas/` (`vistaEstructuraNavegacionControl.svg`, `vistaConexionesNavegacionControl.svg` u otras afectadas) si Spec42 está disponible, y verificar visualmente que `camaras` conecta directamente con `moduloDeteccionEvasion`.

## Workflow follow-up

- Archivar el cambio con `opsx-archive` tras completar la implementación y verificación.
- Consultar al usuario sobre el cierre/fusión de la rama `refactor/eliminar-vision-computador` en `main`.
