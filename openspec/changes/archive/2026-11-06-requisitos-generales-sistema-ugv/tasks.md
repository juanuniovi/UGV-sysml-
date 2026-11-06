# Tasks

## 1. Atributos globales de masa y prestaciones en `PlataformaUGV` (`09_sistema_ugv.sysml`)

- [x] 1.1 Añadir en `part def PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`) los atributos de masa tipados con `TiposBase::Masa`: `masaOrdenMisionKg`, `capacidadCargaUtilKg` y `capacidadArrastreRemolqueKg`.
- [x] 1.2 Añadir en `part def PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`) los atributos operativos y de autonomía tipados con `Real`: `velocidadRemolcadoKmh`, `profundidadVadeoM`, `autonomiaTotalHoras`, `autonomiaTotalKm`, `autonomiaElectricaHoras` y `autonomiaElectricaKm`.

## 2. Definición de requisitos generales cuantitativos y normativos (`requirement def` con `require constraint`)

- [x] 2.1 Definir en `package SistemaUGV` (`Modelos/09_sistema_ugv.sysml`) los requisitos cuantitativos sobre `PlataformaUGV`: `ReqMasaMaximaOrdenMision` (`RLT1-08`), `ReqCapacidadCargaMinimaPlataforma` (`RLT1-07`), `ReqCapacidadArrastreRemolque` (`RGEN-10`, `RLT1-14`), `ReqVelocidadRemolcadoPasivo` (`RGEN-16`), `ReqCapacidadVadeo` (`RLT1-10`), `ReqAutonomiaTotalPlataforma` (`RGEN-14`) y `ReqAutonomiaModoElectrico` (`RGEN-15`).
- [x] 2.2 Definir en `package SistemaUGV` (`Modelos/09_sistema_ugv.sysml`) los requisitos generales normativos y de arquitectura: `ReqConcepcionNativaNoTripulada` (`RGEN-01`, `RGEN-04`), `ReqResistenciaAmbiental` (`RGEN-06`), `ReqEstibaTransporteEstrategico` (`RGEN-24`, `RGEN-25`) y `ReqEstabilidadPuntosInterfaz` (`RGEN-28`, `RGEN-29`).

## 3. Trazabilidad y satisfacción de requisitos (`satisfy requirement`)

- [x] 3.1 Vincular en `part def PlataformaUGV` y `part def SistemaUGVPesadoDual` (`Modelos/09_sistema_ugv.sysml`) los requisitos definidos mediante cláusulas `satisfy requirement : <NombreRequisito>;`, preservando intactas todas las partes y conexiones existentes.

## 4. Verificación y validación con Spec42

- [x] 4.1 Ejecutar validación sintáctica y semántica con Spec42 sobre los 12 modelos de `Modelos/` comprobando `0 errors, 0 warnings`.
- [x] 4.2 Comprobar que `VistasUGV::vistaRequisitos` (`Modelos/11_vistas.sysml`) y las vistas del sistema (`vistaEstructuraSoI`, `vistaEstructuraPlataforma`, `vistaConexionesSoI`, `vistaConexionesPlataforma`) se procesan correctamente con Spec42.
