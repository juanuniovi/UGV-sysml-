# Design: Conexión Simétrica de Control de Iluminación Perimetral

## Context

En `Modelos/04_3_iluminacion.sysml`, el tipo de puerto `PuertoIntensidadIluminacion` fue modelado como:
```sysml
port def PuertoIntensidadIluminacion {
    doc /* Puerto de envio de consigna de intensidad luminica */
    out item intensidad : Intensidad;
}
```
En `Modelos/04_1_control.sysml`, `salidaIntensidad` se instancia como `port salidaIntensidad : PuertoIntensidadIluminacion;`.
En `Modelos/04_3_iluminacion.sysml`, `entradaIntensidad` se instancia como `port entradaIntensidad : PuertoIntensidadIluminacion;`.
En `Modelos/09_sistema_ugv.sysml`, se conectan mediante `connection c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`.

En SysML v2 y en el analizador de Spec42, declarar `out item ...` dentro de una definición de puerto asigna la dirección `out` a cualquier puerto que use dicha definición. Al conectar dos puertos con dirección `out` (`salidaIntensidad` a `entradaIntensidad`), el motor de graficado y validación de Spec42 lo cataloga como conflicto direccional o no lo dibuja en el diagrama de interconexión (IBD).

## Goals / Non-Goals

**Goals:**
- Eliminar el calificador de dirección `out` en `PuertoIntensidadIluminacion` para convertirlo en un puerto simétrico no direccional que transporte el ítem `intensidad : Intensidad;`.
- Lograr que Spec42 resuelva y dibuje la línea de conexión `c_control_iluminacion` en `vistaConexionesNavegacionControl` y `vistaEstructuraNavegacionControl`.
- Respetar la instrucción expresa del usuario: mostrar únicamente la conexión de control en la vista de navegación y control, sin exponer conexiones de potencia eléctrica (`c_power_iluminacion`).
- Mantener 0 errores de sintaxis y validación completa en OpenSpec.

**Non-Goals:**
- No añadir el puerto conjugado (`~PuertoIntensidadIluminacion`) en `entradaIntensidad`, ya que la conjugación de puertos definidos por el usuario puede desencadenar comportamientos imprevistos en diferentes visores SysML v2 si no está estandarizada en la librería de tipos. La convención simétrica (usada en `DataBusPort` y `ElectricalPowerPort`) es más robusta y estándar en el proyecto.
- No incluir `plantaMotriz` ni `c_power_iluminacion` en las vistas 7 y 8. La alimentación de aviónica de control, navegación, comunicaciones e iluminación se ilustra en las vistas de plataforma y planta motriz (Vistas 4 y 12).

## Decisions

### Decisión 1: Puerto simétrico de payload (`item intensidad : Intensidad`)
- **Justificación**: En la arquitectura del proyecto UGV-SYSML-, los puertos estándar de interconexión entre subsistemas (`DataBusPort`, `ElectricalPowerPort`, `MechanicalMountPort`) son simétricos sin directivas de flujo `in`/`out` fijas a nivel de definición de puerto. Al definir `PuertoIntensidadIluminacion` sin `out`, ambos extremos actúan como puntos de interfaz compatibles para compartir el ítem `Intensidad`.
- **Alternativas consideradas**:
  - *Usar conjugación `~PuertoIntensidadIluminacion` en `entradaIntensidad`*: Podría funcionar en semántica estricta SysML v2, pero algunos analizadores gráficos generan advertencias de resolución de tipos o fallan al resolver el nombre enlazado en la conexión externa.
  - *Usar `DataBusPort` para la intensidad*: Requeriría cambiar el tipo de puerto en `control` e `iluminacion`, perdiendo la tipificación fuerte del ítem `Intensidad`.

### Decisión 2: Alcance de exposición en vistas de Navegación y Control
- **Justificación**: `vistaConexionesNavegacionControl` expone `control`, `navegacion`, `comunicaciones` e `iluminacion` y sus interconexiones de datos y gobierno. Los puertos de alimentación `powerInput` de los cuatro subsistemas no tienen sus conexiones de potencia expuestas en esta vista para evitar sobrecargar el diagrama con flujos de energía (que pertenecen a la vista de planta motriz).

## Risks / Trade-offs

- **[Riesgo] Pérdida de indicación direccional estricta en el código**: Al quitar `out`, el SysML v2 textual no explicita en el tipo que el control es el emisor y la iluminación el receptor.
  - **Mitigación**: La semántica emisor/receptor queda documentada formalmente en los docstrings de los puertos (`salidaIntensidad` y `entradaIntensidad`) y en la especificación OpenSpec, preservando la claridad sin romper la compatibilidad gráfica.
