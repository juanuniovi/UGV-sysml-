# Panel de Control y Reparto de Tareas (UGV SysML v2)

Este panel web permite coordinar el trabajo en equipo para el proyecto de ingeniería de sistemas (MBSE) del **UGV Pesado Dual (CDTI)**:
* **Tablero de Tareas**: Reparto y asignación de tareas sincronizadas en tiempo real con los *GitHub Issues*.
* **Catálogo de Archivos**: Seguimiento de los 11 módulos `.sysml` del modelo con autoría y estado.
* **Actividad del Equipo**: Contribuidores, historial de commits y ramas de trabajo activas.

---

## 🚀 Cómo abrir la previsualización en local

No requiere instalar Node.js ni configurar servidores web:

1. Ve a la carpeta `docs/` en tu explorador de archivos.
2. Abre [`index.html`](index.html) en tu navegador favorito.
3. La web se conectará automáticamente con la API pública de GitHub para cargar los datos del repositorio: [**`juanuniovi/UGV-sysml-`**](https://github.com/juanuniovi/UGV-sysml-).

---

## 🌐 Publicación en GitHub Pages

Para habilitar la web en internet accesible para todos los alumnos:

1. Entra en tu repositorio en GitHub: `https://github.com/juanuniovi/UGV-sysml-`
2. Ve a **Settings** > **Pages**.
3. En **Build and deployment > Source**: Selecciona `Deploy from a branch`.
4. En **Branch**: Selecciona `main` y la carpeta `/docs`.
5. Pulsa en **Save**. En un par de minutos la web estará disponible en:
   👉 **`https://juanuniovi.github.io/UGV-sysml-/`**
