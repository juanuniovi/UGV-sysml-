# Design: Subsistema 4.3 de Iluminación con Módulo 360° y Enlace a Comunicaciones (RGEN-20)

## Contexto y Decisiones Arquitectónicas

### 1. Desacoplamiento y Simplicidad
Se mantiene la separación entre la percepción sensorial (`04_2_navegacion.sysml`) y la actuación lumínica (`04_3_iluminacion.sysml`), pero con un diseño directo y mínimo:
* Sin enumeraciones de sectores direccionales ni tipos de control auxiliares.
* Subparte única focalizada: `Iluminacion360`.
* Conexión directa con `comunicaciones.dataBus`.

### 2. Estructura y Tipado en SysML v2

```
SubsistemaIluminacion (package)
├── Partes:
│   ├── part def Iluminacion360 (subparte con cobertura perimetral de 360°)
│   └── part def SistemaIluminacion (bloque principal contenedor de 4.3)
├── Acciones:
│   └── action def Iluminar360Grados (emisión perimetral activa)
└── Requisitos:
    └── requirement def ReqConscienciaSituacionalIluminacion360 (RGEN-20)
```

### 3. Enlace con Comunicaciones
El control y supervisión del estado lumínico perimetral se canaliza a través del bus de datos conectado con Comunicaciones:
* `c_comms_iluminacion connect comunicaciones.dataBus to iluminacion.dataBus;`

### 4. Distribución de Potencia e Integración Mecánica
* **Potencia:** Se alimenta desde `plantaMotriz.powerOutputAvionics` (`c_power_iluminacion`).
* **Fijación:** Se ancla en los soportes de la barcaza (`c_barcaza_iluminacion`).
* **Trazabilidad:** Se incluye en `vistaRequisitos` de `Modelos/11_vistas.sysml` para asegurar que el requisito `RGEN-20` quede verificado y validado por Spec42 sin errores ni advertencias.
