## ADDED Requirements

### Requirement: Masa maxima de un modulo de carga de pago derivada de RLT1-07
Cada módulo de carga de pago (`SubsistemaCargasPago::CargaPagoModular` y sus especializaciones) SHALL tener una masa (`masaModuloKg`, tipo `TiposBase::Masa` en kg) no superior a 2.000 kg. Así no excede la capacidad de carga mínima que `RLT1-07` exige a la plataforma. El requisito SHALL denominarse `ReqMasaMaximaModulo` y su `doc` SHALL identificarlo como requisito derivado de `RLT1-07`, no como su formalización directa (que corresponde a `SistemaUGV::ReqCapacidadCargaMinimaPlataforma`).

#### Scenario: Modulo dentro del limite
- **WHEN** se evalúa un módulo con `masaModuloKg = 1500.0`
- **THEN** el módulo MUST satisfacer `ReqMasaMaximaModulo` (`masaModuloKg <= 2000.0`).

#### Scenario: Modulo que excede el limite
- **WHEN** se evalúa un módulo con `masaModuloKg = 2300.0`
- **THEN** el módulo MUST incumplir `ReqMasaMaximaModulo`, ya que no se garantiza que quepa en una plataforma con la capacidad mínima de `RLT1-07`.

#### Scenario: Coherencia entre texto y restriccion
- **WHEN** se inspecciona `ReqMasaMaximaModulo` en `Modelos/08_cargas_pago.sysml`
- **THEN** su `doc` MUST describir un límite máximo de masa del módulo, coherente con `require constraint { modulo.masaModuloKg <= 2000.0 }`, y MUST citar `RLT1-07` como origen derivado.

### Requirement: Trazabilidad de los modulos con las cargas de pago del pliego
El paquete `SubsistemaCargasPago` SHALL declarar en su `doc` de cabecera los identificadores `RGEN-28` y `RLT1-13`. Cada módulo SHALL citar en su `doc` su identificador de carga de pago y su Punto de Interfaz según el Anexo I §3.2.2.

#### Scenario: Correspondencia de modulos con CP y punto de interfaz
- **WHEN** se inspeccionan los `doc` de los módulos de `Modelos/08_cargas_pago.sysml`
- **THEN** `Modulo_ISTAR` MUST citar `CP-05` y el Punto de Interfaz 2, `Modulo_Logistico` MUST citar `CP-07` y el Punto de Interfaz 3, y `Modulo_MEDEVAC` MUST citar `CP-08` y el Punto de Interfaz 3, todos bajo `RLT1-13`.

#### Scenario: Cabecera sin identificadores ajenos al paquete
- **WHEN** se inspecciona el `doc` de `package SubsistemaCargasPago`
- **THEN** MUST citar `RGEN-28` y `RLT1-13`, y MUST NOT citar `RLT1-12` ni `RLT1-14` mientras el paquete no modele cargas de los Puntos de Interfaz 1 o 4.
