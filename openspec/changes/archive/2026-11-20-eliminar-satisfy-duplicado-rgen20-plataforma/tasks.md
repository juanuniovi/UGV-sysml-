# Tasks

## 1. Corrección del modelo

- [x] 1.1 Eliminar de `PlataformaUGV` en `Modelos/09_sistema_ugv.sysml` la línea `satisfy requirement : ReqConscienciaSituacionalIluminacion360 by iluminacion;`, sin alterar el resto de cláusulas `satisfy`.
- [x] 1.2 Verificar que `Modelos/04_3_iluminacion.sysml` conserva intacta `satisfy requirement : ReqConscienciaSituacionalIluminacion360;` dentro de `SistemaIluminacion`, y que es la única satisfacción de ese requisito en `Modelos/*.sysml`.

## 2. Validación con Spec42

- [x] 2.1 Ejecutar `spec42 check Modelos` y confirmar 0 errores y 0 avisos.
- [x] 2.2 Renderizar las 13 vistas con `spec42 diagram` y confirmar que `vistaConexionesSoI`, `vistaConexionesPlataforma` y `vistaConexionesComunicaciones` se generan sin el aviso `diagram occurrence is outside the projected node set`, y que el resto no empeora.
- [x] 2.3 Confirmar que `vistaRequisitos` sigue mostrando la satisfacción de `ReqConscienciaSituacionalIluminacion360`. Resultado: la vista proyecta los mismos 39 `RequirementDefinition` antes y después del cambio, y Spec42 0.61.1 no dibuja aristas `satisfy` en ella en ningún caso; sin regresión.

## Workflow follow-up

- Ejecutar opsx-archive para consolidar la especificación y archivar el cambio.
- Confirmar con el usuario el estado del bloque funcional y la integración en la rama.
