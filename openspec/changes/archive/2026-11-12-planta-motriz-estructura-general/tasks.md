# Tasks

## 0. Autorización previa

- [x] 0.1 Registrar aquí la confirmación explícita del autor para eliminar `motoresElectricosTraccion[1..*]` de `PlantaMotrizHibrida` (la tracción se mantiene en `SubsistemaTrenRodaje`).
  - **Confirmado por el autor (César Bobes, 2026-11-12)**: «quítalos de mi planta» (opción A). Justificación: la tracción directa por rueda ya está modelada en `RuedaTraccionIndependiente` (`RLT1-01`, `RLT1-04`) y mantenerla en la planta la duplicaba. No es un requisito y ningún otro elemento la referencia.

## 1. Puertos locales en `Modelos/03_planta_motriz.sysml`

- [x] 1.1 Definir `port def PuertoCombustible` con su `doc`.
- [x] 1.2 Definir `port def PuertoEjeMecanico` con su `doc`.

## 2. Bloques generales en `Modelos/03_planta_motriz.sysml`

- [x] 2.1 Definir `DepositoCombustible` con `doc` y puertos (`RGEN-11`).
- [x] 2.2 Definir `MotorCombustionBiocombustible` con `doc` y puertos (`RGEN-11`).
- [x] 2.3 Definir `GeneradorElectrico` con `doc` y puertos.
- [x] 2.4 Definir `PackBateriasTraccion` con `doc` y puertos (`RGEN-13`).
- [x] 2.5 Definir `UnidadDistribucionPotencia` con `doc` (incluida la nota sobre la frenada regenerativa) y puertos (`RLT1-09`).
- [x] 2.6 Definir `ConvertidorBajaTension` con `doc` y puertos.
- [x] 2.7 Definir `GestionEnergiaPMS` con `doc` y un puerto de datos por bloque gestionado más `busExterno` (`RGEN-09`, `RGEN-13`).
- [x] 2.8 Definir `ModuloExportacionPotencia` con `doc` y puertos (`RGEN-19`).
- [x] 2.9 Comprobar que ninguna `part def` nueva contiene atributos de dimensionado.

## 3. Ensamblaje de `PlantaMotrizHibrida`

- [x] 3.1 Tipar las partes existentes y añadir `depositoCombustible`, `distribucionPotencia` y `convertidorBajaTension`.
- [x] 3.2 Eliminar `motoresElectricosTraccion[1..*]` (solo si la tarea 0.1 está confirmada).
- [x] 3.3 Declarar las conexiones de energía: `c_deposito_motor`, `c_motor_generador`, `c_generador_distribucion`, `c_baterias_distribucion`, `c_distribucion_convertidor`, `c_distribucion_exportacion`.
- [x] 3.4 Declarar las conexiones de datos del PMS: `c_pms_deposito`, `c_pms_motor`, `c_pms_generador`, `c_pms_baterias`, `c_pms_distribucion`, `c_pms_convertidor`, `c_pms_exportacion`.
- [x] 3.5 Declarar los enlaces con el contorno: `b_salida_traccion`, `b_salida_avionica`, `b_salida_carga`, `b_bus_control`.
- [x] 3.6 Verificar que los puertos de contorno, los atributos `potenciaNominalKW` y `capacidadBateriaKWh`, y los requisitos `ReqPotenciaMinimaPlataforma` y `ReqExportacionEnergia` quedan idénticos.

## 4. Vistas en `Modelos/11_vistas.sysml`

- [x] 4.1 Añadir la Vista 10 `vistaConexionesPlantaMotriz : InterconnectionView`.
- [x] 4.2 Añadir la Vista 11 `vistaEstructuraPlantaMotriz : GeneralView` con filtro de partes y puertos.
- [x] 4.3 Añadir la Vista 12 `vistaConexionesPlantaMotrizSistema : InterconnectionView` con la planta motriz, los subsistemas conectados y sus conexiones (ver `design.md`, sección 6).
  - Ajuste: se excluyen `barcaza` y `rodaje` (y sus conexiones `c_barcaza_powertrain` y `c_power_traction`) porque Spec42 dibuja todas sus piezas internas sueltas. Ambas conexiones siguen visibles en `vistaConexionesPlataforma`.

## 5. Documento de trabajo

- [x] 5.1 Actualizar `Modelos/plan_desarrollo_planta_motriz.md` para reflejar el orden acordado: primero estructura general y conexiones (este cambio), después detalle de componentes.

## 6. Verificación

- [x] 6.1 Ejecutar `spec42 check Modelos` y obtener 0 errores y 0 avisos.
  - Resultado (Spec42 0.60.2): `Checked 13 document(s): 0 error(s), 0 warning(s), 0 info(s)`.
- [x] 6.2 Abrir `vistaConexionesPlantaMotriz` en Spec42 y comprobar que se ven todos los bloques y conexiones del esquema de `design.md`.
- [x] 6.2b Abrir `vistaConexionesPlantaMotrizSistema` en Spec42 y comprobar que se ven la planta y los subsistemas a los que alimenta, con sus conexiones.
- [x] 6.3 Verificar la trazabilidad: los `doc` de los bloques citan `RGEN-11`, `RGEN-13`, `RGEN-09`, `RGEN-19` y `RLT1-09` sin alterar ningún requisito.
- [x] 6.4 Revisar con `git diff` que solo cambian `03_planta_motriz.sysml`, `11_vistas.sysml` y el plan de desarrollo.
- [x] 6.5 Ejecutar `openspec validate planta-motriz-estructura-general --strict`.
