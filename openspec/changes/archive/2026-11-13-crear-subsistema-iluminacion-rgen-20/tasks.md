# Tasks: Crear Subsistema 4.3 de Iluminación con Subparte 360° y Enlace a Comunicaciones (RGEN-20)

- [x] 1. Crear el archivo `Modelos/04_3_iluminacion.sysml` con el paquete `SubsistemaIluminacion`. <!-- id: 1 -->
- [x] 2. Modelar la subparte `part def Iluminacion360` con atributos cuantitativos de cobertura y potencia. <!-- id: 2 -->
- [x] 3. Modelar la acción `action def Iluminar360Grados` para la activación de la emisión perimetral. <!-- id: 3 -->
- [x] 4. Definir el requisito formal `ReqConscienciaSituacionalIluminacion360` trazable al pliego oficial (`RGEN-20`). <!-- id: 4 -->
- [x] 5. Ensamblar el bloque principal `part def SistemaIluminacion` con `iluminacion360`, puertos (`chassisMount`, `powerInput`, `dataBus`), la acción y la relación `satisfy`. <!-- id: 5 -->
- [x] 6. Actualizar `Modelos/09_sistema_ugv.sysml` para incorporar `part iluminacion : SistemaIluminacion;` en `PlataformaUGV`, conectando potencia, montaje y el enlace directo con `comunicaciones.dataBus` (`c_comms_iluminacion`). <!-- id: 6 -->
- [x] 7. Actualizar `Modelos/11_vistas.sysml` importando y exponiendo `SubsistemaIluminacion::*` en `vistaRequisitos` y en las vistas de plataforma. <!-- id: 7 -->
- [x] 8. Validar sintaxis SysML v2 y ausencia de errores o advertencias en los modelos actualizados. <!-- id: 8 -->
