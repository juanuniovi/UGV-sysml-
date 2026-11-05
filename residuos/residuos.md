# Registro de Archivos Archivados en Residuos y Transición Tecnológica

Este documento detalla los archivos trasladados a la carpeta `residuos/`, los motivos de su archivo (o retirada del flujo de trabajo activo de la raíz del proyecto), el estudio técnico de las herramientas involucradas (**Docker**, **GitHub Personal Access Token**, **Magic / Cameo / MagicGrid**) y la descripción del flujo de trabajo actual adoptado por el equipo (**Spec42** y **gestión por commits en Issues**).

---

## 1. Relación de Archivos Archivados

Los siguientes archivos se han movido desde la raíz del proyecto a `residuos/` para mantener limpio el espacio de trabajo activo, sin perder su contenido ante una posible necesidad futura:

| Archivo Original | Ubicación Actual | Tipo / Rol | Motivo del Archivo |
| :--- | :--- | :--- | :--- |
| `docker-compose.yml` | `residuos/docker-compose.yml` | Infraestructura / Orquestación | Despliegue en contenedores de Eclipse SysON y PostgreSQL. Ya no se utiliza Docker localmente. |
| `GuiaInstalacionHerramientas.md` | `residuos/GuiaInstalacionHerramientas.md` | Documentación técnica | Manual de instalación paso a paso de WSL 2, Docker Desktop y SysON. Obsoleto para el flujo actual. |
| `GUIA_TOKEN_GITHUB.md` | `residuos/GUIA_TOKEN_GITHUB.md` | Guía de configuración | Manual didáctico sobre cómo generar un Token de Acceso Personal (PAT) para el panel web. Se retira del directorio activo. |

> **Nota:** La copia redundante en `docs/GUIA_TOKEN_GITHUB.md` también ha sido retirada para evitar confusión y referencias a flujos no vigentes, quedando su contenido preservado en `residuos/GUIA_TOKEN_GITHUB.md`.

---

## 2. Estudio Técnico de las Herramientas y Justificación del Cambio

### 2.1. Docker y Eclipse SysON vs. Spec42 (Spect42)

* **¿Cómo funcionaba anteriormente?**
  * Se configuró un entorno basado en `docker-compose.yml` que levantaba dos contenedores:
    1. Una base de datos relacional PostgreSQL (`postgres:15`) con almacenamiento en `./syson-data`.
    2. El servidor web de modelado **Eclipse SysON** (`eclipsesyson/syson:latest`) expuesto en el puerto `8080`.
  * Requiere instalar y mantener **Docker Desktop** y el subsistema **WSL 2** en Windows, lo que acarrea alto consumo de memoria RAM, procesos en segundo plano y dependencias externas de virtualización.

* **¿Por qué se traslada a residuos y cuál es el estándar actual?**
  * **Adopción de Spec42 (`Spect42`)**: El equipo trabaja actualmente con la suite **Spec42** (desarrollada por Elan8), una herramienta abierta y *local-first* específicamente diseñada para **OMG SysML v2** y **KerML**.
  * **Ventajas de Spec42 frente al entorno Docker/SysON:**
    * **Ligero y nativo:** Se ejecuta como extensión de editor (VS Code) y binario CLI en Rust (`spec42 check`), sin necesidad de máquinas virtuales, contenedores Docker ni bases de datos PostgreSQL.
    * **Modelado textual nativo:** El código de los modelos reside directamente en archivos planos `.sysml` en el repositorio Git (carpeta `Modelos/`), facilitando el control de versiones, revisión de cambios (*diffs*) y ramas concurrentes.
    * **Análisis y vistas integradas:** Proporciona servidor de lenguaje (LSP), diagnósticos sintácticos/semánticos instantáneos, autocompletado y un panel de vistas para renderizar diagramas estructurales e interconexiones sin salir del IDE.
  * Por tanto, los archivos de Docker y SysON se conservan en esta carpeta como material de referencia o para posibles pruebas de interoperabilidad futuras con SysON, pero quedan fuera del entorno de desarrollo diario.

---

### 2.2. Token de Acceso Personal (PAT) de GitHub vs. Commits en Issues

* **¿Cómo funcionaba anteriormente?**
  * La interfaz web del panel de tareas (`index.html` / `app.js`) incluía la opción de almacenar un **Personal Access Token (PAT)** con permisos de escritura (`repo`) en el `localStorage` del navegador.
  * El objetivo era permitir que un usuario crease o cerrase incidencias en GitHub directamente con un clic desde el cliente web llamando a la API REST de GitHub con cabeceras `Authorization: Bearer <TOKEN>`.
  * Se documentó este proceso en `GUIA_TOKEN_GITHUB.md`.

* **¿Por qué se traslada a residuos y cuál es el estándar actual?**
  * **Gestión nativa por Commits en Issues:** La gestión del avance del proyecto se realiza ahora mediante la trazabilidad estándar de Git y GitHub:
    * Cada tarea o incidencia tiene su correspondiente **Issue** en GitHub (por ejemplo, `#12`).
    * Al realizar el trabajo en el modelo o en la documentación, el desarrollador incluye la referencia en el mensaje del commit o en el Pull Request:
      * `feat(rodaje): implementa suspension neumática regulable (closes #12)`
      * `fix(planta): corrige potencia auxiliar exported 120kW (#5)`
    * Al subir o fusionar el commit en la rama principal (`main`), GitHub cierra automáticamente el issue o lo vincula de forma auditable en el historial del repositorio.
  * **Ventajas del nuevo flujo:**
    * **Seguridad y sencillez:** Ningún alumno ni desarrollador tiene que generar claves secretas, configurar scopes ni almacenarlas en su navegador local.
    * **Auditoría completa:** Cada cierre de tarea queda respaldado por un commit verificable con autoría criptográfica en Git, en lugar de una acción aislada vía API web.
    * La web del proyecto ahora puede funcionar en **modo lectura pública** (sin credenciales), mostrando el estado del proyecto a partir de la API pública de GitHub.

---

### 2.3. Magic (Cameo Systems Modeler / MagicDraw / MagicGrid)

* **Presencia en el repositorio:**
  * En el archivo `Modelos/10_comportamiento.sysml` (línea 2) figura el comentario:
    ```sysml
    doc /* Maquina de estados de los modos operacionales del UGV (MagicGrid / Pliego CDTI) */
    ```
  * En la ingeniería de sistemas basada en modelos (MBSE), **MagicDraw** (posteriormente **Cameo Systems Modeler**, de No Magic / Dassault Systèmes) y su metodología asociada **MagicGrid** han sido durante años el estándar industrial dominante para SysML v1.

* **Situación actual con respecto a Spec42:**
  * No existen archivos binarios de proyecto MagicDraw (`.mdzip` o `.cam`) en el repositorio. La mención en `10_comportamiento.sysml` es puramente metodológica, reflejando que la descomposición de modos operativos del UGV (Teleoperado, Autónomo, Sigiloso, Degradado) se inspiró en los niveles de comportamiento de MagicGrid adaptados a los requisitos del pliego CDTI.
  * Para el desarrollo actual en **SysML v2**, el equipo prescinde de suites propietarias pesadas como Cameo/MagicDraw en favor de **Spec42** (`Spect42`), aprovechando la estandarización textual y abierta de SysML v2.

---

## 3. Resumen Comparativo de Flujos de Trabajo

| Ámbito | Enfoque Anterior (Archivado en `residuos/`) | Enfoque Actual en Uso |
| :--- | :--- | :--- |
| **Entorno de Modelado** | Eclipse SysON sobre Docker Desktop + PostgreSQL (`localhost:8080`) | **Spec42** (`Spect42`) nativo en VS Code + CLI Rust (`spec42 check`) |
| **Control de Tareas** | Creación/cierre desde cliente web mediante GitHub PAT en `localStorage` | **Commits en Issues** (`closes #ID`, enlaces en PRs y git log) |
| **Metodología CASE** | Planteamientos heredados de MagicDraw / MagicGrid (SysML v1) | **OMG SysML v2 puro** con especificaciones textuales y modulares |
| **Dependencias Locales** | Requiere Docker Desktop, WSL 2, PostgreSQL y puertos de red abiertos | Únicamente editor de código, Git y extensión Spec42 |

---

## 4. Procedimiento de Recuperación (En caso de uso futuro)

Si en el futuro se requiriese levantar una instancia de Eclipse SysON para verificar compatibilidad o exportación:

1. **Docker / SysON:**
   * Mover `residuos/docker-compose.yml` a la raíz (o ejecutarlo directamente desde `residuos/`):
     ```powershell
     cd residuos
     docker compose up -d
     ```
   * Consultar `residuos/GuiaInstalacionHerramientas.md` para los pasos detallados de resolución de conflictos de puertos o configuración de WSL 2.

2. **GitHub Token:**
   * Si se desarrollase una integración backend o script de CI/CD que requiera llamadas autenticadas a la API de GitHub, consultar `residuos/GUIA_TOKEN_GITHUB.md` como referencia para la creación de tokens con scopes mínimos requeridos.
