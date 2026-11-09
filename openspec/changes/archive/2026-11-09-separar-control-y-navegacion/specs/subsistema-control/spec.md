# Spec Delta

## Purpose

Especifica la arquitectura interna, bloques tipados, puertos, conexiones, acciones y vistas del subsistema **4.1 Control** (`SubsistemaControl` en `Modelos/04_1_control.sysml`), encargado del computador de autonomía/guiado (`ComputadorAutonomia`), la gestión de comandos de modo de detección (`NORMAL` / `SIGILOSO`, `RGEN-09`) recibidos desde los Equipos de Control y el frenado automático de seguridad (`ModuloFrenadoSeguridad`, `RGEN-17`) hacia el tren de rodaje (`driveByWireOutput`).

## ADDED Requirements

### Requirement: Separación estructural del Subsistema 4.1 de Control (ROPE-05, RGEN-09, RGEN-17)
El modelo SHALL definir en `Modelos/04_1_control.sysml` el paquete `SubsistemaControl` con el bloque principal `SistemaControl` (y la instancia `subsistemaControl : SistemaControl`), integrando las partes tipadas `computadorAutonomia : ComputadorAutonomia` y `moduloFrenadoSeguridad : ModuloFrenadoSeguridad`.

#### Scenario: Composición interna de SistemaControl
- **WHEN** se inspecciona la estructura de `SubsistemaControl::SistemaControl`
- **THEN** contiene únicamente los bloques de control y actuación segura (`computadorAutonomia` y `moduloFrenadoSeguridad`), sin acoplar directamente los sensores físicos de navegación

### Requirement: Puertos de contorno e interconexiones internas de SistemaControl (ROPE-05, RGEN-17)
El bloque `SistemaControl` SHALL exponer puertos de montaje y alimentación (`chassisMount`, `powerInput`), puertos de bus de plataforma (`dataBus`, `driveByWireOutput`) y puertos de interfaz de entrada desde el Subsistema de Navegación (`entradaObstaculos : ~PuertoMapaObstaculos`, `entradaOdometria : ~PuertoOdometriaVIO`), enlazándolos con `computadorAutonomia` y `moduloFrenadoSeguridad` sin enviar la orden de modo de detección desde `computadorAutonomia`.

#### Scenario: Flujo interno de consignas en SistemaControl
- **WHEN** `SistemaControl` recibe un mapa de obstáculos por `entradaObstaculos`, odometría por `entradaOdometria` y órdenes de misión desde `dataBus`
- **THEN** `computadorAutonomia` calcula y envía las consignas de conducción (`PuertoConsignaAutonomia`) a `moduloFrenadoSeguridad`, el cual las supervisa y entrega en `driveByWireOutput`

### Requirement: Vista conjunta de Control y Navegación en VistasUGV
El paquete `VistasUGV` en `Modelos/11_vistas.sysml` SHALL representar conjuntamente `SubsistemaControl` y `SubsistemaNavegacion` en las vistas `vistaEstructuraNavegacionControl : GeneralView` y `vistaConexionesNavegacionControl : InterconnectionView`.

#### Scenario: Renderizado conjunto de Control y Navegación en Spec42
- **WHEN** se procesan las vistas `VistasUGV::vistaEstructuraNavegacionControl` y `VistasUGV::vistaConexionesNavegacionControl` con Spec42
- **THEN** se visualizan en una misma vista tanto la parte de Control (`SistemaControl`) como la parte de Navegación (`SistemaNavegacion`), sus componentes internos, puertos e interconexiones sin errores ni advertencias
