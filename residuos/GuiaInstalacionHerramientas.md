# Guía Completa: Despliegue de Eclipse SysON (SysML v2) en Windows desde Cero



# COMO INSTALAR DESDE 0 TODO

Esta guía describe paso a paso cómo preparar tu entorno de Windows, instalar los requisitos necesarios (WSL 2 y Docker Desktop), configurar los contenedores y crear tu primer proyecto de modelado **SysML v2** con **Eclipse SysON**.

---

## Índice
1. [Fase 1: Preparación del Sistema e Instalación](#fase-1-preparación-del-sistema-e-instalación)
   
   - [1.2 Instalar WSL 2 (Subsistema de Windows para Linux)](#12-instalar-wsl-2-subsistema-de-windows-para-linux)
   - [1.3 Instalar Docker Desktop](#13-instalar-docker-desktop)
2. [Fase 2: Estructura de Archivos y Configuración](#fase-2-estructura-de-archivos-y-configuración)
   - [2.1 Carpeta de trabajo](#21-carpeta-de-trabajo)
   - [2.2 Archivo docker-compose.yml](#22-archivo-docker-composeyml)
3. [Fase 3: Puesta en Marcha](#fase-3-puesta-en-marcha)
   - [3.1 Levantar los contenedores](#31-levantar-los-contenedores)
   - [3.2 Verificar que todo esté funcionando](#32-verificar-que-todo-esté-funcionando)
4. [Fase 4: Acceso y Creación del Primer Proyecto SysML v2](#fase-4-acceso-y-creación-del-primer-proyecto-sysml-v2)
5. [Fase 5: Uso Diario y Comandos Útiles](#fase-5-uso-diario-y-comandos-útiles)
6. [Resolución de Problemas Frecuentes](#resolución-de-problemas-frecuentes)

---

## Fase 1: Preparación del Sistema e Instalación



### 1.2 Instalar WSL 2 (Subsistema de Windows para Linux)
Docker Desktop funciona de manera óptima en Windows utilizando el motor de WSL 2:
1. Abre **PowerShell** como **Administrador** (clic derecho > *Ejecutar como administrador*).
2. Ejecuta el comando:
   ```powershell
   wsl --install
   ```
3. Si el sistema te pide reiniciar el equipo, reinícialo para aplicar los cambios.

### 1.3 Instalar Docker Desktop
1. Descarga el instalador oficial de [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop/).
2. Ejecuta el instalador descargado.
3. Asegúrate de marcar la casilla **"Use WSL 2 instead of Hyper-V"** durante la instalación.
4. Una vez terminada la instalación, abre la aplicación **Docker Desktop**.
5. Espera unos segundos hasta que el icono en la esquina inferior izquierda se ponga en color **verde** (*Engine running*).

---

## Fase 2: Estructura de Archivos y Configuración

### 2.1 Carpeta de trabajo
Crea la carpeta donde se almacenarán las configuraciones y los datos de la base de datos de SysON:
1. Abre **PowerShell** y ejecuta:
   ```powershell
   mkdir C:\syson
   cd C:\syson
   ```

### 2.2 Archivo `docker-compose.yml`
Dentro de `C:\syson`, crea el archivo `docker-compose.yml`. Este archivo define los dos servicios necesarios:
- **`database`**: Base de datos PostgreSQL para almacenar los proyectos de forma permanente en la carpeta `./syson-data`.
- **`app`**: El motor web de Eclipse SysON configurado para esperar a que PostgreSQL esté totalmente inicializado (*healthcheck*).

El contenido exacto del archivo debe ser:

```yaml
version: "3.8"

services:
  database:
    image: postgres:15
    environment:
      POSTGRES_DB: postgres
      POSTGRES_USER: username
      POSTGRES_PASSWORD: password
    volumes:
      - ./syson-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U username -d postgres"]
      interval: 3s
      timeout: 3s
      retries: 5
    networks:
      - syson

  app:
    image: eclipsesyson/syson:latest
    restart: on-failure
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://database/postgres
      SPRING_DATASOURCE_USERNAME: username
      SPRING_DATASOURCE_PASSWORD: password
    depends_on:
      database:
        condition: service_healthy
    networks:
      - syson

networks:
  syson:
```

> **Aviso de sintaxis YAML:** No agregues espacios ni tabulaciones al principio de `services:` o `networks:`; deben estar alineados a la izquierda.

---

## Fase 3: Puesta en Marcha

### 3.1 Levantar los contenedores
Abre tu terminal en la carpeta `C:\syson` y ejecuta:

```powershell
cd C:\syson
docker compose up -d
```

Docker descargará automáticamente las imágenes oficiales y levantará los servicios en segundo plano.

### 3.2 Verificar que todo esté funcionando
Puedes comprobar que ambos contenedores están corriendo con:
```powershell
docker ps
```
Deberías ver:
- `syson-database-1` con estado `Up (healthy)`.
- `syson-app-1` con estado `Up` y el puerto `0.0.0.0:8080->8080/tcp`.

---

## Fase 4: Acceso y Creación del Primer Proyecto SysML v2

### 4.1 Abrir la aplicación
Abre tu navegador de internet (Google Chrome, Edge, Firefox, etc.) e ingresa a:
👉 **http://localhost:8080**

*(También puedes abrir Docker Desktop, ir a **Containers**, desplegar el grupo **syson** y hacer clic en el enlace azul **8080:8080**).*

### 4.2 Crear tu proyecto SysML v2
1. En la pantalla inicial (**Projects Browser**):
   - Haz clic en el botón o tarjeta **Create a project** (o **New Project**).
2. Selecciona la opción **SysML v2** (o **Blank Project**).
3. Introduce el nombre que desees para tu proyecto (por ejemplo: `MiSistemaSysML`) y confirma.
4. El sistema abrirá la vista principal del proyecto con:
   - **Árbol del modelo (panel izquierdo):** Paquetes (`Package`), elementos y librerías estándar SysML v2 preinstaladas (*SI*, *Units*, *Quantities*, *Parts*, *Ports*, *Requirements*).
   - **Lienzo central de modelado:** Área gráfica donde diseñar los diagramas.
   - **Paleta de herramientas:** Opciones para crear definiciones de bloques (`part def`), usos de partes (`part`), puertos (`port`), acciones y relaciones de conexión.

---

## Fase 5: Uso Diario y Comandos Útiles

- **Detener SysON al terminar el día:**
  ```powershell
  cd C:\syson
  docker compose stop
  ```
  *(O haciendo clic en el botón **Stop** en Docker Desktop).*

- **Volver a iniciarlo al día siguiente:**
  ```powershell
  cd C:\syson
  docker compose start
  ```
  Y vuelve a entrar en `http://localhost:8080`.

- **Copia de seguridad de tus proyectos:**
  Toda la información se guarda automáticamente en `C:\syson\syson-data`. Basta con copiar o respaldar esa carpeta para no perder ningún proyecto ni diagrama.

---

## Resolución de Problemas Frecuentes

1. **El puerto 8080 ya está en uso por otro programa:**
   - En `docker-compose.yml`, cambia en la sección `app` la línea `- "8080:8080"` por `- "8081:8080"`. Luego accederás desde `http://localhost:8081`.
2. **Error al ejecutar `docker compose` ("no configuration file provided"):**
   - Asegúrate de haber navegado primero a la carpeta con `cd C:\syson`.
3. **El contenedor de la aplicación se reinicia o se apaga inmediatamente:**
   - Comprueba con `docker logs syson-app-1`. Si indica que la base de datos rechazó la conexión, el bloque `healthcheck` y `condition: service_healthy` configurado arriba previene este problema esperando a que PostgreSQL esté listo.
