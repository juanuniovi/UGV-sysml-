# subsistema-navegacion Specification

## Purpose

Especifica la arquitectura interna, bloques tipados, puertos, conexiones, acciones, requisitos y vistas del subsistema **4.2 Navegación** (`SubsistemaNavegacion` en `Modelos/04_2_navegacion.sysml`), encargado de la percepción sensorial radiante (`SensorLidar`, `SensorRadar`) y no radiante (`SistemaVisionComputador`, `CamarasOpticas360`, `CamaraTermicaNocturna`), la detección y evasión de obstáculos estáticos y dinámicos (`ModuloDeteccionEvasion`, `RGEN-09`, `ROPE-06`), la odometría visual-inercial en entorno GNSS denegado (`OdometriaVisualInercialVIO`, `RNAV-01`) y su interconexión con `SistemaControl` en `PlataformaUGV`.

> **Nota de autorización de requisitos (`AGENTS.md`)**: El usuario ha confirmado y autorizado explícitamente la eliminación de `SistemaNavegacionControl` (`navegacionControl`) y la reasignación del `subject` / `satisfy` de `ReqNavegacionGNSSDenegado` (`RNAV-01`) y `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) hacia `SistemaNavegacion`, preservando íntegramente el texto, las restricciones y la trazabilidad del pliego.

## Requirements

### Requirement: Separación estructural del Subsistema 4.2 de Navegación (RGEN-09, RNAV-01, ROPE-06, RGEN-20, RGEN-22)
El modelo SHALL definir en `Modelos/04_2_navegacion.sysml` el paquete `SubsistemaNavegacion` con el bloque `SistemaNavegacion` (`subsistemaNavegacion : SistemaNavegacion`), integrando los sensores radiantes (`sensoresLidar`, `sensoresRadar`), los sensores no radiantes (`sistemaVisionComputador`, `camarasOpticas360`, `camaraTermicaNocturna`), `moduloDeteccionEvasion` y `odometriaVisualInercialVIO`.

#### Scenario: Composición interna de SistemaNavegacion
- **WHEN** se inspecciona la estructura de `SubsistemaNavegacion::SistemaNavegacion`
- **THEN** agrupa todos los sensores de percepción, detección de obstáculos y odometría VIO, exponiendo hacia el exterior los puertos de interfaz con `SistemaControl`

### Requirement: Interconexiones internas de percepción, apagado desde Comunicaciones y enlace con Control en PlataformaUGV (RGEN-09, RNAV-01)
El bloque `SistemaNavegacion` SHALL conectar internamente `sensoresLidar`, `sensoresRadar` y `sistemaVisionComputador` con `moduloDeteccionEvasion`, conectar `entradaModoDeteccion` directamente con `sensoresLidar` y `sensoresRadar` para ejecutar su apagado/encendido desde el puerto `salidaModoDeteccion` de `SistemaComunicacionesEmbarcado`, y exponer `salidaObstaculos` y `salidaOdometria` hacia `SistemaControl` en `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`).

#### Scenario: Apagado de LiDAR y radar desde Comunicaciones en modo SIGILOSO y entrega de obstáculos a Control
- **WHEN** `PlataformaUGV` ensambla `part comunicaciones : SistemaComunicacionesEmbarcado`, `part navegacion : SistemaNavegacion` y `part control : SistemaControl`
- **THEN** `comunicaciones.salidaModoDeteccion` se conecta a `navegacion.entradaModoDeteccion` (y de ahí directamente a `sensoresLidar` y `sensoresRadar` para apagarlos en modo `SIGILOSO`), `navegacion.salidaObstaculos` se conecta a `control.entradaObstaculos` y `navegacion.salidaOdometria` se conecta a `control.entradaOdometria`

### Requirement: Trazabilidad de requisitos RNAV-01 y RGEN-09 sobre SistemaNavegacion y vista conjunta con Control
El paquete `SubsistemaNavegacion` SHALL mantener los requisitos `ReqNavegacionGNSSDenegado` (`RNAV-01`) y `ReqDeteccionObstaculosModoSigiloso` (`RGEN-09`) con `subject nav : SistemaNavegacion` y satisfacción formal `satisfy`, y `Modelos/11_vistas.sysml` SHALL representar en una misma vista conjunta (`vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`) tanto `SistemaNavegacion` como `SistemaControl`.

#### Scenario: Verificación de trazabilidad y vista conjunta de Navegación y Control en Spec42
- **WHEN** se valida el modelo con Spec42 (`vistaRequisitos`, `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`)
- **THEN** los requisitos `RNAV-01` y `RGEN-09` quedan trazados sin errores y se representan conjuntamente ambas partes (`SistemaControl` y `SistemaNavegacion`) y sus conexiones
