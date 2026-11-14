# Design: Corrección de Dirección de Flujo y Delegación del Puerto de Intensidad en Control e Iluminación

## Context

Al renderizar la vista 8 (`vistaConexionesNavegacionControl` en [Modelos/11_vistas.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/11_vistas.sysml#L93)), Spec42 genera la advertencia:
`"Projection limitation: A connector end endpoint cannot be resolved. Check the referenced name and its scope."` en la línea 93.

El examen detenido del modelo revela que:
1. En [Modelos/04_3_iluminacion.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_3_iluminacion.sysml#L12), `PuertoIntensidadIluminacion` fue privado de su dirección `out` (`item intensidad : Intensidad;`), y en `SistemaIluminacion`, el puerto receptor `entradaIntensidad` perdió la conjugación `~` (`port entradaIntensidad : PuertoIntensidadIluminacion;`). Esto elimina la caracterización de flujo requerida por SysML v2 para puertos con ítems de datos.
2. En [Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml#L106), los enlaces internos de delegación de `salidaIntensidad` están invertidos (`bind subpart.port = containerPort;` en lugar de `bind containerPort = subpart.port;`):
   - En `ComputadorAutonomia`: `binding b_plan_intensidad bind subsistemaPlanificacionEvaluacion.salidaIntensidad = salidaIntensidad;`
   - En `SistemaControl`: `binding b_ctrl_intensidad bind computadorAutonomia.salidaIntensidad = salidaIntensidad;`
   Esto rompe la resolución léxica de ámbito en Spec42 para contenedores anidados, haciendo que `salidaIntensidad` no se proyecte ni en `SistemaControl`, ni en `ComputadorAutonomia`, ni en `SubsistemaPlanificacionEvaluacion`.
3. Al no existir `control.salidaIntensidad` en los nodos proyectados por la vista, la conexión de plataforma `c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;` falla al resolver su extremo de origen, arrojando la limitación de proyección en la línea 93 y dejando el puerto `entradaIntensidad` desconectado en el diagrama.

## Goals / Non-Goals

**Goals:**
- Restablecer la semántica canónica de flujo de datos en `PuertoIntensidadIluminacion` (`out item intensidad : Intensidad;`) y el puerto receptor conjugado `entradaIntensidad : ~PuertoIntensidadIluminacion;`.
- Normalizar los enlaces de delegación jerárquica en `ComputadorAutonomia` y `SistemaControl` siguiendo el patrón canónico `bind outer = inner;` uniforme en todo el repositorio.
- Garantizar que Spec42 resuelva y dibuje sin advertencias la línea de conexión `c_control_iluminacion` entre `control` e `iluminacion` con el ítem de flujo `intensidad` en `vistaConexionesNavegacionControl` (IBD) y `vistaEstructuraNavegacionControl` (BDD).
- Mantener estrictamente el aislamiento de los puertos de potencia eléctrica (`powerInput` y `c_power_iluminacion`) fuera de la vista de navegación y control.

**Non-Goals:**
- No se altera la definición ni lógica de `ComputadorAutonomia`, `GobiernoControl` ni `ModuloFrenadoSeguridad`.
- No se modifican los requisitos normativos ni su trazabilidad hacia el pliego (`RGEN-20`, `ROPE-01`, `ROPE-02`).

## Decisions

### 1. Restitución de `out` en `PuertoIntensidadIluminacion` y `~` en `entradaIntensidad`
- **Decisión**:
  - En `Modelos/04_3_iluminacion.sysml`:
    ```sysml
    port def PuertoIntensidadIluminacion {
        doc /* Puerto de gobierno y transmision de consigna de intensidad luminica perimetral */
        out item intensidad : Intensidad;
    }
    ```
  - En `SistemaIluminacion`:
    ```sysml
    port entradaIntensidad : ~PuertoIntensidadIluminacion; // Recepcion de intensidad desde SistemaControl
    ```
- **Justificación**: Todo puerto SysML v2 que transporta un `item` requiere una dirección (`out item`). El emisor (`control.salidaIntensidad`) posee el tipo directo (`out`), y el receptor (`iluminacion.entradaIntensidad`) debe usar la forma conjugada `~` para invertir la dirección a `in`, tal como hacen `salidaObstaculos` / `entradaObstaculos`, `salidaOdometria` / `entradaOdometria` y `salidaMapaUnificado` / `entradaMapaUnificado`.

### 2. Normalización del orden de delegación en `binding` (`outer = inner`)
- **Decisión**:
  - En `ComputadorAutonomia` ([Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml)):
    ```sysml
    binding b_plan_intensidad bind salidaIntensidad = subsistemaPlanificacionEvaluacion.salidaIntensidad;
    ```
  - En `SistemaControl` ([Modelos/04_1_control.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/04_1_control.sysml)):
    ```sysml
    binding b_ctrl_intensidad bind salidaIntensidad = computadorAutonomia.salidaIntensidad;
    ```
- **Justificación**: En la gramática KerML / SysML v2 y en el árbol de sintaxis abstracta (AST) de Spec42, los enlaces de delegación en bloques compuestos resuelven las propiedades en el ámbito del contenedor cuando el puerto exterior se sitúa a la izquierda de la igualdad (`bind outerPort = innerPart.innerPort;`). Esto replica con éxito la sintaxis utilizada en `03_planta_motriz.sysml` (`b_salida_traccion`, `b_salida_avionica`), y en `04_1_control.sysml` (`c_entrada_obstaculos`, `c_entrada_vio`).

## Risks / Trade-offs

- **[Riesgo]**: Conflicto con la exposición de vistas si `salidaIntensidad` se filtrara indebidamente.
  - *Mitigación*: En `Modelos/11_vistas.sysml`, `vistaConexionesNavegacionControl` expone `SistemaUGV::PlataformaUGV::c_control_iluminacion`, y `vistaEstructuraNavegacionControl` incluye `ConnectionUsage` y `BindingConnectorAsUsage` en sus filtros. La corrección del endpoint permite que ambas vistas proyecten la conexión limpiamente.
