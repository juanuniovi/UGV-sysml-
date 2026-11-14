# Arquitectura de Comunicaciones: Jerarquía y Conmutación por Fallo (Plan PACE)

![Jerarquía de Conmutación de Comunicaciones](/C:/Users/Usuario/.gemini/antigravity-cli/brain/4bbf1e67-72d6-42c6-a936-1390041b2388/esquema_protocolos_comunicaciones.jpeg)

Este documento define la **cadena secuencial de prioridad de canales y protocolos (1º al 5º Orden)** ante la pérdida o degradación del enlace en el UGV pesado dual.

---

## 1. Cadena de Conmutación ante Fallo (1º al 5º Orden)

| Nivel de Prioridad | Denominación y Enlace | Protocolo y Formato | Condición de Fallo / Transición | Comportamiento del Vídeo 360° |
| :--- | :--- | :--- | :--- | :--- |
| **1º ORDEN**<br>*(Principal)* | **Radio Directa LOS 2.4 GHz** con Consola Ligera (CPT) | **`UDP + micro-DDS con FEC`**<br>(Latencia < 20 ms, refresco 50 Hz) | Pérdida de línea de vista directa o distancia con operador desmontado > 1,5 km. | Vídeo H.265 Full HD (1080p @ 30 fps) activo hacia la pantalla de la CPT. |
| **2º ORDEN**<br>*(Alternativo)* | **Red Táctica MANET / SDR BLOS** con Puesto de Mando (PMP) | **`STANAG 4586 (Ed. 4) / JAUS`** sobre enlace táctico IP | Apantallamiento orográfico del terreno (vaguadas, desfiladeros, colinas). | Vídeo H.265 Full HD continuo con adaptación de bitrate a la calidad de radio. |
| **3º ORDEN**<br>*(Contingencia)* | **Relé Aéreo con UAV Cenital Embarcado** (`RCOM-02`) | **`STANAG 4586`** sobre micro-dron cautivo / pop-up puntual | Apantallamiento orográfico insalvable sin dron. Si hay amenaza de fuego o el dron es inoperable, se salta al 4º orden. | Vídeo comprimido adaptativamente a 720p @ 15 fps para no saturar el relé. |
| **4º ORDEN**<br>*(Respaldo Militar)* | **Radio Táctica Militar de Combate (CNR)** en VHF (30–88 MHz) | **`Telegramas Compactos BMS-ET / C2`** con salto ágil FHSS | Pérdida total de señal y timeout de latido (*heartbeat*) > 1.000 ms. | **VÍDEO APAGADO AL 100%** (0 Mbps). Se reserva el 100% del canal al telemando (`RSW-06`). |
| **5º ORDEN**<br>*(Failsafe Crítico)* | **Parada Automática de Emergencia** (`RGEN-17`) | Alerta interna directa hacia `ModuloFrenadoSeguridad` en GNC | El vehículo detiene la tracción y bloquea los frenos mecánicos de inmediato. | Inmóvil en retención activa hasta recuperar enlace válido de telemando. |

---

## 2. Reglas del Gestor de Conmutación (*Failover Controller*)

1. **Umbral de Potencia de Señal (RSSI / SNR)**:
   * Si la potencia cae por debajo de -85 dBm sostenida durante más de 1,5 segundos, el gestor evalúa la conmutación al siguiente nivel.
2. **Tasa de Pérdida de Paquetes (PER)**:
   * Si el ratio de paquetes erróneos o perdidos supera el 15% durante 2 segundos, se inicia el cambio de canal.
3. **Histéresis de Retorno**:
   * Para volver a un orden superior (ej. de 2º a 1º), el canal principal debe mantenerse estable y sin fluctuaciones durante al menos **3 segundos ininterrumpidos** para evitar conmutaciones oscilatorias.
4. **Supervisión de Latido (*Heartbeat Watchdog*)**:
   * La estación activa envía un paquete de latido cada 200 ms.
   * Si transcurren **1.000 ms** sin recibir latido en ninguno de los canales activos (LOS, BLOS, UAV ni Radio Militar), se declara el fallo catastrófico de enlace y se ejecuta el **5º Orden** (frenado inmediato `RGEN-17`).

---

## 3. Política de Priorización de Tráfico (QoS - `RSW-06`)

* **Prioridad 1 (Crítica)**: Consignas de dirección, aceleración, freno de emergencia y latido *heartbeat*.
* **Prioridad 2 (Alta)**: Trazas de posición de navegación (odometría VIO / GNSS) y mapa local de detección de obstáculos (D&A).
* **Prioridad 3 (Media)**: Telemetría de estado del vehículo (voltajes, temperaturas, combustible/batería).
* **Prioridad 4 (Baja / Degenerable)**: Canales de vídeo diurno panorámico 360° y cámara térmica.

---

## 4. Matriz Gráfica de Tráfico y Enrutamiento Físico

![Matriz de Tráfico y Enrutamiento](/C:/Users/Usuario/.gemini/antigravity-cli/brain/4bbf1e67-72d6-42c6-a936-1390041b2388/esquema_flujos_y_enrutamiento.jpeg)

Esta matriz mapea cada flujo de datos generado o consumido por el UGV con su protocolo de transporte, su etiqueta de prioridad en colas QoS (RSW-06), su ancho de banda estimado y el medio físico de radio por donde transita.
