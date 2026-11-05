# Guía Explicativa: Token de Acceso Personal (PAT) de GitHub

Esta guía explica de forma didáctica qué es el **Token de Acceso Personal (PAT)** de GitHub, por qué se utiliza en el panel web del proyecto **UGV SysML v2**, cómo garantiza la seguridad de tus datos y cómo puedes generarlo si deseas utilizarlo.

---

## 1. ¿Qué es un Token de Acceso Personal (PAT)?

Un **Token de Acceso Personal (Personal Access Token o PAT)** es una clave secreta que actúa como una contraseña alternativa para comunicarte de forma segura con la API de GitHub.

En lugar de introducir tu usuario y contraseña completos en una aplicación web, un token funciona como una **llave con permisos limitados**:
* Le da permiso a la aplicación para realizar únicamente acciones específicas (en nuestro caso, leer y escribir tareas en el apartado de *Issues* del repositorio).
* Puede ser revocado o eliminado en cualquier momento desde los ajustes de tu cuenta de GitHub sin afectar a tu contraseña principal.

---

## 2. ¿Por qué se utiliza en este proyecto?

Nuestra web está desplegada en **GitHub Pages**, que es una plataforma de **alojamiento puramente estático**:

```text
[ Tu Navegador ]  ──────── (Lectura pública directa) ────────► [ GitHub API / Issues ]
       │                                                               ▲
       │ (Si tienes Token PAT: creación/cierre en 1 clic directo)      │
       └───────────────────────────────────────────────────────────────┘
```

1. **Sin servidor backend propio:** No tenemos una base de datos externa ni un servidor Node.js/Python ejecutándose en la nube.
2. **GitHub Issues como base de datos compartida:** Utilizamos las incidencias (*Issues*) del propio repositorio (`juanuniovi/UGV-sysml-`) como almacenamiento universal. Así, cuando asignas una tarea a un compañero, queda registrada en GitHub y es visible al instante para cualquier miembro del equipo cuando abre la web en su propio ordenador.
3. **Escritura autorizada:** La API de GitHub permite a cualquiera **leer** las incidencias públicas sin identificarse, pero para **crear** o **cerrar** una incidencia directamente desde JavaScript dentro de la web, GitHub exige saber qué usuario autorizado está realizando la acción. Para eso sirve el Token.

---

## 3. ¿Es obligatorio tener o configurar un token?

**NO, es 100% opcional.**

El sistema está diseñado con un **modo dual** para que ningún compañero quede bloqueado:

| Modo | ¿Requiere Token? | ¿Cómo se leen las tareas? | ¿Cómo se crean las tareas? | ¿Cómo se completan las tareas? |
| :--- | :---: | :--- | :--- | :--- |
| **Modo Asistido (Por defecto)** | **No** | Automático en tiempo real al abrir la web | Al pulsar *Añadir Tarea*, la web abre GitHub con el título y el responsable ya rellenados. Solo pulsas *Submit new issue*. | Al pulsar el checkbox se marca en tu navegador y te proporciona el enlace directo al Issue para cerrarlo en GitHub. |
| **Modo Directo (Con Token)** | **Sí** | Automático en tiempo real | La tarea se publica en GitHub en **1 solo clic** directamente desde la web sin abrir ninguna pestaña adicional. | Al pulsar el checkbox circular, la incidencia se cierra o reabre automáticamente en GitHub. |

---

## 4. Seguridad y Privacidad: ¿Dónde se almacena el Token?

* **Almacenamiento local exclusivo:** El token se guarda única y exclusivamente en el `localStorage` del navegador de tu propio equipo.
* **Nunca se sube a Git:** El archivo [`.gitignore`](.gitignore) del repositorio prohíbe de forma estricta cualquier archivo de tokens, claves o variables de entorno (`.env`, `*.token`, `tokens.json`, etc.).
* **Nadie más tiene acceso a tu token:** Ni tus compañeros de equipo, ni los profesores, ni el repositorio público pueden ver el token que introduzcas en tu navegador.
* **Control total:** Puedes borrarlo en cualquier momento pulsando el botón **"Eliminar token"** dentro del panel de ajustes de sincronización en la web.

---

## 5. Paso a Paso: Cómo Generar tu Token en GitHub

Si deseas habilitar la creación y marcado de tareas en 1 solo clic desde la web, sigue estos pasos (solo se hace una vez):

1. **Abre la configuración de tokens de GitHub:**
   Accede directamente al siguiente enlace oficial:
   👉 **[Crear nuevo Token Clásico en GitHub](https://github.com/settings/tokens/new?scopes=repo&description=Coche-SysML-Dashboard)**

2. **Rellena los datos básicos:**
   * **Note (Descripción):** `Coche-SysML-Dashboard` (para saber en el futuro para qué sirve).
   * **Expiration (Caducidad):** Puedes seleccionar `30 days`, `60 days` o la duración que tenga la práctica académica.

3. **Verifica los permisos (*Scopes*):**
   * Marca la casilla principal **`repo`** (o al menos `public_repo` si el repositorio es público). Esto otorga permiso para leer y escribir incidencias (*Issues*).

4. **Generar y copiar el token:**
   * Baja hasta el final de la página y pulsa el botón verde **Generate token**.
   * **¡IMPORTANTE!** GitHub solo te mostrará el token una vez. Cópialo inmediatamente (tiene un formato parecido a `ghp_xxxxxxxxxxxxxxxxxxxx`).

5. **Pégalo en el panel web:**
   * En la web del proyecto ([GitHub Pages](https://juanuniovi.github.io/UGV-sysml-/)), dirígete a la sección **Tareas**.
   * Pulsa el botón **GitHub Issues** en la esquina superior derecha.
   * Pega tu clave en el campo *Token de Acceso Personal (PAT) de GitHub*.
   * Pulsa **Guardar configuración**.

¡Listo! A partir de ese momento podrás asignar y cerrar tareas directamente desde el panel sin salir de la página.
