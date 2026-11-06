# Tasks

## 1. Incorporación de documentación oficial en `docs/`

- [x] 1.1 Copiar `ROBOT_TERRESTRE_Contrato.pdf` desde la ruta de descargas a `docs/` y verificar que el archivo existe y conserva su tamaño íntegro (~426 KB).
- [x] 1.2 Copiar `ROBOT_TERRESTRE_Anexo_I.pdf` desde la ruta de descargas a `docs/` y verificar que el archivo existe y conserva su tamaño íntegro (~562 KB).
- [x] 1.3 Verificar que los archivos web preexistentes en `docs/` (`index.html`, `app.js`, `styles.css`, `.nojekyll`, `README.md`) permanecen inalterados.

## 2. Actualización normativa en `AGENTS.md`

- [x] 2.1 Incorporar en `AGENTS.md` la sección `## Acceso a documentos densos y pliegos de referencia` estableciendo la prohibición por defecto de lectura/carga al contexto, la excepción ante petición explícita del usuario y el protocolo de propuesta obligatoria del agente antes de cualquier consulta.
- [x] 2.2 Verificar que se conservan íntegras todas las reglas previas de `AGENTS.md` (instrucciones previas a actuar, flujo OpenSpec, protección de requisitos y convenciones técnicas).

## 3. Verificación de integridad y trazabilidad del modelo

- [x] 3.1 Comprobar mediante `git diff` y `git status` que ningún archivo en `Modelos/*.sysml` ha sido modificado y que no hay alteraciones sobre los requisitos técnicos (`RGEN`, `RLT1`, `RNAV`, `ROPE`, `RCOM`).
- [x] 3.2 Comprobar la disponibilidad de la herramienta de validación Spec42 o documentar formalmente el estado de validación pendiente si la herramienta no está disponible en el entorno local.
