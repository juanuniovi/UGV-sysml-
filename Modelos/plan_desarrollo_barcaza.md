# Hoja de Ruta y Guía Paso a Paso: Barcaza Estructural y Chasis (Issue #2)

> **Documento de trabajo personal para José Escobedo (`@josescobedov`)**  
> *Este archivo está ignorado en Git para servir de cuaderno de bitácora y referencia rápida.*

---

## 🎯 Objetivo General
Evolucionar [`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml) de manera limpia, progresiva y modular, respetando el patrón SysML v2 del proyecto sin sobrecargar el modelo ni invadir subsistemas de otros compañeros.

---

## 🗺️ Mapa de Fases Incrementales

```
[Fase 1: Estructura Base y Requisitos]  <--- ESTAMOS AQUÍ
   │
   ├──> [Fase 2: Atributos y Parámetros Físicos Detallados]
   │
   ├──> [Fase 3: Puertos Mecánicos Normalizados para Cargas de Pago]
   │
   └──> [Fase 4: Verificación Integral de Enlaces en 09_sistema_ugv.sysml]
```

---

## 📌 Fase 1 (Actual - Sprint Issue #2): Estructura Funcional y Requisitos del Pliego

### Meta de la Fase 1
Formalizar en SysML v2 los componentes estructurales de la barcaza y vincularlos con los requisitos oficiales del pliego mediante relaciones `satisfy`.

### Paso a Paso de Modelado:
1. **Definir Partes Específicas (`part def`):**
   - `ChasisProtegidoEnV`: Geometría de casco en V con protección contra minas terrestres e IEDs (deflexión de onda de choque).
   - `CabestranteAutoRecuperacion`: Sistema electro-hidráulico de tiro y auto-rescate (fuerza de tracción mínima).
   - `GanchoRemolqueSTANAG`: Dispositivo de arrastre y recuperación normalizado según estándar militar STANAG 4101.
2. **Definir Requisitos Trazables del Pliego:**
   - `RGEN-02`: Arquitectura de barcaza común para toda la familia UGV.
   - `RGEN-03`: Protección balística y contraminas (casco en V).
   - `RGEN-04`: Auto-recuperación mediante cabestrante (mínimo arrastre de la masa máxima del UGV).
   - `RGEN-05`: Compatibilidad de remolque bajo estándar STANAG 4101.
   - `RLT1-06`: Masa en vacío (tara) de la plataforma entre 3.500 kg y 5.000 kg (ya existente).
3. **Establecer Relaciones `satisfy`:**
   - Vincular cada parte o atributo con su requisito correspondiente.

---

## 🔭 Fase 2 (Siguiente paso): Atributos Físicos y Dimensiones

*Una vez aprobada y consolidada la Fase 1, se podrán añadir sin saturar el modelo:*
- **Dimensiones envolventes de la barcaza:**
  - `longitudTotalMm`, `anchuraTotalMm`, `alturaChasisMm`.
- **Nivel de protección balística:**
  - Atributo de clasificación STANAG 4569 (nivel de blindaje).
- **Capacidad nominal de tiro del cabestrante:**
  - `fuerzaTraccionKN : Real` (debe superar el peso bruto del vehículo para autorecuperación en barro o pendiente).

---

## 🔌 Fase 3: Puertos Mecánicos Normalizados

*Para asegurar que las cargas de misión (`08_cargas_pago.sysml`) se anclan de forma realista:*
- Definir en `TiposBase` o localmente subtipos de puertos de anclaje (guías DIN / rieles NATO / monturas de torsión).
- Delimitar con precisión las 3 interfaces de carga:
  - `interfazFrontalCarga` (para palas empujadoras o rodillos barreminas).
  - `interfazSuperiorCarga` (para mástil ISTAR o plataforma de recarga del UAV).
  - `interfazTraseraCarga` (para módulo MEDEVAC o portapalet logístico).

---

## 🧩 Fase 4: Enlace y Consistencia Global

- Validar que [`Modelos/09_sistema_ugv.sysml`](Modelos/09_sistema_ugv.sysml) enlaza correctamente:
  - `c_barcaza_rodaje`: anclaje con el tren de rodaje de ruedas.
  - `c_barcaza_powertrain`: bancada del motor térmico y packs de baterías.
  - `c_payload_mount`: fijación de las cargas de misión.

---

## 💡 Buenas Prácticas a Recordar
- ✅ Usa siempre `private import ScalarValues::*;` y `private import TiposBase::*;`.
- ✅ No modifiques módulos ajenos (`02_tren_rodaje.sysml`, `04_navegacion_control.sysml`, etc.).
- ✅ Si un requisito nuevo complementa uno existente, asegúrate de que no relaje ni contradiga valores ya definidos.
- [] Trabaja siempre en ramas dedicadas (`feat/...`) y a través de OpenSpec (`propose -> apply -> archive -> merge`).
