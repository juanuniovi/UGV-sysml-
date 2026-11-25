# Spec Delta

## REMOVED Requirements

### Requirement: Separación entre caja negra y caja blanca
**Reason**: El análisis de caja negra (Fase 0) no forma parte del alcance exigido por el profesor y estorba en `03_planta_motriz.sysml`. El autor autorizó expresamente su eliminación el 2026-11-25 (ver `proposal.md`, «Autorización de eliminación de requisitos»).
**Migration**: Ninguna. La planta motriz se modela solo como caja blanca (`PlantaMotrizHibrida`), según la especificación `planta-motriz`, que no cambia.

### Requirement: Partes interesadas y necesidades
**Reason**: Se retiran las partes interesadas y las 12 necesidades `Nec…` junto con todo el análisis de caja negra, por indicación del profesor y con autorización expresa del autor (2026-11-25).
**Migration**: Ninguna. Las cláusulas del pliego relacionadas siguen trazadas en sus requisitos de sistema (`09_sistema_ugv.sysml`) y de la caja blanca, salvo RGEN‑12 y RGEN‑18, que quedan pendientes para la Fase 2 (ver `proposal.md`).

### Requirement: Frontera del sistema de interés
**Reason**: Forma parte del análisis de caja negra retirado (autorización del autor del 2026-11-25).
**Migration**: La frontera efectiva la marcan los puertos de contorno de `PlantaMotrizHibrida` (`chassisMount`, `powerOutputTraction`, `powerOutputAvionics`, `powerOutputPayload`, `controlBus`), ya recogidos en la especificación `planta-motriz`.

### Requirement: Bloque de caja negra con interfaces externas
**Reason**: Se retira el bloque `PlantaMotrizCajaNegra` y sus 11 interfaces externas junto con el resto de la caja negra (autorización del autor del 2026-11-25).
**Migration**: Las interfaces externas efectivas son los puertos de contorno de `PlantaMotrizHibrida`. Ya no hace falta reconciliar las dos series de puertos.

### Requirement: Diagrama de contexto
**Reason**: Se retira `ContextoPlantaMotriz` y sus actores, sistemas externos y entorno, junto con la caja negra (autorización del autor del 2026-11-25). No había ninguna vista que lo mostrara.
**Migration**: Ninguna. El contexto de la planta dentro del UGV ya se ve en las vistas existentes `vistaConexionesPlantaMotrizSistema` y `vistaConexionesSoI`.

### Requirement: Casos de uso de la planta motriz
**Reason**: Se retiran los casos de uso `UC1`…`UC8` junto con la caja negra (autorización del autor del 2026-11-25).
**Migration**: Ninguna. Los modos de operación del sistema siguen modelados en `10_comportamiento.sysml`, que no cambia.

### Requirement: Especificación textual de cada caso de uso
**Reason**: Desaparece al retirarse los casos de uso de la caja negra (autorización del autor del 2026-11-25).
**Migration**: Ninguna.

### Requirement: Secuencias de contexto caja negra
**Reason**: Se retiran las 3 secuencias de contexto (UC1, UC2 y UC5) junto con la caja negra (autorización del autor del 2026-11-25).
**Migration**: Ninguna.

### Requirement: Medidas de efectividad con umbral y objetivo
**Reason**: Se retiran `MoEsPlantaMotriz` y los 6 requisitos `Umbral…` junto con la caja negra (autorización del autor del 2026-11-25).
**Migration**: Los umbrales contractuales siguen en sus requisitos vigentes: RLT1‑09 en `ReqPotenciaMinimaPlataforma`, RGEN‑19 en `ReqExportacionEnergia`, y RGEN‑14, RGEN‑15 y RLT1‑10 en `09_sistema_ugv.sysml`. RGEN‑12 queda pendiente para la Fase 2.

### Requirement: Preservación de requisitos existentes
**Reason**: Era una garantía del cambio que introdujo la caja negra. Al retirarse la capacidad, deja de tener objeto. La misma garantía se exige en este cambio (ver `design.md` y `tasks.md`): la caja blanca y todos los requisitos fuera del subpaquete quedan intactos.
**Migration**: Ninguna.
