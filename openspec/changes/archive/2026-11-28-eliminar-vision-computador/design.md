# Design

## Context

Véase `proposal.md` para la motivación y el alcance. Actualmente, `SubsistemaNavegacion` (`Modelos/04_2_navegacion.sysml`) define `part def SistemaVisionComputador` como nodo intermedio entre `camaras : SubsistemaCamaras` (puertos `salidaOptica` y `salidaTermica` de tipo `PuertoVideoOptico`) y `moduloDeteccionEvasion : ModuloDeteccionEvasion` (puerto `entradaVision : ~PuertoDatosVision`).

## Goals / Non-Goals

**Goals:**
- Suprimir `SistemaVisionComputador` (`part def` e instancia) y el puerto intermedio `PuertoDatosVision`.
- Conectar `camaras.salidaOptica` y `camaras.salidaTermica` directamente a `moduloDeteccionEvasion` en `SistemaNavegacion`.
- Mantener la compatibilidad completa con `SubsistemaCamaras`, `SubsistemaSensores`, `PlataformaUGV` (`09_sistema_ugv.sysml`), `SistemaControl` (`04_1_control.sysml`) y `VistasUGV` (`11_vistas.sysml`), así como la trazabilidad contractual de `RGEN-09`, `RGEN-20`, `RGEN-22`, `ROPE-06` y `RNAV-01`.

**Non-Goals:**
- Modificar los puertos externos de `SistemaNavegacion` hacia `PlataformaUGV` (`salidaObstaculos`, `salidaOdometria`, `entradaModoDeteccion`, `salidaVideoTeleoperacion`, `salidaEstadoRodaje`).
- Alterar la estructura interna de `SubsistemaCamaras` o `SubsistemaSensores`.

## Decisions

1. **Renombrado del ítem de flujo de vídeo de cámaras (`DatosVideoCamaras`)**:
   - *Decisión*: Sustituir `item def DatosVisionComputador` por `item def DatosVideoCamaras` (o mantener el flujo tipado en `PuertoVideoOptico` usando `fotogramas : DatosVideoCamaras`) y eliminar `PuertoDatosVision`.
   - *Alternativa considerada*: Conservar el nombre `DatosVisionComputador`. Se descarta porque induciría a confusión al haberse eliminado el bloque `SistemaVisionComputador`.
2. **Puertos de entrada de `ModuloDeteccionEvasion`**:
   - *Decisión*: Reemplazar `port entradaVision : ~PuertoDatosVision;` en `ModuloDeteccionEvasion` por dos puertos tipados conjugados:
     - `port entradaOptica : ~PuertoVideoOptico;`
     - `port entradaTermica : ~PuertoVideoOptico;`
   - *Justificación*: Mantiene la separación explícita entre el canal óptico (360° + laterales) y el canal térmico/infrarrojo que ya expone `SubsistemaCamaras`, evitando un bloque concentrador intermedio y conectando `camaras.salidaOptica` → `moduloDeteccionEvasion.entradaOptica` (`c_camaras_optica_deteccion`) y `camaras.salidaTermica` → `moduloDeteccionEvasion.entradaTermica` (`c_camaras_termica_deteccion`).
3. **Actualización de acciones y trazabilidad (`RGEN-09`)**:
   - *Decisión*: En `action def DetectarObstaculosNavegacion`, reemplazar `in datosVision : DatosVisionComputador;` y `action adquirirVisionComputador` por `in datosCamaras : DatosVideoCamaras;` y `action adquirirPercepcionCamaras`. En `ReqDeteccionObstaculosModoSigiloso`, actualizar el `doc` para indicar *"no radiantes (camaras opticas y termica)"* en lugar de *"no radiantes (vision por computador)"*, preservando intacto el `subject`, la restricción y el identificador `RGEN-09`.
4. **Estrategia de validación**:
   - Validar sintaxis, referencias, trazabilidad y vistas con Spec42 (0 errores, 0 avisos) tras aplicar los cambios en los `.sysml` y regenerar las vistas gráficas afectadas si procede.

## Risks / Trade-offs

- **[Risk] Referencias residuales en vistas o comentarios de otros paquetes** → **Mitigation**: Buscar todas las ocurrencias de `VisionComputador`, `PuertoDatosVision`, `entradaVision` y `visión por computador` en `Modelos/*.sysml` antes y después de editar, y validar el proyecto completo con Spec42.
