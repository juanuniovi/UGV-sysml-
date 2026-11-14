# Tasks

## 1. Refactorización del Bloque de Iluminación en SysML v2

- [x] 1.1 Modificar `Modelos/04_3_iluminacion.sysml` eliminando `part def Iluminacion360` y la subparte `part iluminacion360 : Iluminacion360`, e incorporar directamente en `part def SistemaIluminacion` los atributos `anguloCoberturaDeg : Real = 360.0;`, `potenciaConsumoWatts : Potencia;` y `alcanceEfectivoMetros : Longitud;`. Verificar que el archivo conserve su sintaxis y parseo limpios.
- [x] 1.2 Actualizar la relación de satisfacción interna en `Modelos/04_3_iluminacion.sysml` a `satisfy requirement : ReqConscienciaSituacionalIluminacion360;` para que concuerde con `subject ilum : SistemaIluminacion;`. Verificar que no queden referencias residuales a `iluminacion360`.

## 2. Verificación de Vistas e Integración

- [x] 2.1 Verificar la coherencia en `Modelos/09_sistema_ugv.sysml` de `part iluminacion : SistemaIluminacion;`, sus conexiones (`c_barcaza_iluminacion`, `c_power_iluminacion`, `c_comms_iluminacion`) y la satisfacción contractual de `RGEN-20`.
- [x] 2.2 Verificar que en `Modelos/11_vistas.sysml` las vistas `vistaEstructuraNavegacionControl` y `vistaConexionesNavegacionControl` expongan limpiamente `iluminacion` sin el nodo flotante huérfano.

## Workflow follow-up

- Ejecutar opsx-archive para consolidar la especificación y archivar el cambio.
- Confirmar con el usuario el estado del bloque funcional y la integración en la rama.
