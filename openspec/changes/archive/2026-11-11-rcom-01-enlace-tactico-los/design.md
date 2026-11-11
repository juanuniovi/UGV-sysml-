# Design: Enlace Táctico LOS (Grupo 1)

## Contexto y Decisiones Arquitectónicas

El subsistema de comunicaciones tácticas (`05_comunicaciones.sysml`) proporciona el puente de radiofrecuencia entre la aviónica de a bordo y los equipos de control externos (CPT y PMP). Para el Grupo 1 (Enlace LOS), se formaliza la descomposición estructural inicial:

1. **Definiciones de Ítems de Datos (`item def`)**:
   - `ComandoTelemandoLOS`: Estructura para empaquetar comandos de velocidad lineal, velocidad angular y parada de emergencia procedentes de la CPT.
   - `TelemetriaVideoLOS`: Estructura para el flujo de vídeo de cámaras ópticas de conducción y estado básico de batería/sistema hacia la CPT.

2. **Transceptor de Radiofrecuencia (`part def RadioEnlaceTacticoLOS`)**:
   - Atributos cuantitativos: `latenciaMaximaMs : Real = 100.0`, `alcanceNominalKm : Real = 1.5`, `frecuenciaGhz : Real = 2.4`.
   - Puertos internos: `port rfPort : RFPort;` y `port dataBusInternal : DataBusPort;`.

3. **Requisito y Trazabilidad**:
   - Bloque `requirement def ReqEnlaceTacticoLOS` con `require constraint { true }`.
   - Cláusula `satisfy requirement : ReqEnlaceTacticoLOS by radioEnlaceTacticoLOS;` dentro de `SistemaComunicacionesEmbarcado`.

4. **Vista de Interconexión en `11_vistas.sysml`**:
   - `view vistaConexionesComunicaciones : InterconnectionView` exponiendo `SubsistemaComunicaciones::SistemaComunicacionesEmbarcado` para visualizar la topología de puertos e interconexiones en Spec42.

## Verificación

- Sintaxis SysML v2 conforme a OMG Spec.
- Compilación y verificación con `spec42 check Modelos`: 0 errores y 0 avisos.
