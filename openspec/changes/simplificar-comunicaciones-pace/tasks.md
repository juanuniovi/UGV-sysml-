# Tasks

## 1. Simplificación del Subsistema de Comunicaciones (`Modelos/05_comunicaciones.sysml`)

- [x] 1.1 Reducir los items de datos de flujo a los 4 elementos esenciales con sus protocolos asociados (`FlujoTelemandoLOS`, `FlujoMandoBLOS`, `FlujoVideoConduccion` y `TramaHeartbeat`).
- [x] 1.2 Simplificar y estructurar las partes de radio y gestión (`RadioEnlaceTacticoLOS`, `RadioEnlaceTacticoBLOS`, `RadioTacticaMilitarCNR`, `ModuloCifradoCOMSEC`, `GestorRedundanciaPACE` y `SistemaAntenasEmbarcado`) haciendo explícita la cadena de fallo de 5 órdenes PACE.
- [x] 1.3 Refactorizar el contenedor `SistemaComunicacionesEmbarcado`, eliminando micro-conectores punto a punto innecesarios y conservando únicamente los enlaces directos entre radios, gestor PACE, COMSEC y antenas.
- [x] 1.4 Verificar la satisfacción formal de requisitos del pliego (`RCOM-01`, `RCOM-02`, `RCOM-03`, `RSW-06`, `RGEN-09`, `RGEN-17`, `RLT1-10`) garantizando la regla de satisfy único.

## 2. Simplificación de las Vistas de Conexiones (`Modelos/11_vistas.sysml`)

- [x] 2.1 Refactorizar `vistaConexionesComunicaciones` para mostrar la interconexión limpia a nivel de sistema (CPT, PMP, UAV, UGV) sin saturación de conectores secundarios.
- [x] 2.2 Refactorizar `vistaInternaComunicaciones` para enfocar la exposición en los 5 niveles funcionales de comunicaciones y la arquitectura de transceptores en Spec42.
- [x] 2.3 Eliminar la duplicidad de cajas en las vistas arquitectónicas (Opción A): ajustar el ámbito de exposición en `vistaConexionesPlataforma` y `vistaConexionesSoI` para evitar clones por recursión del motor ELK de Spec42, garantizando 1 sola caja de `moduloDeteccionEvasion` y `moduloFrenadoSeguridad`.

## 3. Verificación, Validación y OpenSpec

- [x] 3.1 Comprobar la ausencia de errores y advertencias de sintaxis con `spec42 check Modelos`.
- [x] 3.2 Verificar el renderizado de las vistas de comunicaciones en Spec42 (`vistaConexionesComunicaciones` y `vistaInternaComunicaciones`).
- [x] 3.3 Ejecutar `openspec validate simplificar-comunicaciones-pace` para comprobar la coherencia de todos los artefactos de la propuesta.
