# Proposal

## Why

Al inspeccionar los diagramas del UGV en Spec42 para Navegación y Control (vistas 7 y 8 en `Modelos/11_vistas.sysml`), se identifican dos deficiencias:
1. El bloque `iluminacion : SistemaIluminacion` muestra puertos huérfanos e innecesarios: `chassisMount` (fijación mecánica heredada de la plantilla estructural de barcaza que el usuario no solicitó) y `dataBus` (bus digital residual que ya no se utiliza al haberse unificado el gobierno por `entradaIntensidad`). El usuario solicita explícitamente eliminar `chassisMount` y `dataBus`, pero **mantener** el puerto de alimentación `powerInput`.
2. La conexión de datos de control e iluminación (`c_control_iluminacion`) no se observa gráficamente en la vista. En Spec42 y analizadores SysML v2, cuando dos puertos se conectan a través de subsistemas diferentes, el uso de conjugación asimétrica (`~PuertoIntensidadIluminacion`) sin directiva explícita de flujo puede impedir la resolución del conector en el motor D3, o la vista requiere que ambos puertos compartan simétricamente la definición tipada `PuertoIntensidadIluminacion` (como ocurre en las restantes conexiones del UGV).

## What Changes

- **Limpieza de puertos en `SubsistemaIluminacion` (`Modelos/04_3_iluminacion.sysml`)**:
  - Eliminar definitivamente el puerto `port chassisMount : MechanicalMountPort;`.
  - Eliminar el puerto residual `port dataBus : DataBusPort;`.
  - Conservar íntegramente `port powerInput : ElectricalPowerPort;`.
  - Tipar `port entradaIntensidad : PuertoIntensidadIluminacion;` de forma simétrica a `salidaIntensidad` para asegurar la resolución visual del conector en Spec42.
- **Limpieza de conexiones estructurales en `SistemaUGV` (`Modelos/09_sistema_ugv.sysml`)**:
  - Eliminar la conexión mecánica `c_barcaza_iluminacion connect barcaza.avionicaMount to iluminacion.chassisMount;`.
  - Asegurar la conexión funcional `c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`.
- **Garantía de visualización en `Modelos/11_vistas.sysml`**:
  - Verificar y asegurar la correcta exposición y renderizado de la conexión `c_control_iluminacion` en `vistaConexionesNavegacionControl` (IBD) y `vistaEstructuraNavegacionControl` (BDD).

## Capabilities

### New Capabilities
*(Ninguna)*

### Modified Capabilities
- `subsistema-iluminacion`: Limpieza de puertos del bloque `SistemaIluminacion`, retirando `chassisMount` y `dataBus`, conservando `powerInput` y tipando simétricamente `entradaIntensidad` con `PuertoIntensidadIluminacion`.

## Impact

- **Modelos modificados**:
  - `Modelos/04_3_iluminacion.sysml`: Bloque `SistemaIluminacion` limpio con solo `powerInput` y `entradaIntensidad`.
  - `Modelos/09_sistema_ugv.sysml`: Supresión de `c_barcaza_iluminacion`.
  - `Modelos/11_vistas.sysml`: Visualización limpia de `iluminacion` y su enlace con `control`.
- **Requisitos contractuales**: Se mantiene íntegra la trazabilidad y satisfacción de `RGEN-20` (iluminación perimetral 360°), `ROPE-01` (teleoperado) y `ROPE-02` (control de luces).
