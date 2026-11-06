# Design

## Context

Véase `proposal.md` para la motivación. Actualmente, [`Modelos/01_barcaza.sysml`](Modelos/01_barcaza.sysml) declara `BarcazaEstructural` con atributos y puertos, pero sus partes internas son elementos no tipados (`part chasisProtegidoEnV;`, etc.), y no cuenta con trazabilidad formal para los requisitos `RGEN-02` a `RGEN-05`.

## Goals / Non-Goals

**Goals:**
- Tipar explícitamente los subcomponentes estructurales mediante definiciones `part def` independientes.
- Formalizar los requisitos `RGEN-02`, `RGEN-03`, `RGEN-04`, `RGEN-05` y mantener `RLT1-06`.
- Establecer relaciones `satisfy` entre las partes y sus requisitos normativos.
- Garantizar que la firma y los puertos mecánicos existentes se mantengan 100% compatibles con [`Modelos/09_sistema_ugv.sysml`](Modelos/09_sistema_ugv.sysml).

**Non-Goals:**
- No alterar los tipos base en [`Modelos/00_tipos_base.sysml`](Modelos/00_tipos_base.sysml).
- No modificar ningún subsistema de tracción, motor o comunicaciones.

## Decisions

### Decisión 1: Modelado modular mediante `part def` internas
- **Elección**: Definir dentro de `package SubsistemaBarcaza`:
  - `part def ChasisProtegidoEnV`
  - `part def CabestranteAutoRecuperacion`
  - `part def GanchoRemolqueSTANAG`
  e instanciarlas en `BarcazaEstructural`.
- **Razón**: Permite asignarle responsabilidades y requisitos específicos a cada componente sin sobredimensionar el modelo en un solo bloque monolítico.

### Decisión 2: Preservación de puertos mecánicos e interfaces
- **Elección**: Mantener intactos los nombres y tipos de puertos:
  `rodajeMount`, `powertrainMount`, `avionicaMount`, `interfazFrontalCarga`, `interfazSuperiorCarga`, `interfazTraseraCarga`.
- **Razón**: Asegura compatibilidad regresiva instantánea con las conexiones declaradas en `PlataformaUGV` y `SistemaUGVPesadoDual` dentro de `09_sistema_ugv.sysml`.

### Decisión 3: Sintaxis SysML v2 y relaciones satisfy
- **Elección**: Utilizar directivas `private import`, bloques `requirement def` con identificador y texto descriptivo, y sentencias `satisfy <requisito> by <parte>;`.
- **Razón**: Estándar canónico del proyecto exigido en `openspec/config.yaml`.

## Risks / Trade-offs

- **[Riesgo] Ruptura de imports en otros módulos**:
  - *Mitigación*: Se mantiene el nombre del paquete `SubsistemaBarcaza` y la definición principal `BarcazaEstructural`. No se modifica ningún nombre exportado externamente.
