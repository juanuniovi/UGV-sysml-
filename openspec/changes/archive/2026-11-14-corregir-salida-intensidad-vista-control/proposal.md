# Proposal: Corrección de Dirección de Flujo y Delegación del Puerto de Intensidad en Control e Iluminación

## Why

Al abrir la vista de interconexiones conjuntas de Navegación y Control (`vistaConexionesNavegacionControl`, línea 93 de `Modelos/11_vistas.sysml`), el analizador semántico de Spec42 emite una advertencia de limitación de proyección:
`Projection limitation: A connector end endpoint cannot be resolved. Check the referenced name and its scope.`
Asimismo, en el diagrama gráfico generado por Spec42:
1. El bloque `iluminacion` muestra el puerto `entradaIntensidad` con el ítem `intensidad`, pero la conexión no se dibuja y el puerto queda visualmente desconectado.
2. El puerto correspondiente en el otro extremo (`control.salidaIntensidad`) no aparece representado en el bloque `control` ni en ninguna de sus subpartes internas (`computadorAutonomia`, `subsistemaPlanificacionEvaluacion`).

La causa raíz de esta desconexión y del fallo de resolución del endpoint radica en tres factores técnicos concatenados:
1. **Pérdida de la semántica de flujo (`out` y conjugación `~`)**: En cambios recientes se eliminó el modificador direccional `out` de `item intensidad : Intensidad;` en `PuertoIntensidadIluminacion` y el operador de conjugación `~` en `entradaIntensidad : PuertoIntensidadIluminacion;`. En SysML v2 y en el motor de proyecciones semánticas de Spec42, los puertos que transportan ítems de datos requieren una dirección explícita (`out item`) y la conjugación en el extremo receptor (`~`) para identificar la semántica emisor-receptor. Al quedar sin dirección ni conjugación, el motor gráfico no puede construir la proyección de flujo entre ambos extremos.
2. **Inversión de operandos en los enlaces de delegación interna (`binding`)**: En `Modelos/04_1_control.sysml`, los enlaces de delegación de `salidaIntensidad` se declararon con los operandos invertidos (`subpart.port = containerPort`):
   - `binding b_plan_intensidad bind subsistemaPlanificacionEvaluacion.salidaIntensidad = salidaIntensidad;`
   - `binding b_ctrl_intensidad bind computadorAutonomia.salidaIntensidad = salidaIntensidad;`
   A diferencia de las delegaciones correctas del proyecto (como `b_salida_avionica`, `b_salida_traccion`, `c_entrada_obstaculos` o `c_entrada_vio`), donde el puerto propio del contenedor precede al miembro interno (`bind outer = inner;`). Esta inversión impide al analizador de Spec42 vincular el puerto exterior con la subparte interna, provocando que `salidaIntensidad` se descarte del scope proyectado del bloque `control`.
3. **Fallo de resolución de endpoints en la vista (línea 93)**: Al no resolverse `control.salidaIntensidad` en el scope de `control`, el conector de plataforma `c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;` sufre un fallo de resolución de extremo en `vistaConexionesNavegacionControl` (`line 93`), impidiendo el trazado de la línea de interconexión y dejando el puerto `entradaIntensidad` huérfano en el diagrama.

## What Changes

- **Restauración de la semántica formal de flujo en `SubsistemaIluminacion` (`Modelos/04_3_iluminacion.sysml`)**:
  - Restituir el modificador de dirección `out` en `port def PuertoIntensidadIluminacion`: `out item intensidad : Intensidad;`.
  - Restituir la conjugación formal de recepción en `SistemaIluminacion`: `port entradaIntensidad : ~PuertoIntensidadIluminacion;`.
- **Corrección canónica de la delegación jerárquica en `SubsistemaControl` (`Modelos/04_1_control.sysml`)**:
  - En `ComputadorAutonomia`, corregir el orden canónico del binding: `binding b_plan_intensidad bind salidaIntensidad = subsistemaPlanificacionEvaluacion.salidaIntensidad;`.
  - En `SistemaControl`, corregir el orden canónico del binding: `binding b_ctrl_intensidad bind salidaIntensidad = computadorAutonomia.salidaIntensidad;`.
- **Verificación y validación de la vista en `VistasUGV` (`Modelos/11_vistas.sysml`)**:
  - Confirmar que `vistaConexionesNavegacionControl` y `vistaEstructuraNavegacionControl` resuelven ambos extremos de `c_control_iluminacion` sin advertencias de limitación de proyección (`projection limitation`), dibujando la línea de conexión y el flujo de `intensidad` entre `control` e `iluminacion`.

## Capabilities

### New Capabilities
*(Ninguna)*

### Modified Capabilities
- `subsistema-iluminacion`: Corrección de `PuertoIntensidadIluminacion` dotándolo del flujo direccional canónico `out item intensidad : Intensidad;` y tipando el puerto receptor `entradaIntensidad` como `~PuertoIntensidadIluminacion` para asegurar la resolución de interfaces en SysML v2 y Spec42.
- `subsistema-control`: Normalización del orden de enlace de delegación (`bind outer = inner;`) para `salidaIntensidad` a través de `ComputadorAutonomia` y `SistemaControl`, asegurando su resolución en el ámbito proyectado y su renderizado visual en Spec42.

## Impact

- **Modelos SysML v2 modificados**:
  - `Modelos/04_3_iluminacion.sysml`: `out item intensidad` y `~PuertoIntensidadIluminacion`.
  - `Modelos/04_1_control.sysml`: normalización de bindings `b_plan_intensidad` y `b_ctrl_intensidad`.
  - `Modelos/11_vistas.sysml`: verificación de resolución limpia en Spec42.
- **Requisitos contractuales**: Preservación íntegra de la trazabilidad y satisfacción de `RGEN-20` (iluminación perimetral 360°), `ROPE-01` (modo teleoperado) y `ROPE-02` (telemando de luces perimetrales).
