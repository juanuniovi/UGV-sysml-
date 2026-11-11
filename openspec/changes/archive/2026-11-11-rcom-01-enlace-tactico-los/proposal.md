# Proposal

## Why

El archivo `Modelos/05_comunicaciones.sysml` contenía únicamente un esqueleto preliminar con partes no tipadas y sin requisitos formales del pliego. Para el Grupo 1 de comunicaciones tácticas, el pliego del CDTI exige un enlace táctico en línea de vista (LOS) para el telemando y supervisión directa desde la Consola Portable de Operador (CPT) con latencia reducida (`RCOM-01`, `ROPE-01`, `ROPE-03`, `RGEN-04`, `RGEN-20`). Es necesario formalizar la descomposición estructural del transceptor LOS, sus ítems de flujo tipados de control y vídeo, su requisito formal y su vista de interconexiones en `Modelos/11_vistas.sysml`.

## What Changes

- **En `Modelos/05_comunicaciones.sysml`**:
  - Declaración de ítems de información de flujo: `ComandoTelemandoLOS` y `TelemetriaVideoLOS`.
  - Definición tipada de la parte transceptora `RadioEnlaceTacticoLOS` con atributos cuantitativos (`latenciaMaximaMs = 100.0`, `alcanceNominalKm = 1.5`, `frecuenciaGhz = 2.4`) y puertos internos (`rfPort`, `dataBusInternal`).
  - Formalización del requisito contractual `ReqEnlaceTacticoLOS` (`RCOM-01`).
  - Incorporación de `radioEnlaceTacticoLOS : RadioEnlaceTacticoLOS` dentro de `SistemaComunicacionesEmbarcado` y relación de trazabilidad `satisfy requirement : ReqEnlaceTacticoLOS by radioEnlaceTacticoLOS;`.
  - Preservación íntegra de todos los puertos de contorno del subsistema (`chassisMount`, `powerInput`, `dataBus`, `salidaModoDeteccion`, `salidaInhabilitacionFrenado`, `entradaVideoTeleoperacion`, `entradaEstadoRodaje`, `rfPortLOS`, `rfPortBLOS`).
- **En `Modelos/11_vistas.sysml`**:
  - Incorporación de la vista de interconexiones dedicada `vistaConexionesComunicaciones : InterconnectionView` (Vista 9) exponiendo `SubsistemaComunicaciones::SistemaComunicacionesEmbarcado`.

## Capabilities

### New Capabilities
- `comunicaciones-tacticas-los`: Especificación y modelado del enlace táctico en línea de vista (LOS) entre el vehículo UGV y la Consola Portable de Operador (CPT) según el requisito `RCOM-01`.

### Modified Capabilities
<!-- Ninguna capacidad previa se modifica. -->

## Impact

- **Archivos afectados**:
  - `Modelos/05_comunicaciones.sysml`
  - `Modelos/11_vistas.sysml`
- **Requisitos del pliego relacionados**:
  - `RCOM-01` (nuevo requisito formalizado en el subsistema).
  - Preserva intactos `RGEN-01`, `RGEN-04`, `RGEN-09`, `RGEN-17`, `ROPE-01..03` y `ROPE-06`.
- **Compatibilidad**:
  - 100% compatible con `Modelos/09_sistema_ugv.sysml` (0 errores y 0 avisos en Spec42).
