# Design: Limpieza de Puertos y Resolución de Conector de Iluminación en Vista de Navegación y Control

## Context

Al inspeccionar la vista de interconexiones conjuntas de los Subsistemas 4.1 Control y 4.2 Navegación (`vistaConexionesNavegacionControl` en [Modelos/11_vistas.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/11_vistas.sysml#L93)), Spec42 emite el error:
`"A connectorEnd endpoint cannot be resolved. Check the referenced name and its scope. relationship unresolved"` señalando a la línea 93.

El origen de este problema técnico radica en la conexión expuesta `SistemaUGV::PlataformaUGV::c_control_iluminacion`:
- En [Modelos/09_sistema_ugv.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/09_sistema_ugv.sysml#L123), la conexión está definida como:
  `connection c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`
- En [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml#L167), el puerto está declarado como:
  `port salidaIntensidad : PuertoIntensidadIluminacion;`
- En [Modelos/04_3_iluminacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_3_iluminacion.sysml#L43), el puerto está declarado como:
  `port entradaIntensidad : ~PuertoIntensidadIluminacion;`

En el motor de análisis y renderizado SysML v2 de Spec42 para diagramas IBD (`InterconnectionView`), el uso del operador de conjugación asimétrica `~` a través de los límites del subsistema (`SubsistemaIluminacion` vs `SubsistemaControl`) provoca un fallo de resolución de scope y extremos de conexión (`connectorEnd endpoint unresolved`). Además, `SistemaIluminacion` conserva dos puertos obsoletos que no se utilizan: `chassisMount : MechanicalMountPort` (con la conexión residual `c_barcaza_iluminacion` en `PlataformaUGV`) y `dataBus : DataBusPort` (remanente de cuando se contemplaba un bus genérico).

## Goals / Non-Goals

**Goals:**
- Resolver el error de Spec42 en la línea 93 de [Modelos/11_vistas.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/11_vistas.sysml#L93) tipando `entradaIntensidad` de forma simétrica a `salidaIntensidad` (`port entradaIntensidad : PuertoIntensidadIluminacion;`).
- Eliminar de forma limpia los puertos innecesarios `chassisMount` y `dataBus` en `SistemaIluminacion` ([Modelos/04_3_iluminacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_3_iluminacion.sysml)).
- Eliminar la conexión mecánica huérfana `c_barcaza_iluminacion` en `PlataformaUGV` ([Modelos/09_sistema_ugv.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/09_sistema_ugv.sysml)).
- Mantener estrictamente el puerto de potencia eléctrica `powerInput : ElectricalPowerPort` y su conexión `c_power_iluminacion` desde `plantaMotriz.powerOutputAvionics`.
- Asegurar la trazabilidad formal inalterada de `RGEN-20`, `ROPE-01` y `ROPE-02`.

**Non-Goals:**
- No se modifica la arquitectura ni la descomposición interna de `SistemaControl` ([Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml)).
- No se altera la estructura ni conexiones del subsistema de navegación ni comunicaciones.
- No se modifican los requisitos normativos ni sus identificadores.

## Decisions

### 1. Tipado simétrico para `entradaIntensidad` en `SubsistemaIluminacion`
- **Decisión**: Cambiar la declaración en `SistemaIluminacion` de:
  `port entradaIntensidad : ~PuertoIntensidadIluminacion;`
  a:
  `port entradaIntensidad : PuertoIntensidadIluminacion;`
- **Justificación**: En Spec42, los conectores entre subsistemas hermanos instanciados dentro de un contenedor padre (`PlataformaUGV`) resuelven de forma determinista y sin fallos de ámbito cuando ambos extremos comparten la definición tipada `PuertoIntensidadIluminacion`, tal como se realiza en el resto del proyecto para puertos compartidos de datos.
- **Alternativas descartadas**:
  - Definir un puerto conjugado explícito `port def PuertoReceptorIntensidad : ~PuertoIntensidadIluminacion;`: innecesario y añade complejidad innecesaria en el paquete.
  - Eliminar la conexión de la vista: inaceptable, ya que el usuario requiere supervisar el enlace de control de luces en `vistaConexionesNavegacionControl`.

### 2. Eliminación de puertos huérfanos `chassisMount` y `dataBus`
- **Decisión**: Suprimir en `SistemaIluminacion` las líneas:
  - `port chassisMount : MechanicalMountPort;`
  - `port dataBus : DataBusPort;`
  Y en `PlataformaUGV`:
  - `connection c_barcaza_iluminacion connect barcaza.avionicaMount to iluminacion.chassisMount;`
- **Justificación**: El montaje físico de las luminarias perimetrales se distribuye en la barcaza sin requerir un conector mecánico formal en el modelo arquitectónico; el bus digital de datos quedó completamente sustituido por la interfaz de intensidad de control directo (`c_control_iluminacion`). Mantenerlos solo ensucia el diagrama con puertos sin flujo.

### 3. Preservación del puerto de potencia `powerInput`
- **Decisión**: Mantener intacto:
  - En `SistemaIluminacion`: `port powerInput : ElectricalPowerPort;`
  - En `PlataformaUGV`: `connection c_power_iluminacion connect plantaMotriz.powerOutputAvionics to iluminacion.powerInput;`
- **Justificación**: Requisito explícito del usuario para no romper el balance de potencia de la plataforma UGV ni la vista `vistaConexionesPlantaMotrizSistema`.

## Risks / Trade-offs

- **[Riesgo]** Incompatibilidad con `vistaConexionesPlantaMotrizSistema` (Vista 12):
  - *Mitigación*: Vista 12 expone `c_power_iluminacion`. Como `powerInput` se preserva intacto, Vista 12 continuará funcionando sin ninguna alteración.
- **[Riesgo]** Referencias residuales en `11_vistas.sysml`:
  - *Mitigación*: Verificar que ninguna vista exponga `c_barcaza_iluminacion`. (En `11_vistas.sysml` solo se exponen `c_control_iluminacion` y `c_power_iluminacion`).
