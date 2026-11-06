# Proposal

## Why

El proyecto modela un sistema UGV pesado dual cuyos requisitos derivan directamente de la documentación contractual y de los anexos técnicos de referencia (pliegos CDTI). Para asegurar la trazabilidad documental y disponer de las fuentes oficiales en el repositorio, es necesario incorporar el contrato y el Anexo I en el directorio `docs/`.

Sin embargo, al tratarse de archivos PDF extensos y densos, su lectura indiscriminada o automática por parte de los agentes de IA consume un volumen elevado e innecesario de tokens y satura la ventana de contexto. Por ello, se requiere establecer una directiva explícita y vinculante en `AGENTS.md` (y en las especificaciones del proyecto) que restrinja su lectura a peticiones directas del usuario o a propuestas previas del agente expresamente autorizadas por el usuario.

## What Changes

- Incorporación de los archivos oficiales de pliegos y contrato en el repositorio:
  - `docs/ROBOT_TERRESTRE_Contrato.pdf` (copiado desde la ruta de descargas).
  - `docs/TERRESTRE_Anexo_I.pdf` (copiado desde la ruta de descargas).
- Actualización de `AGENTS.md` con una nueva sección normativa que regula el acceso a documentos densos y pliegos de referencia:
  - Prohibición de lectura o precarga automática de estos archivos.
  - Procedimiento de autorización previa obligatoria cuando el agente considere justificado consultar algún apartado específico.
- Definición de la capacidad normativa de gestión documental y contención de contexto en las especificaciones de OpenSpec.

## Capabilities

### New Capabilities
- `gestion-documental`: Define los criterios de custodia de documentos de referencia en `docs/` y el protocolo vinculante de contención de contexto para agentes de IA respecto a documentos extensos.

### Modified Capabilities
<!-- No se modifican requisitos funcionales ni arquitectónicos de capacidades previas. -->

## Impact

- **Archivos afectados**:
  - `docs/ROBOT_TERRESTRE_Contrato.pdf` (nuevo archivo binario de referencia).
  - `docs/ROBOT_TERRESTRE_Anexo_I.pdf` (nuevo archivo binario de referencia).
  - `AGENTS.md` (incorporación de la regla de acceso controlado a documentos densos).
- **Modelos SysML v2**: Ningún archivo en `Modelos/*.sysml` resulta modificado; no se altera ningún requisito técnico (RGEN, RLT1, RNAV, ROPE, RCOM).
- **Consumo de recursos**: Se reduce drásticamente el consumo de tokens y se evita la degradación del contexto de razonamiento en futuras interacciones con agentes.
