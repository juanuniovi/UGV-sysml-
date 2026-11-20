# Spec Delta: subsistema-iluminacion

## MODIFIED Requirements

### Requirement: Trazabilidad formal del requisito RGEN-20 y satisfacción por SistemaIluminacion
El paquete `SubsistemaIluminacion` SHALL definir el requisito trazable `ReqConscienciaSituacionalIluminacion360` (`RGEN-20`), estableciendo `subject ilum : SistemaIluminacion` y una relación formal de satisfacción directa dentro de `SistemaIluminacion`, sin delegar en subpartes huérfanas. Dicha satisfacción SHALL ser única en el modelo: `PlataformaUGV` (`Modelos/09_sistema_ugv.sysml`) MUST NOT declarar una segunda satisfacción `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;`, ya que la satisfacción se hereda a través de `part iluminacion : SistemaIluminacion` y la duplicidad impide a Spec42 renderizar las vistas de interconexión que exponen la plataforma completa.

#### Scenario: Verificación de trazabilidad del requisito RGEN-20
- **WHEN** se examinan los requisitos del subsistema de iluminación en Spec42 o en `vistaRequisitos`
- **THEN** `ReqConscienciaSituacionalIluminacion360` aparece vinculado y satisfecho formalmente por el bloque `SistemaIluminacion` bajo la referencia `RGEN-20`

#### Scenario: Satisfacción única y renderizado de vistas de interconexión
- **WHEN** se busca `ReqConscienciaSituacionalIluminacion360` en las cláusulas `satisfy` de `Modelos/*.sysml` y se renderizan `vistaConexionesSoI`, `vistaConexionesPlataforma` y `vistaConexionesComunicaciones`
- **THEN** existe una única cláusula `satisfy`, ubicada en `SistemaIluminacion`, y las tres vistas se renderizan sin el aviso `diagram occurrence is outside the projected node set`
