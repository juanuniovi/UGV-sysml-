# Hoja de Ruta y Guía Paso a Paso: Comunicaciones Tácticas Embarcadas (Subsistema Comunicaciones)

> **Documento de trabajo personal para Pelayo Rodríguez (`@pprguez2005-byte` / PelayoPacheRodriguez)**  
> *Este archivo sirve de cuaderno de bitácora, guía técnica y referencia rápida para el desarrollo de `Modelos/05_comunicaciones.sysml`.*

---

## 📋 Matriz Integral de Requisitos del Pliego Aplicables al Subsistema de Comunicaciones

A continuación se recopilan **todos los requisitos del pliego** (tanto directos como transversales o indirectos, por sutiles que sean) que impactan en el diseño del subsistema de comunicaciones tácticas embarcadas, detallando su justificación técnica y cómo se resuelven en el modelo SysML v2:

| Código Requisito | Denominación Oficial / Resumen del Pliego | ¿Por qué se relaciona con Comunicaciones? | ¿Cómo lo resolvemos en el Modelo SysML v2? |
| :--- | :--- | :--- | :--- |
| **`RCOM-01`** | **Enlace Táctico en Línea de Vista (LOS)**<br>Enlace de datos de corto alcance para telemando y visualización en tiempo real. | Es el canal primario de pilotaje cercano. Exige latencia muy reducida (<100 ms) y tasa de refresco alta para evitar desfases en el control visual directo desde la Consola CPT. | Modelar `part def RadioEnlaceTacticoLOS` con `port rfPortLOS : RFPort`, atributos de latencia/frecuencia (UHF/banda C), y requisito formal `ReqEnlaceTacticoLOS`. |
| **`RCOM-02`** | **Enlace Fuera de Línea de Vista (BLOS) y Relé UAV**<br>Control a larga distancia sin visión directa y soporte de repetidores. | Permite el gobierno a distancia desde el Puesto de Mando (PMP). Si el terreno accidentado corta el enlace, debe enlazar con el transpondedor del dron cenital embarcado. | Modelar `part def RadioEnlaceTacticoBLOS` con `port rfPortBLOS : RFPort`, y verificar en `09_sistema_ugv.sysml` la conexión con `puestoMando.rfPortBLOS` y `uavCenital.rfPortRelay`. |
| **`RCOM-03`** | **Seguridad COMSEC y Protección Electrónica**<br>Cifrado militar y resistencia contra guerra electrónica (EW/Jamming). | El enlace inalámbrico militar puede ser interceptado, interferido o suplantado. Requiere cifrado hardware punto a punto y técnicas de baja detectabilidad (LPI/LPD). | Modelar `part def ModuloCifradoCOMSEC` con algoritmos de encriptación hardware, soporte de salto de frecuencia (FHSS) y requisito formal `ReqSeguridadComunicacionesCOMSEC`. |
| **`RSW-06`** | **Protocolos Tácticos y Redundancia de Software**<br>Manejo robusto de paquetes, serialización y tolerancia a pérdidas. | En entornos hostiles la tasa de pérdida de paquetes (PER) fluctúa. Se deben priorizar paquetes críticos de telemando frente a flujos pesados de vídeo. | Modelar paquetes de datos tipados (`item def ComandoControlRemoto`, `item def PaqueteTelemetriaUGV`), buffers de retransmisión y requisito `ReqProtocoloComunicacionesRedundante`. |
| **`RGEN-01`** | **Gobierno desde Puesto de Mando Portable (PMP)**<br>Supervisión táctica y control de la misión desde puesto remoto. | El PMP es el centro C2 principal del UGV. Todas las órdenes de planificación y telemetría de misión viajan a través del enlace de comunicaciones de largo alcance. | Conexión formal en `09_sistema_ugv.sysml` mediante `connection c_rf_blos connect puestoMando.rfPortBLOS to vehiculo.comunicaciones.rfPortBLOS`. |
| **`RGEN-04`** | **Concepción Nativa No Tripulada**<br>Vehículo sin puesto para conductor humano ni habitáculo a bordo. | Al no haber piloto físico, la totalidad de la conducción, supervisión y supervivencia del UGV depende al 100% de la disponibilidad y robustez del enlace de datos. | Implementar redundancia dual (canales LOS y BLOS independientes) y monitorización continua del enlace (`EstadoEnlaceTactico`). |
| **`RGEN-09`** | **Detección de Obstáculos y Modos NORMAL / SIGILOSO**<br>Conmutación entre modo con emisiones activas y modo sigiloso pasivo. | El operador puede ordenar el modo SIGILOSO para evitar ser detectado. Comunicaciones debe reducir su firma electromagnética (bajar potencia RF o silencio radio selectivo). | Modelar `part def GestorEmisionesTacticas`, puerto `entradaModoDeteccion : DataBusPort` hacia GNC, y acción de conmutación de potencia radiante / silencio de RF. |
| **`RGEN-17`** | **Frenado Automático de Seguridad / Failsafe de Enlace**<br>Parada automática ante riesgo de colisión o anomalía crítica. | Si se corta el enlace de radio de telemando de forma prolongada, el UGV no puede quedar descontrolado: debe detectar la pérdida de señal y ordenar parada segura. | Generar una señal de alerta (*heartbeat watchdog*) por el `dataBus` hacia `ModuloFrenadoSeguridad` (en GNC/Control) para activar el freno ante `timeout` de enlace. |
| **`RGEN-20`** | **Consciencia Situacional 360° (Cámaras Ópticas)**<br>Visión panorámica diurna del entorno del vehículo para el operador. | Estas cámaras generan múltiples flujos de vídeo de alta definición que saturan el enlace de comunicaciones descendente (*downlink*). | Definir `item def FlujoVideoComprimido`, codecs con compresión adaptativa (H.264/H.265) y dimensionar el ancho de banda del canal de radio (Mbps). |
| **`RGEN-22`** | **Visión Térmica / Nocturna**<br>Cámara infrarroja para conducción nocturna y detección térmica. | Flujo de vídeo térmico adicional que debe transmitirse en tiempo real hacia las pantallas tácticas del PMP y de la CPT en misiones nocturnas. | Multiplexado en el transceptor de comunicaciones con asignación de prioridad dinámica respecto a la telemetría y el vídeo óptico. |
| **`ROPE-01..03`** | **Estaciones de Control Remoto (PMP y Consola CPT)**<br>Especificación funcional del telemando ligero y la estación de mando. | Comunicaciones debe ser el puente transparente entre las interfaces de ambas estaciones y el computador de a bordo (GNC). | Definición de puertos RF emparejados (`RFPort`), sincronización bidireccional de estados y correspondencia de puertos de red. |
| **`ROPE-05`** | **Navegación Autónoma por Waypoints y Follow-Me**<br>Ejecución de misiones preprogramadas o seguimiento de tropas. | Las coordenadas de waypoints y órdenes de misión se cargan vía enlace de radio; el operador monitoriza en tiempo real la traza seguida en el mapa digital. | Tráfico de datos C2 encapsulado en `ComandoControlRemoto` que transita por `dataBus` entre Comunicaciones y `ComputadorAutonomia`. |
| **`ROPE-06`** | **Detección y Evasión en Tiempo Real (Detect & Avoid)**<br>Supervisión de maniobras evasivas frente a obstáculos. | El UGV debe retransmitir al operador el mapa local de obstáculos detectados para que el puesto de mando mantenga consciencia situacional del motivo de evasión. | Canal de telemetría de obstáculos descendente transmitido por paquetes periódicos en el bus de datos hacia el enlace de radio. |
| **`RNAV-01`** | **Navegación en Entornos de GNSS Denegado**<br>Navegación inercial/VIO cuando se pierde o bloquea la señal satelital. | Sin satélites, el enlace de comunicaciones puede proporcionar balizamiento relativo respecto al PMP o triangulación mediante el relé del UAV cenital. | Incluir en los paquetes de enlace marcas de tiempo de alta precisión (sincronización temporal PTP/IEEE 1588) y telemetría de calidad de navegación. |
| **`RGEN-28` / `RGEN-29`** | **Estabilidad e Interfaces con Cargas de Pago de Misión**<br>Puntos de anclaje e interfaces normalizadas para módulos de misión. | Las cargas de misión acopladas (mástil ISTAR, brazo EOD, equipos MEDEVAC) necesitan enviar sus datos y recibir órdenes desde el PMP a través del UGV. | Proveer función de pasarela (*gateway*) en el `dataBus` del subsistema de comunicaciones para multiplexar el tráfico de las cargas de misión. |
| **`RLT1-08`** | **Masa Máxima en Orden de Misión (<= 9.000 kg)**<br>Límite superior de peso total admisible para toda la plataforma. | Los transceptores, amplificadores de potencia, módulos de antena, cableado coaxial y apantallamiento electromagnético suman peso directo a la plataforma. | Asignar y acotar el atributo `masaSubsistemaKg : Masa` en `SistemaComunicacionesEmbarcado` dentro de un presupuesto estricto (< 40 kg). |
| **`RGEN-06`** | **Resistencia Ambiental Severa (Climatología Extrema)**<br>Operación entre -20 °C y +50 °C, humedad, lluvia, polvo y vibración. | Las antenas y conectores RF están expuestos en el techo de la barcaza a impactos de ramas, polvo, vibración todoterreno y entrada de agua. | Definir en las partes exteriores requisitos de rugerización militar (MIL-STD-810H), grado de protección estanco IP67/IP68 y conectores de grado militar. |
| **`RLT1-10`** | **Capacidad de Vadeo sin Preparación (>= 0,75 m)**<br>Cruce de cursos de agua dulce o salada sin preparativos mecánicos. | Si el agua alcanza pasamuros de cables coaxiales o cajas de derivación de comunicaciones montadas en el chasis, podría provocar cortocircuitos o avería de RF. | Garantizar estanqueidad hidrostática en el puerto `chassisMount` y en todos los pasamuros y conectores situados por debajo de la cota de vadeo. |

---

## 🎯 Clasificación por Objetivos Finales de Comunicaciones

Para abordar el subsistema de manera ordenada y sin saturar el modelo, los requisitos se agrupan en **6 objetivos finales** bien diferenciados. A continuación se define cada objetivo, su enfoque técnico y los códigos de requisitos que le hacen referencia:

### 📡 Grupo 1: Enlace Táctico de Telemando Directo y Conducción en Proximidad (LOS)
* **Objetivo Final**: Proporcionar un canal de radiofrecuencia directo en línea de vista (*Line-of-Sight*) entre el UGV y el operador desmontado que utiliza la Consola Portable de Operador (CPT). El canal debe ofrecer latencia ultrabaja (< 100 ms) y alta tasa de refresco para telemando visual continuo, además de soportar la descarga de vídeo en tiempo real para guiado seguro.
* **Componentes SysML v2**: `RadioEnlaceTacticoLOS`, `port rfPortLOS : RFPort`, `item def ComandoControlRemoto`.
* **Requisitos que le hacen referencia**: `[RCOM-01, ROPE-01, ROPE-03, RGEN-04, RGEN-20]`.

---

### 🛰️ Grupo 2: Enlace Táctico de Mando, Telemetría y Operación Remota a Larga Distancia (BLOS y Relé Aéreo)
* **Objetivo Final**: Garantizar la supervisión y control de la misión fuera de línea de vista (*Beyond Line-of-Sight*) desde el Puesto de Mando Portable (PMP). Si la orografía o la distancia degradan el enlace directo, el sistema debe ser capaz de retransmitir el flujo a través del transpondedor del UAV cenital amarrado/embarcado en el techo del vehículo.
* **Componentes SysML v2**: `RadioEnlaceTacticoBLOS`, `port rfPortBLOS : RFPort`, conexión con `uavCenital.rfPortRelay` y `puestoMando.rfPortBLOS`.
* **Requisitos que le hacen referencia**: `[RCOM-02, RGEN-01, ROPE-02, ROPE-05, ROPE-06, RNAV-01]`.

---

### 🔐 Grupo 3: Ciberseguridad Táctica, Cifrado y Protección Electrónica (COMSEC / EW)
* **Objetivo Final**: Blindar la información contra interceptación, suplantación (spoofing) e inhibición (jamming) enemiga en el campo de batalla mediante cifrado hardware extremo a extremo (COMSEC), técnicas de baja probabilidad de intercepción y detección (LPI/LPD), y salto ágil de frecuencia (FHSS).
* **Componentes SysML v2**: `ModuloCifradoCOMSEC`, algoritmos de encriptación y gestión de claves seguras.
* **Requisitos que le hacen referencia**: `[RCOM-03, RGEN-01, RGEN-04]`.

---

### 🤫 Grupo 4: Control de Emisiones Electromagnéticas y Modo Silencio Radio (Sigiloso)
* **Objetivo Final**: Coordinar con el sistema de navegación y las estaciones de control la firma electromagnética del UGV. Al conmutar al modo SIGILOSO (`RGEN-09`), el subsistema debe ser capaz de atenuar drásticamente su potencia radiada o entrar en silencio radio total para evitar la radiolocalización por parte de receptores enemigos.
* **Componentes SysML v2**: `GestorEmisionesTacticas`, puerto de control de emisión conectado con GNC y acción `ConmutarFirmaElectromagnetica`.
* **Requisitos que le hacen referencia**: `[RGEN-09, RGEN-15]`.

---

### 🛡️ Grupo 5: Fiabilidad de Transporte de Datos y Failsafe de Seguridad (Watchdog de Enlace)
* **Objetivo Final**: Implementar una capa de transporte tolerante a fallos y pérdidas de paquetes que priorice las órdenes críticas de movimiento frente a flujos pesados de vídeo (QoS táctico). Asimismo, debe incluir supervisión continua de latido (*heartbeat*); si se corta el enlace con el operador durante un tiempo predeterminado, debe alertar a GNC para que detenga el vehículo de forma segura.
* **Componentes SysML v2**: Paquetes tipados (`item def`), buffers de retransmisión, señal de supervisión hacia `ModuloFrenadoSeguridad`.
* **Requisitos que le hacen referencia**: `[RSW-06, RGEN-17]`.

---

### ⚙️ Grupo 6: Interfaces Físicas, Pasarela de Datos y Resistencia Ambiental
* **Objetivo Final**: Cumplir con los condicionantes físicos del vehículo: actuar como pasarela (*gateway*) para reenviar telemetría de las cargas de pago de misión montadas en la plataforma, respetar el límite de peso de equipos de a bordo (< 40 kg), resistir climatología severa (MIL-STD-810H) y asegurar estanqueidad ante vadeo sin preparación previa (0,75 m).
* **Componentes SysML v2**: `SistemaAntenasEmbarcado`, puertos `chassisMount`, `powerInput` y `dataBus`, sellado estanco y presupuestos de masa.
* **Requisitos que le hacen referencia**: `[RLT1-08, RLT1-10, RGEN-06, RGEN-28, RGEN-29]`.

---

### 🚀 Selección para comenzar: Grupo 1 (Enlace Táctico LOS) + Esqueleto Estructural Base

> **Punto de partida acordado**:  
> Comenzamos abordando el **Grupo 1 (Enlace Táctico en Línea de Vista - LOS)** junto con la formalización del esqueleto estructural del subsistema en `05_comunicaciones.sysml`.  
> Esto nos permite establecer la base de `part def`s, tipar `RadioEnlaceTacticoLOS`, formalizar el requisito `RCOM-01` (`ReqEnlaceTacticoLOS`) y conectar de forma verificable con la consola CPT (`ROPE-01..03`), dejando una arquitectura limpia y preparada para ir incorporando sucesivamente los siguientes grupos.

---

## 🎯 Objetivo General

Evolucionar [`Modelos/05_comunicaciones.sysml`](05_comunicaciones.sysml) de forma modular, progresiva y limpia, adoptando la sintaxis y patrones de **SysML v2** consolidados en el proyecto:
- Desglosar los componentes internos del subsistema de comunicaciones tácticas embarcadas.
- Formalizar los requisitos del pliego (`RCOM-01..03`, `RSW-06` y la coordinación con el modo sigiloso `RGEN-09`).
- Modelar puertos e interfaces tipadas de potencia, bus de datos y radiofrecuencia (LOS, BLOS y relé con UAV).
- Garantizar la trazabilidad y la integración limpia con el resto del sistema UGV sin invadir subsistemas de otros compañeros.

---

## 🗺️ Mapa de Fases Incrementales

```
[Fase 1: Estructura Funcional, Partes y Requisitos del Pliego]  <--- PUNTO DE PARTIDA
   │
   ├──> [Fase 2: Parámetros Técnicos, Atributos de RF y Potencia]
   │
   ├──> [Fase 3: Puertos de Flujo de Datos (Items de C2, Vídeo y Telemetría)]
   │
   └──> [Fase 4: Integración Global en 09_sistema_ugv.sysml y Vistas en 11_vistas.sysml]
```

---

## 📌 Fase 1 (Prioritaria): Estructura Funcional y Requisitos del Pliego

### Meta de la Fase 1
Sustituir el stub preliminar por una descomposición formal en SysML v2 que defina las partes específicas del subsistema de comunicaciones y formalice los requisitos contractuales con bloques `requirement def` y relaciones `satisfy`.

### Paso a Paso de Modelado:
1. **Definir Partes Específicas (`part def`):**
   - `RadioEnlaceTacticoLOS`: Transceptor para enlace en línea de vista (*Line-of-Sight*), baja latencia y alta tasa de refresco para telemando cercano con la Consola Ligera (CPT).
   - `RadioEnlaceTacticoBLOS`: Transceptor táctico de largo alcance fuera de línea de vista (*Beyond Line-of-Sight*), con modulación SDR (*Software Defined Radio*) para enlace con el Puesto de Mando Portable (PMP).
   - `ModuloCifradoCOMSEC`: Procesador criptográfico hardware para cifrado de flujos C2, telemetría y vídeo, gestión de claves y técnicas anti-interferencia / baja probabilidad de intercepción (LPI/LPD).
   - `SistemaAntenasEmbarcado`: Conjunto de antenas omnidireccionales y de polarización adecuada montadas sobre la barcaza, con perfil optimizado y resistencia a vibraciones e intemperie.
   - `GestorEmisionesTacticas`: Controlador para gestión de potencia de emisión y soporte al modo SILENCIO RADIO / SIGILOSO (`RGEN-09`).

2. **Definir Requisitos Trazables del Pliego:**
   - `RCOM-01` (`ReqEnlaceTacticoLOS`): Enlace de telemando y vídeo en línea de vista (LOS) para operación local segura con baja latencia.
   - `RCOM-02` (`ReqEnlaceTacticoBLOS`): Enlace de datos táctico de largo alcance fuera de línea de vista (BLOS) y compatibilidad con relé aéreo a través del UAV cenital.
   - `RCOM-03` (`ReqSeguridadComunicacionesCOMSEC`): Cifrado militar punto a punto, protección contra contramedidas electrónicas (EW) y salto de frecuencia / espectro ensanchado.
   - `RSW-06` (`ReqProtocoloComunicacionesRedundante`): Arquitectura de software y transporte con control de errores, retransmisión adaptativa y redundancia de datos críticos de control.
   - Coordinación con `RGEN-09`: Capacidad de silenciar emisiones electromagnéticas o reducir la firma RF al activarse el modo de detección sigiloso.

3. **Establecer Relaciones `satisfy`:**
   - Vincular cada parte o atributo con su requisito formal correspondiente (`satisfy requirement : Req... by ...;`).

---

## 🔭 Fase 2: Parámetros Técnicos, Atributos de RF y Potencia

*Una vez aprobada y consolidada la Fase 1, se cuantifican las propiedades físicas y electromagnéticas del subsistema:*

- **Presupuesto de Masa y Potencia:**
  - `masaSubsistemaKg : Masa` (impacto en el balance global de masa del vehículo `RLT1-08`).
  - `consumoElectricoW : Potencia` (alimentación desde el bus de aviónica de la Planta Motriz).
- **Parámetros de Radiofrecuencia y Alcance:**
  - `alcanceNominalLOSKm : Real` (alcance operativo directo con la CPT).
  - `alcanceNominalBLOSKm : Real` (alcance en operación remota con el PMP).
  - `bandaFrecuenciaLOS : String` / `bandaFrecuenciaBLOS : String` (ej. UHF táctico, banda S / C).
  - `latenciaMaximaTelemandoMs : Real` (requisito temporal estricto para telemando seguro).
  - `anchoBandaDatosMbps : Real` (capacidad suficiente para transmitir múltiples flujos de vídeo de cámaras y sensores 360° en tiempo real).

---

## 🔌 Fase 3: Puertos de Flujo de Datos y Protocolos Tipados

*Para que la interacción con Navegación y Control (GNC) y las Estaciones de Control sea totalmente coherente y tipada:*

1. **Definir Items de Información (`item def`):**
   - `ComandoControlRemoto`: Paquete de consignas de movimiento, cambio de modo de conducción o parada de emergencia recibidas desde PMP o CPT.
   - `PaqueteTelemetriaUGV`: Estado de la plataforma (temperaturas, voltajes, combustible/batería, orientación IMU, posición estimada, velocidad).
   - `FlujoVideoComprimido`: Canales de vídeo digital codificado procedentes de la suite de cámaras y visión por computador.
   - `EstadoEnlaceTactico`: Calidad del enlace (RSSI, SNR, tasa de paquetes perdidos, canal activo, estado COMSEC).

2. **Refinar los Puertos del Subsistema:**
   - `port chassisMount : MechanicalMountPort;` (anclaje mecánico en la barcaza).
   - `port powerInput : ElectricalPowerPort;` (alimentación eléctrica 24 V/28 V DC).
   - `port dataBus : DataBusPort;` (bus digital de a bordo: Ethernet táctico / CAN Bus hacia el computador de GNC).
   - `port rfPortLOS : RFPort;` (interfaz RF hacia la Consola CPT).
   - `port rfPortBLOS : RFPort;` (interfaz RF hacia el Puesto de Mando PMP y relé del UAV cenital).

---

## 🧩 Fase 4: Integración Global y Vistas de Arquitectura

- **Verificación de Enlaces en [`Modelos/09_sistema_ugv.sysml`](09_sistema_ugv.sysml):**
  - `c_power_comms`: Enlace con `plantaMotriz.powerOutputAvionics`.
  - `c_bus_comms_gnc`: Enlace bidireccional con `navegacionControl.dataBus`.
  - `c_rf_blos`: Enlace RF del UGV con `puestoMando.rfPortBLOS`.
  - `c_rf_los`: Enlace RF del UGV con `consolaCPT.rfPortLOS`.
  - `c_rf_uav`: Enlace RF del UGV con `uavCenital.rfPortRelay`.

- **Vistas Específicas del Subsistema de Comunicaciones en [`Modelos/11_vistas.sysml`](11_vistas.sysml):**
  - **`vistaConexionesComunicaciones : InterconnectionView` (IBD)**: Vista de interconexión interna que refleja la topología completa entre los **6 grupos funcionales** de comunicaciones:
    ```sysml
    // Vista: Interconexiones internas del Subsistema de Comunicaciones (equivalente a IBD)
    view vistaConexionesComunicaciones : InterconnectionView {
        doc /* Muestra la topología de interconexiones internas entre los 6 grupos funcionales:
               Radio LOS (G1), Radio BLOS (G2), Cifrador COMSEC (G3), Gestor de Emisiones Sigiloso (G4),
               Supervisor Watchdog Failsafe (G5), Antenas Exteriores y Pasarela de Cargas (G6) */
        expose SubsistemaComunicaciones::SistemaComunicacionesEmbarcado;
    }
    ```
  - **`vistaEstructuraComunicaciones : GeneralView` (BDD)**: Jerarquía completa de partes, atributos, puertos y requisitos de los 6 grupos de comunicaciones.
  - **Actualización de `vistaRequisitos`**: Asegurar que `expose SubsistemaComunicaciones::*;` recoge los nuevos requisitos (`RCOM-01`, `RCOM-02`, `RCOM-03`, `RSW-06`).

---

## 🖧 Arquitectura de Interconexiones entre los 6 Grupos (Topología IBD)

La siguiente tabla resume cómo se comunican internamente los 6 grupos dentro de `SistemaComunicacionesEmbarcado`:

```
               [dataBus (GNC/Vehículo)]
                         │
        ┌────────────────┼────────────────┐
        │ (Supervisión)  │ (Pasarela C2)  │ (Flujo Datos Planos)
        ▼                ▼                ▼
   ┌──────────┐    ┌──────────┐    ┌────────────────────┐
   │ Grupo 5  │    │ Grupo 6  │    │      Grupo 3       │
   │ Watchdog │    │ Pasarela │    │   Modulo COMSEC    │
   │ Failsafe │    │  Cargas  │    │(Cifrado/Descifrado)│
   └────┬─────┘    └──────────┘    └──────┬──────┬──────┘
        │                                 │      │
 (Alerta Timeout)             (Cifrado LOS)│      │(Cifrado BLOS)
        ▼                                 ▼      ▼
   ┌──────────────┐               ┌──────────┐  ┌──────────┐
   │ Frenado Seg. │   Control RF  │ Grupo 1  │  │ Grupo 2  │
   │   (en GNC)   │ ◄──────────── │Radio LOS │  │Radio BLOS│
   └──────────────┘ (Grupo 4:     └───┬──────┘  └───┬──────┘
                    Gestor Sigilo)    │             │
                                      ▼             ▼
                              ┌─────────────────────────────┐
                              │           Grupo 6           │
                              │   Sistema Antenas y RF      │
                              └──────┬───────────────┬──────┘
                                     │               │
                                     ▼               ▼
                                 rfPortLOS       rfPortBLOS
                                (Consola CPT)    (PMP / UAV)
```

1. **`dataBus` ↔ Grupo 3 (`moduloCifradoCOMSEC`)**: Los datos de control y telemetría pasan obligatoriamente por el procesador criptográfico antes de alcanzar cualquier radio.
2. **Grupo 3 (`moduloCifradoCOMSEC`) ↔ Grupo 1 (`radioLOS`) & Grupo 2 (`radioBLOS`)**: Flujos cifrados independientes para telemando visual cercano (LOS) y enlace táctico a larga distancia (BLOS).
3. **Grupo 4 (`gestorEmisionesTacticas`) ↔ Grupo 1 & Grupo 2**: Líneas internas de control de RF para silenciar o bajar potencia según el modo SIGILOSO (`RGEN-09`).
4. **`dataBus` ↔ Grupo 5 (`supervisorEnlaceWatchdog`)**: Monitoriza el tráfico de entrada; si no detecta paquetes de telemando en `T_failsafe`, genera una señal de emergencia hacia el freno en GNC (`RGEN-17`).
5. **Grupo 1 & 2 ↔ Grupo 6 (`sistemaAntenas`) ↔ `rfPortLOS` / `rfPortBLOS`**: Conexiones de RF que pasan por el conjunto de antenas exteriores montadas en chasis (`RGEN-06`, `RLT1-10`).


---

## 💡 Buenas Prácticas y Reglas del Proyecto

- ✅ **Regla de Oro de Git**: No trabajes directamente sobre `main`. Crea una rama dedicada para tu trabajo (ej. `feat/comunicaciones-tacticas`).
- ✅ **Flujo OpenSpec**: Todo cambio material sigue el ciclo `propose` -> revisión y aprobación -> `apply` -> verificación -> `archive` -> `merge`.
- ✅ **Validación con Spec42**: Comprobar periódicamente que no se introducen errores sintácticos ni advertencias (`0 errores, 0 avisos`).
- ✅ **Imports limpios**: Utilizar siempre `private import ScalarValues::*;` y `private import TiposBase::*;`.
- ✅ **No invadir otros subsistemas**: Mantén tus cambios en `05_comunicaciones.sysml` y limita los cambios en `09_sistema_ugv.sysml` exclusivamente a las conexiones de tus puertos.
- ✅ **Protección de requisitos**: No modifiques ni relajes requisitos ya aprobados sin justificación técnica y autorización expresa.
