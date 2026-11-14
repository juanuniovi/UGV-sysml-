# Proposal: Conexión Simétrica de Control de Iluminación Perimetral

## Why

En la vista de interconexiones conjuntas de navegación y control (`vistaConexionesNavegacionControl` y `vistaEstructuraNavegacionControl` en `Modelos/11_vistas.sysml`), la conexión `c_control_iluminacion` entre `control.salidaIntensidad` e `iluminacion.entradaIntensidad` no se renderiza visualmente en Spec42. La causa raíz es que `PuertoIntensidadIluminacion` en `Modelos/04_3_iluminacion.sysml` incluye la directiva direccional `out item intensidad : Intensidad;`, lo que categoriza ambos extremos como puertos `out`, provocando que el motor de renderizado D3 de Spec42 descarte la conexión al detectar una inconsistencia de flujo de salida a salida (`out` -> `out`).

Para solucionar esto de manera limpia, canónica y compatible con SysML v2 y Spec42, se elimina el modificador de dirección `out` en la definición de `PuertoIntensidadIluminacion` (`item intensidad : Intensidad;`). Esto convierte al puerto en un puerto de carga útil de datos simétrico (al igual que `DataBusPort` y `ElectricalPowerPort`), permitiendo que `c_control_iluminacion` se dibuje adecuadamente entre `control` e `iluminacion` sin necesidad de exponer puertos o conexiones de potencia en esta vista.

## What Changes

- **Modificación en definición de puerto de iluminación**: En `Modelos/04_3_iluminacion.sysml`, se actualiza `port def PuertoIntensidadIluminacion` eliminando el calificador `out` de su ítem interno, quedando como `item intensidad : Intensidad;`.
- **Preservación de interfaces de control y vistas**: Se mantienen intactos los puertos `control.salidaIntensidad` y `iluminacion.entradaIntensidad`, la conexión `c_control_iluminacion` en `Modelos/09_sistema_ugv.sysml` y la exposición en las vistas 7 y 8 de `Modelos/11_vistas.sysml`.
- **Aislamiento de potencia en vistas de control**: Se confirma que las conexiones de potencia eléctrica (`c_power_iluminacion`) permanecen exclusivamente en las vistas de planta motriz y plataforma (Vistas 4 y 12), sin filtrarse en la vista de Navegación y Control según lo solicitado por el usuario.

## Capabilities

### New Capabilities
<!-- Ninguna nueva capacidad -->

### Modified Capabilities
- `subsistema-iluminacion`: Modificación en la especificación del puerto de control de intensidad `PuertoIntensidadIluminacion`, estableciendo que transporta simétricamente el ítem de datos `intensidad` sin restricción direccional `out`, garantizando la interoperabilidad con el subsistema de Control en `PlataformaUGV` y la correcta representación gráfica en Spec42.

## Impact

- **Modelos SysML v2**:
  - `Modelos/04_3_iluminacion.sysml`: Actualización de la definición de `PuertoIntensidadIluminacion`.
- **Especificaciones OpenSpec**:
  - `openspec/specs/subsistema-iluminacion/spec.md`: Actualización del delta para reflejar el puerto simétrico de control de intensidad.
- **Herramientas de visualización**:
  - Spec42 resolverá y dibujará la línea de conexión `c_control_iluminacion` entre los bloques `control` e `iluminacion` en `vistaConexionesNavegacionControl` y `vistaEstructuraNavegacionControl`.
