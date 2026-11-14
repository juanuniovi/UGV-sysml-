# Spec Delta: subsistema-iluminacion

## MODIFIED Requirements

### Requirement: Estructura del Subsistema 4.3 de Iluminación y subparte de iluminación 360° (RGEN-20)
El modelo SHALL definir en `Modelos/04_3_iluminacion.sysml` el paquete `SubsistemaIluminacion` con el bloque principal `SistemaIluminacion`, definiendo el ítem de datos `item def Intensidad` y el puerto tipado simétrico `port def PuertoIntensidadIluminacion` que contiene `item intensidad : Intensidad;` sin modificador de dirección `out`, integrando directamente en `SistemaIluminacion` los atributos de cobertura 360 grados (`anguloCoberturaDeg : Real = 360.0`, `potenciaConsumoWatts : Potencia`, `alcanceEfectivoMetros : Longitud`), con el puerto de potencia (`powerInput : ElectricalPowerPort`) y el puerto receptor de intensidad (`entradaIntensidad : PuertoIntensidadIluminacion`), excluyendo puertos mecánicos o de bus redundantes (`chassisMount`, `dataBus`).

#### Scenario: Composición interna de SistemaIluminacion
- **WHEN** se inspecciona la estructura de `SubsistemaIluminacion::SistemaIluminacion`
- **THEN** contiene directamente los atributos de cobertura 360°, y expone los puertos funcionales `powerInput` y `entradaIntensidad`, con `PuertoIntensidadIluminacion` definido como puerto simétrico sin restricción direccional
