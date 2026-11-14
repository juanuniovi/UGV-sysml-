# Spec Delta: subsistema-iluminacion

## MODIFIED Requirements

### Requirement: Estructura del Subsistema 4.3 de Iluminación y subparte de iluminación 360° (RGEN-20)
El modelo SHALL definir en `Modelos/04_3_iluminacion.sysml` el paquete `SubsistemaIluminacion` con el bloque principal `SistemaIluminacion`, definiendo el ítem de datos `item def Intensidad` y el puerto tipado `port def PuertoIntensidadIluminacion { out item intensidad : Intensidad; }`, integrando directamente en `SistemaIluminacion` los atributos de iluminación perimetral en 360 grados (`anguloCoberturaDeg : Real = 360.0`, `potenciaConsumoWatts : Potencia`, `alcanceEfectivoMetros : Longitud`), con puertos de potencia (`powerInput : ElectricalPowerPort`), fijación mecánica (`chassisMount : MechanicalMountPort`) y el puerto receptor de intensidad (`entradaIntensidad : ~PuertoIntensidadIluminacion`).

#### Scenario: Composición interna de SistemaIluminacion
- **WHEN** se inspecciona la estructura de `SubsistemaIluminacion::SistemaIluminacion`
- **THEN** contiene directamente los atributos de cobertura 360°, y expone los puertos `chassisMount`, `powerInput` y `entradaIntensidad`

### Requirement: Integración de SistemaIluminacion en PlataformaUGV con enlace a Comunicaciones
El modelo SHALL integrar `part iluminacion : SistemaIluminacion;` dentro de `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`), conectando sus puertos con la barcaza (`c_barcaza_iluminacion`), la planta motriz para suministro de energía (`c_power_iluminacion`) y directamente con el subsistema de Control para el gobierno de intensidad (`c_control_iluminacion connect control.salidaIntensidad to iluminacion.entradaIntensidad;`), y exponiendo la conexión en `Modelos/11_vistas.sysml` dentro de `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl`.

#### Scenario: Conexión con comunicaciones y planta motriz en PlataformaUGV
- **WHEN** se instancia `PlataformaUGV` en `SistemaUGV`
- **THEN** `iluminacion.entradaIntensidad` está conectado a `control.salidaIntensidad` (`c_control_iluminacion`), `iluminacion.powerInput` a `plantaMotriz.powerOutputAvionics` (`c_power_iluminacion`) y `iluminacion.chassisMount` a `barcaza.avionicaMount` (`c_barcaza_iluminacion`)
