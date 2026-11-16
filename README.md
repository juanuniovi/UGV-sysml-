# Modelo Modular de UGV Terrestre Pesado Dual en SysML v2


Este repositorio contiene la arquitectura formal de ingeniería de sistemas (MBSE) para un **UGV (Unmanned Ground Vehicle) Terrestre Pesado Multipropósito de uso Dual (Civil-Militar)** desarrollado según la especificación **OMG SysML v2** y adaptado a las prescripciones técnicas de un pliego real del **CDTI**.

El modelo se centra en la plataforma de ruedas (Lote 1: tracción 4x4, 6x6 u 8x8) completo junto con sus puestos de control, dron cenital y módulos de misión.

🌐 **Panel para la gestión del proyecto y Reparto de Tareas (GitHub Pages)**: [**https://juanuniovi.github.io/UGV-sysml-/**](https://juanuniovi.github.io/UGV-sysml-/)  *(sincronizado en tiempo real con los GitHub Issues para coordinación)*

## 1. Arquitectura general del Sistema

A continuación se muestra el diagrama básico de arquitectura física y funcional del UGV, dividido en 8 componentes, con las relaciones entre ellos de tipo **Información/Datos**, **Potencia/Energía** y **Ensamblaje/Mecánica**:

![Arquitectura de Componentes y Conexiones del Sistema UGV](Vistas%20graficas/diagrama_componentes_ugv.svg)

> 💡 Puedes abrir el archivo [`Vistas graficas/index.html`](Vistas%20graficas/index.html) directamente en el navegador para activar/desactivar cada tipo de flujo.




## 2. Estructura de Archivos (en `Modelos/`)

El modelo se distribuye en **14 archivos SysML v2 independientes** (10 de subsistemas y 4 de soporte), cada uno con su propio espacio de nombres (`package`) y enlazados mediante directivas de importación (`private import`):

```text
Modelos/
├── 00_tipos_base.sysml          <- Magnitudes físicas (Masa, Potencia) y puertos estándar (Mecánico, Potencia, Bus, RF)
├── 01_barcaza.sysml             <- Barcaza estructural, chasis en V, cabestrante y anclajes (RGEN-03, RGEN-10, RGEN-23/26, RLT1-06)
├── 02_tren_rodaje.sysml         <- Tren de ruedas independientes, suspensión regulable y servodirección (RLT1-01..05)
├── 03_planta_motriz.sysml       <- Planta híbrida: biocombustible 100%, baterías silenciosas y exportación 120kW (RGEN-11..19)
├── 04 (Navegación, Control e Iluminación)
│   ├── 04_1_control.sysml       <- Subsistema 4.1 de Control: computador de autonomía ROS 2, modos/submodos y frenado de seguridad (ROPE-01, ROPE-02, ROPE-05, ROPE-06, RGEN-09, RGEN-17)
│   ├── 04_2_navegacion.sysml    <- Subsistema 4.2 de Navegación: percepción 360°, cámaras/sensores, VIO y detección/evasión (RNAV-01, ROPE-06, RGEN-09, RGEN-20, RGEN-22)
│   └── 04_3_iluminacion.sysml   <- Subsistema 4.3 de Iluminación: iluminación perimetral 360° y control de intensidad (RGEN-20, ROPE-01, ROPE-02)
├── 05_comunicaciones.sysml      <- Comunicaciones tácticas BLOS/LOS con cifrado COMSEC (RCOM-01..03)
├── 06_estaciones_control.sysml  <- Puesto de Mando Portable (PMP - Linux) y Consola Ligera (CPT - LOS)
├── 07_uav_cenital.sysml         <- Dron aéreo de exploración y relé de comunicaciones con base en techo
├── 08_cargas_pago.sysml         <- Cargas de misión modulares: ISTAR (mástil), Logístico (palets) y MEDEVAC (heridos)
├── 09_sistema_ugv.sysml         <- Ensamblado principal (SoI), conexiones internas (IBD) y relaciones de acople
├── 10_comportamiento.sysml      <- Máquina de estados de los modos operativos (Teleoperado, Autónomo, Sigiloso, Degradado)
└── 11_vistas.sysml              <- Diferentes tipos de visualización del modelo, se ven con VSCode/Spec42
```



## 3. Topología de Conexiones (Internal Block Diagram - IBD)

El archivo [`09_sistema_ugv.sysml`](Modelos/09_sistema_ugv.sysml) orquesta las tres redes de enlace del sistema:

1. **Red Estructural / Mecánica (Naranja)**:
   * Barcaza Común sostiene mecánicamente el tren de rodaje, la planta motriz y la aviónica.
   * Interfaces normalizadas (Frontal / Superior / Trasera) aseguran la fijación rápida de cargas de pago y hangar del UAV.
2. **Red de Potencia y Energía (Verde)**:
   * Planta Motriz Híbrida  → `Alta Tensión` Motores eléctricos de tracción en Tren de Rodaje.
   * Planta Motriz Híbrida  → `Aviónica 24V/48V` Sensores y Computador GNC.
   * Planta Motriz Híbrida  → `Potencia Módulo` Carga de Pago instalada.
   * Planta Motriz Híbrida  → `Recarga Techo` Baterías del UAV Cenital.
3. **Red de Información / Control (Azul)**:
   * Puesto de Mando (PMP)  → `RF BLOS` Comunicaciones  → `Bus CAN` Navegación y Control (GNC).
   * Consola Ligera (CPT)  → `RF LOS` Comunicaciones.
   * Navegación y Control  → `Drive-by-Wire` Tren de Rodaje (dirección, aceleración y frenada).
   * Navegación y Control  → `Datos Misión` Carga de Pago instalada.

### Conexiones relevantes de Navegación, Control e Iluminación (`04_1`, `04_2` y `04_3`)

![Arquitectura interna de Navegación, Control e Iluminación](Vistas%20graficas/diagrama_navegacion_control.svg)

*(Se omiten los enlaces genéricos de chasis y alimentación eléctrica ya recogidos en la topología general anterior).*

1. **Subsistema 4.1 — Control ([`04_1_control.sysml`](Modelos/04_1_control.sysml), `SistemaControl`)**:
   * **Órdenes remotas y selección de modo**: `SistemaComunicacionesEmbarcado` → `GobiernoControl` y `ComputadorAutonomia` (consignas desde PMP/CPT y transición entre modo Teleoperado y Navegación Autónoma).
   * **Habilitación de autonomía**: `GobiernoControl` → `ComputadorAutonomia` (habilita o inhibe las consignas autónomas según el modo operativo).
   * **Frenado de seguridad y actuación**: `ComputadorAutonomia` → `ModuloFrenadoSeguridad` → `TrenRodajeRuedas` (consignas de movimiento hacia el *Drive-by-Wire*, con frenado automático progresivo e inhabilitación manual desde `SistemaComunicacionesEmbarcado`).
   * **Iluminación y buses de plataforma**: `ComputadorAutonomia` → `SistemaIluminacion` (intensidad luminosa) y `SistemaControl` → `PlantaMotrizHibrida` / `CargaPagoModular` (bus de control y datos de misión).

2. **Subsistema 4.2 — Navegación ([`04_2_navegacion.sysml`](Modelos/04_2_navegacion.sysml), `SistemaNavegacion`)**:
   * **Percepción visual pasiva**: `SubsistemaCamaras` (ópticas 360°, laterales y térmica nocturna) → `SistemaVisionComputador` (procesamiento pasivo no radiante) y → `SistemaComunicacionesEmbarcado` (vídeo de teleoperación).
   * **Detección y evasión (*Detect & Avoid*)**: `SensorLidar`, `SensorRadar` y `SistemaVisionComputador` → `ModuloDeteccionEvasion` → `ComputadorAutonomia` (`SistemaControl`) con el mapa unificado de obstáculos.
   * **Control de emisiones (modo sigiloso)**: `SistemaComunicacionesEmbarcado` → `SensorLidar` y `SensorRadar` (activación/desactivación de sensores radiantes).
   * **Navegación sin GNSS y estado de rodaje**: `OdometriaVisualInercialVIO` → `ComputadorAutonomia` (`SistemaControl`) para posicionamiento en entorno GNSS denegado, y `TransductoresContactoDinamicos` → `SistemaComunicacionesEmbarcado` para telemetría del tren de rodaje.

3. **Subsistema 4.3 — Iluminación ([`04_3_iluminacion.sysml`](Modelos/04_3_iluminacion.sysml), `SistemaIluminacion`)**:
   * **Regulación perimetral 360°**: `ComputadorAutonomia` (`SistemaControl`) → `SistemaIluminacion` (consigna de intensidad luminosa 0–100 %).
  

---

## 4. Control de Cambios y Trazabilidad de Requisitos

* **Actualización en Barcaza y Chasis (`01_barcaza.sysml`, Issue #20)**:
  * **Tara de plataforma (`RLT1-06`)**: Corregido el límite superior a **7.000 kg** (`barcaza.masa <= 7000.0`) según el pliego oficial (CDTI Anexo I §3.2.1).
  * **Identificadores del pliego**: Regularizados a `RGEN-03` (barcaza común), `RGEN-10` (remolque STANAG 4101 $\ge 3.000\text{ kg}$) y `RGEN-23/26` (eslingas y cabestrante de autorrecuperación).
  * **Política de auditoría anti-arrastre**: Incorporada regla en `AGENTS.md` que obliga a contrastar todo requisito contractual directamente con las fuentes primarias de `docs/` antes de consolidar especificaciones.

---

## 5. Requisitos Satisfechos por Navegación, Control e Iluminación

A continuación se listan los requisitos del pliego satisfechos por los subsistemas `04_1`, `04_2` y `04_3`, ordenados según la estructura del Anexo I:

* **`RGEN-09` — Detección de obstáculos y modo sigiloso**: Detección de obstáculos estáticos y dinámicos mediante tecnologías radiantes (LiDAR, radar) y no radiantes (visión por computador), permitiendo activar o desactivar las radiantes entre modo `NORMAL` y `SIGILOSO` desde los equipos de control en cualquier modo de operación.
  * Satisfecho: `SistemaNavegacion` (`SubsistemaSensores` y `SistemaVisionComputador`).
  * Cómo se satisface: `SubsistemaSensores` recibe la orden de modo de detección desde `SistemaComunicacionesEmbarcado` para encender o apagar `SensorLidar` y `SensorRadar`, manteniendo operativa en todo momento la rama pasiva de `SistemaVisionComputador` hacia `ModuloDeteccionEvasion`.

* **`RGEN-17` — Frenado automático ante riesgo de colisión**: Frenado automático progresivo ante riesgo de colisión siempre que sea posible, con posibilidad de inhabilitación manual para evitar bloqueos por falsos señuelos.
  * Satisfecho: `ModuloFrenadoSeguridad` (`SistemaControl`).
  * Cómo se satisface: `ComputadorAutonomia` evalúa el riesgo de colisión sobre el mapa unificado (respaldado por un supervisor de seguridad) y envía la consigna al `ModuloFrenadoSeguridad`, que aplica frenado progresivo sobre el *Drive-by-Wire* salvo señal de inhabilitación manual recibida desde `SistemaComunicacionesEmbarcado`.

* **`RGEN-20` — Iluminación perimetral 360°**: Medios de iluminación perimetral en 360° para apoyar la consciencia situacional del operador y el trabajo nocturno o en baja visibilidad.
  * Satisfecho: `SistemaIluminacion`.
  * Cómo se satisface: `SistemaIluminacion` proporciona cobertura luminosa de 360° alimentada desde la planta motriz y regulada de 0 a 100 % mediante consignas de intensidad emitidas por `ComputadorAutonomia` (`SistemaControl`).

* **`RGEN-22` — Consciencia situacional mediante visión y sensores**: Medios de captación de imagen y sensores para teleoperación y trabajo con implementos, incluyendo cámaras laterales independientes, visión de profundidad 360°, cámara térmica para puntos calientes y transductores de contacto y dinámicos del tren de rodaje.
  * Satisfecho: `SubsistemaCamaras` y `TransductoresContactoDinamicos` (`SistemaNavegacion`).
  * Cómo se satisface: `SubsistemaCamaras` integra las cámaras ópticas 360°, laterales izquierda/derecha y térmica nocturna enviando vídeo a `SistemaComunicacionesEmbarcado`, mientras `TransductoresContactoDinamicos` supervisa en tiempo real el estado del tren de rodaje y lo transmite por el bus de telemetría.

* **`RNAV-01` — Navegación en entorno GNSS denegado**: Navegación autónoma precisa ante inhibición o ausencia de señal satelital.
  * Satisfecho: `OdometriaVisualInercialVIO` (`SistemaNavegacion`).
  * Cómo se satisface: `OdometriaVisualInercialVIO` estima la posición y trayectoria mediante odometría visual-inercial y entrega esa referencia directamente a `ComputadorAutonomia` (`SistemaControl`) para mantener el guiado sin GNSS.

* **`ROPE-01` — Modo de operación teleoperado**: Modo teleoperado gobernable remotamente desde las estaciones de control (CPT en LOS y PMP en BLOS), desactivando las consignas de guiado y planificación autónoma.
  * Satisfecho: `GobiernoControl` (`SistemaControl`).
  * Cómo se satisface: `GobiernoControl` recibe las órdenes de cambio de modo desde `SistemaComunicacionesEmbarcado` y arbitra la transición entre `TELEOPERADO` y `NAVEGACION`, inhibiendo las consignas de planificación de `ComputadorAutonomia` cuando el vehículo opera en teleoperación.

* **`ROPE-05` — Submodos de navegación autónoma**: Incorporación de al menos cinco submodos habilitables antes y durante la misión: *waypoints*, punto de destino, vuelta a casa, *Follow-Me* y *shuttle* (lanzadera).
  * Satisfecho: `ComputadorAutonomia` (`SistemaControl`).
  * Cómo se satisface: `ComputadorAutonomia` ejecuta la planificación en ROS 2 y recibe desde `SistemaComunicacionesEmbarcado` la orden de activación y conmutación entre los cinco submodos de navegación autónoma contemplados en `SubmodoNavegacionAutonoma`.

* **`ROPE-06` — Detección y evasión (*Detect & Avoid*)**: Capacidad del sistema en modo autónomo para detectar y evadir obstáculos estáticos y dinámicos tanto en modo de detección `NORMAL` como `SIGILOSO`, recalculando trayectorias o maniobrando en alternativa.
  * Satisfecho: `ModuloDeteccionEvasion` y `ComputadorAutonomia` (`SistemaNavegacion` / `SistemaControl`).
  * Cómo se satisface: `ModuloDeteccionEvasion` fusiona en tiempo real los datos de LiDAR, radar y visión por computador en un mapa de obstáculos que `ComputadorAutonomia` utiliza para recalcular trayectorias evasivas hacia el *Drive-by-Wire*.


