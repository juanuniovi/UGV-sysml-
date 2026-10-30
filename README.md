# Modelo Modular de UGV Terrestre Pesado Dual en SysML v2


Este repositorio contiene la arquitectura formal de ingeniería de sistemas (MBSE) para un **UGV (Unmanned Ground Vehicle) Terrestre Pesado Multipropósito de uso Dual (Civil-Militar)** desarrollado según la especificación **OMG SysML v2** y adaptado a las prescripciones técnicas de un pliego real del **CDTI**.

El modelo se centra en la plataforma de ruedas (Lote 1: tracción 4x4, 6x6 u 8x8) completo junto con sus puestos de control, dron cenital y módulos de misión.

🌐 **Panel para la gestión del proyecto y Reparto de Tareas (GitHub Pages)**: [**https://juanuniovi.github.io/UGV-sysml-/**](https://juanuniovi.github.io/UGV-sysml-/)  *(sincronizado en tiempo real con los GitHub Issues para coordinación)*

## 1. Arquitectura general del Sistema

A continuación se muestra el diagrama básico de arquitectura física y funcional del UGV, dividido en 8 componentes, con las relaciones entre ellos de tipo **Información/Datos**, **Potencia/Energía** y **Ensamblaje/Mecánica**:

![Arquitectura de Componentes y Conexiones del Sistema UGV](Vistas%20graficas/diagrama_componentes_ugv.svg)

> 💡 Puedes abrir el archivo [`Vistas graficas/index.html`](Vistas%20graficas/index.html) directamente en el navegador para activar/desactivar cada tipo de flujo.




## 2. Estructura de Archivos (en `Modelos/`)

El modelo se distribuye en **11 archivos independientes** (8 de subcomponentes y 3 de soporte), cada uno con su propio espacio de nombres (`package`) y enlazados mediante directivas de importación (`private import`):

```text
Modelos/
├── 00_tipos_base.sysml          <- Magnitudes físicas (Masa, Potencia) y puertos estándar (Mecánico, Potencia, Bus, RF)
├── 01_barcaza.sysml             <- Barcaza estructural, chasis en V, cabestrante y puntos de anclaje (RGEN-02..05)
├── 02_tren_rodaje.sysml         <- Tren de ruedas independientes, suspensión regulable y servodirección (RLT1-01..05)
├── 03_planta_motriz.sysml       <- Planta híbrida: biocombustible 100%, baterías silenciosas y exportación 120kW (RGEN-11..19)
├── 04_navegacion_control.sysml  <- Cerebro GNC: autonomía waypoints, Follow-Me, Detect & Avoid y sensores 360° (ROPE, RNAV)
├── 05_comunicaciones.sysml      <- Comunicaciones tácticas BLOS/LOS con cifrado COMSEC (RCOM-01..03)
├── 06_estaciones_control.sysml  <- Puesto de Mando Portable (PMP - Linux) y Consola Ligera (CPT - LOS)
├── 07_uav_cenital.sysml         <- Dron aéreo de exploración y relé de comunicaciones con base en techo
├── 08_cargas_pago.sysml         <- Cargas de misión modulares: ISTAR (mástil), Logístico (palets) y MEDEVAC (heridos)
├── 09_sistema_ugv.sysml         <- Ensamblado principal (SoI), conexiones internas (IBD) y relaciones de acople
└── 10_comportamiento.sysml      <- Máquina de estados de los modos operativos (Teleoperado, Autónomo, Sigiloso, Degradado)
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
  

---
