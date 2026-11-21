# Guion de Presentación: Comunicaciones Tácticas UGV

> **Autor:** Pelayo Pache Rodríguez  
> **Duración estimada:** 3 a 5 minutos  
> **Objetivo:** Explicar a los compañeros del equipo de forma muy clara y directa cómo funciona el subsistema de comunicaciones y qué muestran las vistas de SysML v2.

---

### Diapositiva 1: Portada
**Qué decir:**
> *"Hola a todos. Hoy os voy a explicar de forma muy resumida cómo tenemos planteado el subsistema de comunicaciones tácticas del UGV y las vistas que hemos modelado en SysML v2. La idea era dejar un modelo muy sencillo, fácil de entender y que refleje exactamente lo que acordamos sobre los protocolos de respaldo."*

---

### Diapositiva 2: ¿Por qué son críticas las comunicaciones?
**Qué decir:**
> *"Como sabéis, nuestro UGV es un vehículo de 9 toneladas 100% no tripulado: no lleva ningún piloto dentro de la barcaza. Esto significa que si perdemos la comunicación por radio, el vehículo está totalmente ciego.*  
> *Para solucionar esto, no dependemos de un solo canal: tenemos una cadena de 5 niveles que llamamos Plan PACE. Si un canal se corta o el terreno lo tapa, el sistema conmuta automáticamente al siguiente. Y si todo falla por completo, el vehículo tiene una orden directa para clavar los frenos en el acto."*

---

### Diapositiva 3: La Cadena de Conmutación en 5 Órdenes (Plan PACE)
**Qué decir:**
> *"Aquí podéis ver los 5 niveles en orden de prioridad:*
> 1. *El **1º Orden** es la radio directa LOS en 2.4 GHz con la consola portátil (CPT). Es para el operador que va a pie cerca del UGV, con latencia mínima (menos de 20 ms) y vídeo Full HD a 30 fps.*
> 2. *El **2º Orden** es el enlace BLOS a larga distancia con el Puesto de Mando (PMP) mediante red MANET táctica a más de 5 km.*
> 3. *El **3º Orden** es la contingencia por dron: si el UGV se mete en una vaguada o desfiladero y la montaña tapa el enlace con el Puesto de Mando, usamos el dron cautivo del techo como repetidor aéreo.*
> 4. *El **4º Orden** es la radio militar de combate en VHF (30 a 88 MHz). Tiene mucho alcance por difracción del terreno, pero muy poco ancho de banda. Por eso, aquí **apagamos el vídeo al 100%** para reservar todo el canal exclusivamente a las órdenes de movimiento y freno.*
> 5. *Y el **5º Orden** es el failsafe de seguridad: si pasan más de 1.000 milisegundos sin recibir señal de latido en ningún canal, el vehículo bloquea los frenos automáticamente para evitar accidentes."*

---

### Diapositiva 4: Esquema Simplificado: Partes y Flujo de Comunicaciones
**Qué decir:**
> *"Para que no nos perdamos con los diagramas SysML v2, he preparado este esquema conceptual en 3 capas que resume exactamente cómo están organizadas las partes de comunicaciones:*
> - *En la **capa superior** están las tres fuentes externas: la Consola del operador, el Puesto de Mando y el Dron repetidor.*
> - *En la **capa intermedia** está la caja de comunicaciones del UGV. Lleva los módulos de radio receptores, el criptoprocesador COMSEC para que no nos intercepten la señal y el Gestor PACE, que es el 'cerebro' que decide qué canal está activo en cada momento.*
> - *Y en la **capa inferior** vemos a dónde va esa información dentro del vehículo: las órdenes de conducción y gas van al Computador de Control (GNC), y tenemos una línea directa prioritaria al módulo de frenado que actúa si el gestor detecta pérdida de enlace."*

---

### Diapositiva 5: Vista 9 (`vistaConexionesComunicaciones`)
**Qué decir:**
> *"En el modelo SysML v2, esto se traduce en dos vistas. La primera es la **Vista 9**, que muestra las conexiones externas:*
> - *Aparece el vehículo en el centro, y alrededor las 3 estaciones: la consola ligera CPT, el puesto de mando PMP y el dron UAV.*
> - *Se ven claramente los 3 enlaces de radiofrecuencia (LOS, BLOS y el relé del dron).*
> - *Y por dentro del vehículo, el enlace con el computador de control y la línea de seguridad de frenado.*
> *Hemos simplificado esta vista quitando cables secundarios de cámaras y sensores para que el diagrama de Spec42 quede limpio y no parezca una maraña."*

---

### Diapositiva 6: Vista 10 (`vistaInternaComunicaciones`)
**Qué decir:**
> *"La segunda vista es la **Vista 10**, que muestra qué hay dentro de la caja de comunicaciones:*
> - *Muestra directamente los 5 bloques del Plan PACE, del canal 1 al 5.*
> - *Cada bloque tiene sus atributos claros: el protocolo, la latencia y el estado del vídeo.*
> - *Todo conecta limpiamente a los puertos exteriores y compila con 0 errores y 0 avisos en Spec42."*

---

### Diapositiva 7: Resumen y Conclusión
**Qué decir:**
> *"En resumen: tenemos un modelo de menos de 100 líneas en `05_comunicaciones.sysml`, que cumple todos los requisitos del pliego oficial (RCOM-01, 02, 03, RSW-06 y RGEN-17), no se rompe al compilar y cualquier persona del equipo lo puede entender en dos minutos.*  
> *¿Tenéis alguna duda o queréis que detallemos algún canal?"*

---

### Posibles preguntas de compañeros y respuestas rápidas:

* **¿Por qué se apaga el vídeo en el 4º orden (VHF)?**  
  *Respuesta:* Las radios VHF militares (PR4G/CNR) transmiten a velocidades muy bajas (kilobits por segundo). No tienen ancho de banda para vídeo, así que priorizamos el gobierno del vehículo y el freno (RSW-06) para no perder el control.

* **¿Por qué 1.000 ms en el failsafe?**  
  *Respuesta:* El pliego militar y las normas de seguridad de robots terrestres pesados exigen que si se pierde el latido durante 1 segundo, el vehículo debe detenerse de forma segura para evitar colisiones descontroladas (RGEN-17).
