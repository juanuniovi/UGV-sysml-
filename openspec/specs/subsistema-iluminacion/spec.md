# subsistema-iluminacion Specification

## Purpose

Especifica la arquitectura interna, bloques tipados, puertos, conexiones, acciones, requisitos y vistas del subsistema **4.3 Iluminación** (`SubsistemaIluminacion` en `Modelos/04_3_iluminacion.sysml`), encargado de proporcionar soporte lumínico perimetral en 360 grados para garantizar la consciencia situacional nocturna y en baja visibilidad (`RGEN-20`), conectado con el subsistema de Control para gobierno de intensidad e integrado en `PlataformaUGV`.

## Requirements

### Requirement: Estructura del Subsistema 4.3 de Iluminación y subparte de iluminación 360° (RGEN-20)
El modelo SHALL definir en `Modelos/04_3_iluminacion.sysml` el paquete `SubsistemaIluminacion` con el bloque principal `SistemaIluminacion`, definiendo el ítem de datos `item def Intensidad` y el puerto tipado de gobierno y emisión `port def PuertoIntensidadIluminacion` dotado del flujo direccional explícito `out item intensidad : Intensidad;`, integrando directamente en `SistemaIluminacion` los atributos de cobertura 360 grados (`anguloCoberturaDeg : Real = 360.0`, `potenciaConsumoWatts : Potencia`, `alcanceEfectivoMetros : Longitud`), con el puerto de potencia (`powerInput : ElectricalPowerPort`) y el puerto receptor conjugado de intensidad (`entradaIntensidad : ~PuertoIntensidadIluminacion`), excluyendo puertos mecánicos o de bus redundantes (`chassisMount`, `dataBus`).

#### Scenario: Composición interna de SistemaIluminacion
- **WHEN** se inspecciona la estructura de `SubsistemaIluminacion::SistemaIluminacion`
- **THEN** contiene directamente los atributos de cobertura 360°, y expone los puertos funcionales `powerInput` y `entradaIntensidad : ~PuertoIntensidadIluminacion`, con `PuertoIntensidadIluminacion` definiendo el flujo formal `out item intensidad : Intensidad` para resolución canónica en Spec42

### Requirement: Acción de iluminación 360 grados
El bloque `SistemaIluminacion` SHALL ejecutar la acción `Iluminar360Grados` (`iluminar360Grados`), la cual comanda y activa directamente la emisión lumínica perimetral en 360 grados del subsistema de iluminación.

#### Scenario: Activación de la iluminación 360 grados
- **WHEN** se ejecuta la acción `iluminar360Grados`
- **THEN** se modula la salida de emisión perimetral activa en 360 grados para dar apoyo visual al UGV

### Requirement: Trazabilidad formal del requisito RGEN-20 y satisfacción por SistemaIluminacion
El paquete `SubsistemaIluminacion` SHALL definir el requisito trazable `ReqConscienciaSituacionalIluminacion360` (`RGEN-20`), estableciendo `subject ilum : SistemaIluminacion` y una relación formal de satisfacción directa dentro de `SistemaIluminacion`, sin delegar en subpartes huérfanas. Dicha satisfacción SHALL ser única en el modelo: `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`) MUST NOT declarar una segunda satisfacción `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;`, ya que la satisfacción se hereda a través de `part iluminacion : SistemaIluminacion` y la duplicidad impide a Spec42 renderizar las vistas de interconexión que exponen la plataforma completa.

#### Scenario: Verificación de trazabilidad del requisito RGEN-20
- **WHEN** se examinan los requisitos del subsistema de iluminación en Spec42 o en `vistaRequisitos`
- **THEN** `ReqConscienciaSituacionalIluminacion360` aparece vinculado y satisfecho formalmente por el bloque `SistemaIluminacion` bajo la referencia `RGEN-20`

#### Scenario: Satisfacción única y renderizado de vistas de interconexión
- **WHEN** se busca `ReqConscienciaSituacionalIluminacion360` en las cláusulas `satisfy` de `Modelos/*.sysml` y se renderizan `vistaConexionesSoI`, `vistaConexionesPlataforma` y `vistaConexionesComunicaciones`
- **THEN** existe una única cláusula `satisfy`, ubicada en `SistemaIluminacion`, y las tres vistas se renderizan sin el aviso `diagram occurrence is outside the projected node set`

### Requirement: Integración de SistemaIluminacion en PlataformaUGV con enlace a Comunicaciones
El modelo SHALL integrar `part iluminacion : SistemaIluminacion;` dentro de `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`), conectando sus puertos con la planta motriz para suministro de energía (`c_power_iluminacion connect plantaMotriz.powerOutputAvionics to iluminacion.powerInput;`) y con el subsistema de Control para el gobierno de intensidad (`c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`), prescindiendo de fijaciones mecánicas a barcaza en este subsistema, y exponiendo la conexión en `Modelos/11_vistas.sysml` dentro de `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`.

#### Scenario: Conexión con comunicaciones y planta motriz en PlataformaUGV
- **WHEN** se instancia `PlataformaUGV` en `SistemaUGV`
- **THEN** `iluminacion.entradaIntensidad` está conectado a `control.salidaIntensidad` (`c_control_iluminacion`), `iluminacion.powerInput` a `plantaMotriz.powerOutputAvionics` (`c_power_iluminacion`), y no existen puertos mecánicos huérfanos hacia la barcaza
