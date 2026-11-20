# Spec Delta: buenas-practicas-modelado-entorno

## ADDED Requirements

### Requirement: Satisfacción única de cada requisito
Cada requisito del modelo SHALL satisfacerse en un único nivel jerárquico. Si una definición de parte satisface un requisito internamente (`satisfy requirement : Req;`), ningún contenedor que la instancie MUST declarar además `satisfy requirement : Req by <parte>;`, y viceversa. Los agentes SHALL comprobar, antes de añadir una cláusula `satisfy`, que el requisito no esté ya satisfecho en otro nivel.

#### Scenario: Detección de satisfacción duplicada
- **WHEN** se busca un identificador de requisito en las cláusulas `satisfy` de `Modelos/*.sysml`
- **THEN** aparece en una sola cláusula `satisfy`

### Requirement: Validación de vistas con Spec42
La validación con Spec42 exigida para todo cambio en `Modelos/` SHALL incluir, además de `spec42 check Modelos` con 0 errores y 0 avisos, el renderizado de todas las vistas declaradas (`spec42 diagram Modelos --view <vista>`), y MUST NOT darse por superada si alguna vista no se renderiza.

#### Scenario: Cambio que rompe una vista sin errores de sintaxis
- **WHEN** un cambio supera `spec42 check` pero alguna vista devuelve un aviso del renderizador (por ejemplo, `diagram occurrence is outside the projected node set`)
- **THEN** la validación se considera fallida y el cambio no se integra en `main` hasta corregirlo

### Requirement: Configuración compartida portable
Los archivos de configuración versionados (`.vscode/`, `openspec/config.yaml` y scripts del repositorio) MUST NOT contener rutas absolutas ni rutas dependientes del perfil de un usuario o equipo concreto. Las rutas locales SHALL declararse en la configuración de usuario del editor, fuera del repositorio.

#### Scenario: Revisión de configuración compartida
- **WHEN** se modifica un archivo de `.vscode/` u otra configuración versionada
- **THEN** no contiene rutas del tipo `C:\Users\<usuario>\...` ni equivalentes, y la herramienta funciona en cualquier equipo con la extensión instalada
