# gestion-documental Specification

## Purpose
Establecer las normas de custodia y acceso a la documentación contractual y técnica de referencia del proyecto UGV, regulando las restricciones de lectura para agentes de IA con el fin de preservar el contexto y evitar consumo innecesario de tokens.

## Requirements

### Requirement: Custodia de documentos de referencia
El repositorio del proyecto SHALL custodiar en el directorio `docs/` las copias íntegras en formato PDF del contrato y del anexo técnico del sistema UGV terrestre (`curso_ROBOT_TERRESTRE_Contrato.pdf` y `curso_ROBOT_TERRESTRE_Anexo_I.pdf`).

#### Scenario: Presencia de archivos oficiales en el repositorio
- **WHEN** un desarrollador o auditor inspecciona el directorio `docs/` del proyecto
- **THEN** los archivos `curso_ROBOT_TERRESTRE_Contrato.pdf` y `curso_ROBOT_TERRESTRE_Anexo_I.pdf` MUST estar disponibles como fuentes documentales primarias.

### Requirement: Restricción de acceso y contención de contexto para agentes
Los agentes de IA que operen en el repositorio SHALL NOT leer, inspeccionar ni precargar en su contexto los documentos PDF extensos ubicados en `docs/` de manera autónoma o por defecto.

#### Scenario: Petición habitual sin mención explícita
- **WHEN** un usuario formula una petición de diseño, modelado SysML o consulta general que no solicite explícitamente consultar los documentos PDF
- **THEN** el agente MUST abstenerse de leer los archivos PDF y no incorporará su contenido a la ventana de contexto.

#### Scenario: Petición con solicitud explícita del usuario
- **WHEN** el usuario indica de manera explícita y directa que desea consultar, contrastar o extraer información de los documentos PDF de `docs/`
- **THEN** el agente SHALL acceder a la sección o contenido necesario de los documentos de forma proporcional.

#### Scenario: Propuesta proactiva del agente ante necesidad justificada
- **WHEN** el agente identifique que la resolución rigurosa de una tarea requiere consultar un aspecto contractual o técnico contenido en los documentos PDF
- **THEN** el agente MUST formular una propuesta previa y justificada al usuario explicando qué información necesita y por qué, y solo SHALL leer el documento tras recibir la autorización explícita del usuario.
