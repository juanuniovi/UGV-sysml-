# subsistema-iluminacion Spec Delta

## MODIFIED Requirements

### Requirement: Estructura del Subsistema 4.3 de Iluminación y subparte de iluminación 360° (RGEN-20)
El modelo SHALL definir en `Modelos/04_3_iluminacion.sysml` el paquete `SubsistemaIluminacion` con el bloque principal `SistemaIluminacion`, definiendo el ítem de datos `item def Intensidad` y el puerto tipado de gobierno y emisión `port def PuertoIntensidadIluminacion` dotado del flujo direccional explícito `out item intensidad : Intensidad;`, integrando directamente en `SistemaIluminacion` los atributos de cobertura 360 grados (`anguloCoberturaDeg : Real = 360.0`, `potenciaConsumoWatts : Potencia`, `alcanceEfectivoMetros : Longitud`), con el puerto de potencia (`powerInput : ElectricalPowerPort`) y el puerto receptor conjugado de intensidad (`entradaIntensidad : ~PuertoIntensidadIluminacion`), excluyendo puertos mecánicos o de bus redundantes (`chassisMount`, `dataBus`).

#### Scenario: Composición interna de SistemaIluminacion
- **WHEN** se inspecciona la estructura de `SubsistemaIluminacion::SistemaIluminacion`
- **THEN** contiene directamente los atributos de cobertura 360°, y expone los puertos funcionales `powerInput` y `entradaIntensidad : ~PuertoIntensidadIluminacion`, con `PuertoIntensidadIluminacion` definiendo el flujo formal `out item intensidad : Intensidad` para resolución canónica en Spec42

### Requirement: Integración de SistemaIluminacion en PlataformaUGV con enlace a Comunicaciones
El modelo SHALL integrar `part iluminacion : SistemaIluminacion;` dentro de `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`), conectando sus puertos con la planta motriz para suministro de energía (`c_power_iluminacion connect plantaMotriz.powerOutputAvionics to iluminacion.powerInput;`) y con el subsistema de Control para el gobierno de intensidad (`c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`), prescindiendo de fijaciones mecánicas a barcaza en este subsistema, y exponiendo la conexión en `Modelos/11_vistas.sysml` dentro de `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`.

#### Scenario: Conexión con comunicaciones y planta motriz en PlataformaUGV
- **WHEN** se instancia `PlataformaUGV` en `SistemaUGV`
- **THEN** `iluminacion.entradaIntensidad` está conectado a `control.salidaIntensidad` (`c_control_iluminacion`), `iluminacion.powerInput` a `plantaMotriz.powerOutputAvionics` (`c_power_iluminacion`), y no existen puertos mecánicos huérfanos hacia la barcaza
