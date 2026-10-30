# Guía de Trabajo: OpenSpec en Entornos de Agentes (Antigravity)

## 1. ¿Por qué usamos OpenSpec?

OpenSpec introduce una metodología guiada por especificaciones (*spec-driven development*) dentro del ciclo asistido por IA, resolviendo los problemas comunes al codificar con agentes:

* **Eliminación de desviaciones y alucinaciones:** Evita que el agente empiece a escribir código sin rumbo o tomando decisiones arbitrarias. Impone una etapa de diseño y lista de tareas antes de modificar archivos.

* **Contexto compartido y sincronizado:** Garantiza que el conocimiento técnico no resida solo en la memoria temporal del chat. Queda registrado en el repositorio para que cualquier compañero (o agente en otra máquina) trabaje sobre la misma base.

* **Trazabilidad en el repositorio:** Cada cambio de arquitectura o funcionalidad genera un historial explícito de decisiones, especificaciones y tareas completadas junto con los commits.

* **Seguridad y modularidad:** Permite planificar y prototipar en especificaciones aisladas (*deltas*) sin romper los esquemas globales del proyecto hasta que la funcionalidad sea estable y validada.

## 2. Flujo de Trabajo Recomendado

Este es el procedimiento estándar para desarrollar una funcionalidad o refactorización desde cero:

```
[ Antigravity ]
       │
       ▼
1. /openspec-propose      ──► Define diseño técnico y desglose de tareas
       │
       ▼
2. Revisión del Plan     ──► Ajustes antes de tocar código (/openspec-update-change si aplica)
       │
       ▼
3. /openspec-apply-change ──► El agente implementa el código paso a paso
       │
       ▼
4. /openspec-sync-specs   ──► Sincroniza las specs del cambio con las specs base del proyecto
       │
       ▼
5. /openspec-archive-change ──► Archiva la tarea en el histórico y limpia el estado activo
       │
       ▼
6. Git Commit & Push      ──► Sube el código y las especificaciones a la rama compartida

```

### Paso a paso:

1. **Abrir Antigravity en la carpeta del proyecto**

   No es necesario reiniciar ni reejecutar ningún `init`. El agente detecta automáticamente la configuración existente.

2. **Crear la propuesta técnica**

   Lanza el comando describiendo el objetivo:

   ```
   /openspec-propose Añade un endpoint POST /auth/login con validación de credenciales y retorno de token JWT.
   
   ```

   *El agente generará el diseño, las tareas y las especificaciones delta correspondientes.*

3. **Revisar el plan**

   Revisa los archivos que el agente planea crear o editar. Si necesitas corregir el alcance antes de programar, coméntaselo en el chat o usa `/openspec-update-change`.

4. **Implementar el cambio**

   Ordena al agente que ejecute las tareas planificadas:

   ```
   /openspec-apply-change
   
   ```

   *El agente modificará y creará el código fuente en el proyecto.*

5. **Actualizar el contexto para el equipo**

   Una vez que el código funciona y las pruebas pasan, traslada las definiciones técnicas a la base global:

   ```
   /openspec-sync-specs
   
   ```

6. **Archivar la tarea finalizada**

   Cierra el ciclo de la tarea para mantener limpio el entorno de trabajo:

   ```
   /openspec-archive-change
   
   ```

7. **Publicar en Git**

   Envía los cambios de código y de contexto al repositorio:

   ```
   git add .
   git commit -m "feat(auth): implementar endpoint /auth/login con jwt"
   git push origin <tu-rama>
   
   ```

## 3. Catálogo de Comandos Slash

| Comando | Función principal | ¿Cuándo utilizarlo? | 
| ----- | ----- | ----- | 
| **`/openspec-propose`** | Diseña y genera la propuesta completa en un solo paso (diseño, especificaciones y lista de tareas). | Al iniciar cualquier nueva funcionalidad o refactorización relevante. | 
| **`/openspec-explore`** | Inicia un modo de análisis y diálogo para clarificar dudas o investigar requisitos técnicos. | Antes de proponer un cambio, cuando la solución técnica aún es incierta. | 
| **`/openspec-apply-change`** | Aplica secuencialmente las tareas planificadas en el código fuente. | Cuando la propuesta técnica ha sido revisada y está lista para implementarse. | 
| **`/openspec-update-change`** | Revisa y reconcilia los artefactos de planificación si cambian las decisiones iniciales. | Durante el desarrollo, si descubres nuevos requisitos o cambias la arquitectura. | 
| **`/openspec-sync-specs`** | Integra las especificaciones delta del cambio en las especificaciones centrales del proyecto. | Al terminar o estabilizar la implementación, para que tus compañeros tengan el contexto al día. | 
| **`/openspec-archive-change`** | Finaliza y archiva el cambio implementado dentro del histórico del proyecto. | Una vez concluida y probada toda la tarea, como paso de cierre. | 

## 4. Preguntas Frecuentes

### ¿Puedo pedirle cosas al agente sin usar comandos de OpenSpec?

**Sí.** El agente puede editar código libremente mediante lenguaje natural. Sin embargo, para cambios estructurales o nuevos endpoints, no usar el flujo de OpenSpec provoca que las especificaciones del repositorio queden desactualizadas respecto al código, perdiendo alineación con el equipo.

### ¿Tengo que inicializar OpenSpec cada día?

**No.** `init` solo se ejecuta una vez en la vida del proyecto. Todo el estado y la configuración quedan persistidos en los archivos del directorio y en Git.