/**
 * UGV SysML v2 — Panel de Control y Seguimiento
 * Arquitectura y Diseño estilo Apple Human Interface Guidelines
 * Sincronización Remota de Tareas con GitHub Issues
 */

const REPO_OWNER = "juanuniovi";
const REPO_NAME = "UGV-sysml-";

// Lista canónica única de los 5 integrantes del equipo
const EQUIPO_CANONICO = [
  {
    id: "juan",
    loginPrincipal: "juanuniovi",
    alias: ["juanuniovi", "juan"],
    nombre: "Juan",
    rol: "Profesor",
    avatar: "https://github.com/juanuniovi.png",
    ramaPreferida: "main"
  },
  {
    id: "pelayo",
    loginPrincipal: "pprguez2005-byte",
    alias: ["pprguez2005-byte", "pprguez2005", "pelayo"],
    nombre: "Pelayo Rodríguez",
    rol: "Colaborador",
    avatar: "https://github.com/pprguez2005-byte.png",
    ramaPreferida: "Pelayo"
  },
  {
    id: "jose",
    loginPrincipal: "josescobedov",
    alias: ["josescobedov", "evjose", "jose", "josé"],
    nombre: "José Escobedo",
    rol: "Colaborador",
    avatar: "https://github.com/josescobedov.png",
    ramaPreferida: "Jose"
  },
  {
    id: "eloy",
    loginPrincipal: "EloySuarezCostales",
    alias: ["eloysuarezcostales", "eloy suárez costales", "eloy suarez costales", "eloy"],
    nombre: "Eloy Suárez Costales",
    rol: "Colaborador",
    avatar: "https://github.com/EloySuarezCostales.png",
    ramaPreferida: "Eloy"
  },
  {
    id: "cesar",
    loginPrincipal: "cesarbobes",
    alias: ["cesarbobes", "cesar", "césar bobes", "cesar bobes"],
    nombre: "César Bobes",
    rol: "Colaborador",
    avatar: "https://github.com/cesarbobes.png",
    ramaPreferida: "cesar"
  },
  {
    id: "aimen",
    loginPrincipal: "Aimen05c",
    alias: ["aimen05c", "aimen"],
    nombre: "Aimen",
    rol: "Colaborador",
    avatar: "https://github.com/Aimen05c.png",
    ramaPreferida: "Aimen"
  },
  {
    id: "marcos",
    loginPrincipal: "mCrespo92",
    alias: ["mcrespo92", "marcos", "crespo"],
    nombre: "Marcos Crespo",
    rol: "Colaborador",
    avatar: "https://github.com/mCrespo92.png",
    ramaPreferida: "Marcos"
  }
];

// Catálogo estructurado de archivos del proyecto con atribución de autoría
const ARCHIVOS_REPOSITORIO = [
  {
    path: "Modelos/00_tipos_base.sysml",
    categoria: "Modelos/",
    descripcion: "Magnitudes físicas y definiciones de puertos estándar (Mecánico, Potencia, Bus, RF)",
    autorId: "pelayo",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/01_barcaza.sysml",
    categoria: "Modelos/",
    descripcion: "Barcaza estructural, chasis en V, cabestrante y bahías de anclaje (RGEN-02..05)",
    autorId: "pelayo",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/02_tren_rodaje.sysml",
    categoria: "Modelos/",
    descripcion: "Tren de ruedas independientes y suspensión neumática regulable/retráctil (RLT1-01..05)",
    autorId: "eloy",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/03_planta_motriz.sysml",
    categoria: "Modelos/",
    descripcion: "Planta híbrida 100% biocombustible, modo silencioso y exportación 120kW (RGEN-11..19)",
    autorId: "jose",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/04_navegacion_control.sysml",
    categoria: "Modelos/",
    descripcion: "Cerebro GNC: autonomía waypoints, Follow-Me, Detect & Avoid y sensores 360° (ROPE, RNAV)",
    autorId: "juan",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/05_comunicaciones.sysml",
    categoria: "Modelos/",
    descripcion: "Comunicaciones tácticas BLOS/LOS con cifrado militar COMSEC (RCOM-01..03)",
    autorId: "aimen",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/06_estaciones_control.sysml",
    categoria: "Modelos/",
    descripcion: "Puesto de Mando Portable (PMP - Linux) y Consola Ligera (CPT - LOS) (ROPE-01..03)",
    autorId: "marcos",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/07_uav_cenital.sysml",
    categoria: "Modelos/",
    descripcion: "Dron aéreo de exploración y relé con base de recarga en el techo del UGV",
    autorId: "marcos",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/08_cargas_pago.sysml",
    categoria: "Modelos/",
    descripcion: "Módulos de misión intercambiables: ISTAR (mástil), Logístico (palets) y MEDEVAC (heridos)",
    autorId: "cesar",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/09_sistema_ugv.sysml",
    categoria: "Modelos/",
    descripcion: "Ensamblado del SoI completo y topología de conexiones internas (IBD)",
    autorId: "pelayo",
    tipo: "SysML v2"
  },
  {
    path: "Modelos/10_comportamiento.sysml",
    categoria: "Modelos/",
    descripcion: "Máquina de estados de modos de misión: Teleoperado, Autónomo, Sigiloso, Degradado",
    autorId: "eloy",
    tipo: "SysML v2"
  },
  {
    path: "Vistas graficas/diagrama_componentes_ugv.svg",
    categoria: "Vistas graficas/",
    descripcion: "Diagrama vectorial SVG de alta resolución con las 3 redes de enlace del UGV",
    autorId: "juan",
    tipo: "SVG"
  },
  {
    path: "Vistas graficas/index.html",
    categoria: "Vistas graficas/",
    descripcion: "Visor interactivo con filtros dinámicos de flujos (Datos, Energía y Mecánica)",
    autorId: "juan",
    tipo: "HTML"
  },
  {
    path: "README.md",
    categoria: "docs/",
    descripcion: "Especificación técnica, tabla de paquetes y diagrama de conexiones del UGV",
    autorId: "cesar",
    tipo: "Markdown"
  },
  {
    path: "docs/GUIA_TOKEN_GITHUB.md",
    categoria: "docs/",
    descripcion: "Guía didáctica sobre el Token de Acceso Personal (PAT) de GitHub para el panel",
    autorId: "pelayo",
    tipo: "Markdown"
  }
];

let estadoApp = {
  seccionActual: "panel", // panel | archivos | tareas | miembro
  miembros: [],
  commits: [],
  ramas: [],
  pullRequests: [],
  tareas: [],
  origenTareas: "github", // github | cache | local
  syncStatus: "cargando", // conectado | cargando | offline | local
  tareaPendienteCrear: null,
  filtroTareas: "todas", // todas | pendientes | completadas
  filtroArchivos: "todos", // todos | Modelos/ | openspec/ | docs/
  busquedaArchivo: "",
  cargando: true
};

// ====================================================================
// INICIALIZACIÓN
// ====================================================================
document.addEventListener("DOMContentLoaded", () => {
  configurarNavegacion();
  configurarModalesYEventos();
  configurarEventosArchivosYTareas();
  inicializarDatos();
});

// Manejo de rutas con Hash para navegación fluida
function configurarNavegacion() {
  window.addEventListener("hashchange", procesarRutaActual);

  document.getElementById("nav-btn-panel").addEventListener("click", () => {
    window.location.hash = "#/panel";
  });

  document.getElementById("nav-btn-archivos").addEventListener("click", () => {
    window.location.hash = "#/archivos";
  });

  document.getElementById("nav-btn-tareas").addEventListener("click", () => {
    window.location.hash = "#/tareas";
  });

  const btnVolver = document.getElementById("btn-volver");
  if (btnVolver) {
    btnVolver.addEventListener("click", () => {
      window.location.hash = "#/panel";
    });
  }

  const btnRecargar = document.getElementById("btn-recargar");
  if (btnRecargar) {
    btnRecargar.addEventListener("click", () => {
      sessionStorage.clear();
      inicializarDatos();
      mostrarToast("Datos actualizados desde el repositorio", "info");
    });
  }
}

function procesarRutaActual() {
  const hash = window.location.hash || "#/panel";

  // Actualizar estados de botones en el Segmented Control
  document.querySelectorAll(".apple-segmented-control button").forEach(b => b.classList.remove("active"));

  if (hash.startsWith("#/miembro/")) {
    const idOMiembro = hash.replace("#/miembro/", "").trim();
    mostrarVistaMiembro(idOMiembro);
    document.getElementById("nav-btn-panel").classList.add("active");
  } else if (hash === "#/archivos") {
    mostrarSeccion("vista-archivos");
    document.getElementById("nav-btn-archivos").classList.add("active");
    renderizarArchivos();
  } else if (hash === "#/tareas") {
    mostrarSeccion("vista-tareas");
    document.getElementById("nav-btn-tareas").classList.add("active");
    renderizarTareas();
  } else {
    mostrarSeccion("vista-general");
    document.getElementById("nav-btn-panel").classList.add("active");
  }
}

function mostrarSeccion(idSeccion) {
  const secciones = ["vista-general", "vista-miembro", "vista-archivos", "vista-tareas"];
  secciones.forEach(id => {
    const el = document.getElementById(id);
    if (!el) return;
    if (id === idSeccion) {
      el.classList.remove("view-hidden");
      el.classList.add("view-visible");
    } else {
      el.classList.remove("view-visible");
      el.classList.add("view-hidden");
    }
  });
  window.scrollTo({ top: 0, behavior: "smooth" });
}

// ====================================================================
// GESTIÓN DE TOKEN PERSONAL DE GITHUB (PAT)
// ====================================================================
function obtenerGitHubToken() {
  return localStorage.getItem("sysml_github_token") || "";
}

function guardarGitHubToken(token) {
  if (token && token.trim()) {
    localStorage.setItem("sysml_github_token", token.trim());
  } else {
    localStorage.removeItem("sysml_github_token");
  }
  actualizarUIModalToken();
}

function eliminarGitHubToken() {
  localStorage.removeItem("sysml_github_token");
  actualizarUIModalToken();
  mostrarToast("Token eliminado. Modo lectura activa.", "info");
}

function actualizarUIModalToken() {
  const token = obtenerGitHubToken();
  const input = document.getElementById("input-github-token");
  const badge = document.getElementById("badge-token-status");
  const btnEliminar = document.getElementById("btn-eliminar-token");

  if (input) {
    input.value = token ? "••••••••••••••••••••••••••••••••" : "";
  }
  if (badge) {
    if (token) {
      badge.textContent = "Token activo (Lectura y Escritura)";
      badge.className = "text-[#34c759] font-medium";
    } else {
      badge.textContent = "Sin token (Modo lectura)";
      badge.className = "text-[#86868b] font-mono";
    }
  }
  if (btnEliminar) {
    btnEliminar.classList.toggle("hidden", !token);
  }
}

// ====================================================================
// CARGA DE DATOS DE LA API DE GITHUB (MÉTRICAS, COMMITS Y TAREAS)
// ====================================================================
async function inicializarDatos() {
  mostrarLoader(true);
  try {
    const [resColabs, resRamas, resCommits, resPRs] = await Promise.all([
      fetchConCache(`https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/contributors`),
      fetchConCache(`https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/branches`),
      fetchConCache(`https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits?per_page=100`),
      fetchConCache(`https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/pulls?state=all`)
    ]);

    estadoApp.ramas = resRamas || [];
    estadoApp.commits = resCommits || [];
    estadoApp.pullRequests = resPRs || [];
    estadoApp.miembros = procesarIntegrantes(resColabs || [], estadoApp.commits, estadoApp.ramas);

    renderizarMetricas();
    renderizarGridMiembros();
    renderizarTimelineGlobal();
    renderizarArchivos();

    // Carga asíncrona colaborativa de tareas desde GitHub Issues
    await cargarTareas();

    procesarRutaActual();

  } catch (err) {
    console.warn("Aviso API GitHub, utilizando datos locales estructurados:", err);
    usarDatosLocales();
  } finally {
    mostrarLoader(false);
  }
}

async function fetchConCache(url) {
  const cacheKey = "cache_" + url;
  const expiracionKey = "exp_" + url;
  const guardado = sessionStorage.getItem(cacheKey);
  const expira = sessionStorage.getItem(expiracionKey);

  if (guardado && expira && Date.now() < parseInt(expira, 10)) {
    return JSON.parse(guardado);
  }

  const headers = {
    "Accept": "application/vnd.github.v3+json"
  };
  const token = obtenerGitHubToken();
  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  const res = await fetch(url, { headers });
  if (!res.ok) throw new Error(`HTTP error ${res.status}`);
  const data = await res.json();
  sessionStorage.setItem(cacheKey, JSON.stringify(data));
  sessionStorage.setItem(expiracionKey, (Date.now() + 5 * 60 * 1000).toString());
  return data;
}

function encontrarIntegrante(texto) {
  if (!texto) return null;
  const limpio = texto.toLowerCase().trim();
  return EQUIPO_CANONICO.find(m => 
    m.id === limpio || 
    m.loginPrincipal.toLowerCase() === limpio || 
    m.alias.some(a => a.toLowerCase() === limpio || limpio.includes(a.toLowerCase()))
  );
}

function procesarIntegrantes(colaboradores, commits, ramas) {
  const miembrosMap = new Map();
  EQUIPO_CANONICO.forEach(m => {
    miembrosMap.set(m.id, {
      id: m.id,
      login: m.loginPrincipal,
      nombre: m.nombre,
      rol: m.rol,
      avatar: m.avatar,
      totalCommits: 0,
      ramaActual: m.ramaPreferida,
      ultimoCommit: null,
      commits: []
    });
  });

  colaboradores.forEach(c => {
    const miembro = encontrarIntegrante(c.login);
    if (miembro) {
      const obj = miembrosMap.get(miembro.id);
      obj.totalCommits += (c.contributions || 0);
      if (c.avatar_url) obj.avatar = c.avatar_url;
    }
  });

  commits.forEach(item => {
    const loginAutor = item.author ? item.author.login : null;
    const nombreAutor = item.commit && item.commit.author ? item.commit.author.name : null;
    const emailAutor = item.commit && item.commit.author ? item.commit.author.email : null;

    const match = encontrarIntegrante(loginAutor) || 
                  encontrarIntegrante(nombreAutor) || 
                  encontrarIntegrante(emailAutor);

    if (match) {
      const obj = miembrosMap.get(match.id);
      const info = {
        sha: item.sha.substring(0, 7),
        mensaje: item.commit.message.split("\n")[0],
        fecha: new Date(item.commit.author.date),
        url: item.html_url
      };
      if (!obj.commits.some(c => c.sha === info.sha)) {
        obj.commits.push(info);
      }
      if (!obj.ultimoCommit || info.fecha > obj.ultimoCommit.fecha) {
        obj.ultimoCommit = info;
      }
    }
  });

  miembrosMap.forEach(obj => {
    if (obj.commits.length > 0) {
      obj.totalCommits = Math.max(obj.totalCommits, obj.commits.length);
    }
  });

  ramas.forEach(r => {
    const rName = r.name.toLowerCase();
    EQUIPO_CANONICO.forEach(m => {
      const obj = miembrosMap.get(m.id);
      if (m.alias.some(a => rName.includes(a.toLowerCase())) || rName.includes(m.ramaPreferida.toLowerCase())) {
        obj.ramaActual = r.name;
      }
    });
  });

  return Array.from(miembrosMap.values()).sort((a, b) => b.totalCommits - a.totalCommits);
}

function renderizarMetricas() {
  document.getElementById("stat-commits").textContent = estadoApp.commits.length || "30+";
  document.getElementById("stat-ramas").textContent = estadoApp.ramas.length || "8";
  document.getElementById("stat-miembros").textContent = estadoApp.miembros.length;
  document.getElementById("stat-prs").textContent = estadoApp.pullRequests.length || "6";
}

function renderizarGridMiembros() {
  const container = document.getElementById("grid-miembros");
  if (!container) return;
  container.innerHTML = "";

  estadoApp.miembros.forEach(m => {
    const card = document.createElement("div");
    card.className = "apple-card apple-card-interactive p-5 flex flex-col justify-between";
    
    const fechaTexto = m.ultimoCommit 
      ? formatearFechaRelativa(m.ultimoCommit.fecha) 
      : "Sin commits en main";

    card.innerHTML = `
      <div>
        <div class="flex items-start justify-between gap-3">
          <div class="flex items-center space-x-3.5">
            <img src="${m.avatar}" alt="${m.nombre}" class="w-12 h-12 rounded-2xl border border-[#0000000d] object-cover bg-[#f5f5f7]" onerror="this.src='https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'">
            <div>
              <h3 class="font-semibold text-base text-[#1d1d1f] tracking-tight leading-snug">${m.nombre}</h3>
              <p class="text-xs text-[#86868b] font-mono">@${m.login}</p>
            </div>
          </div>
          <svg class="w-4 h-4 text-[#86868b] shrink-0 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </div>

        <div class="mt-4">
          <span class="apple-pill ${m.rol === 'Profesor' ? 'bg-[#0071e30f] text-[#0071e3] border border-[#0071e31f] font-semibold' : 'bg-[#f5f5f7] text-[#1d1d1f]'} text-[11px] inline-block">
            ${m.rol}
          </span>
        </div>
      </div>

      <div class="mt-6 pt-4 border-t border-[#0000000d] flex items-center justify-between text-xs">
        <span class="text-[#86868b] flex items-center gap-1.5">
          <span class="w-1.5 h-1.5 rounded-full bg-[#34c759]"></span>
          Rama: <strong class="font-mono text-[#1d1d1f] font-medium">${m.ramaActual}</strong>
        </span>
        <span class="text-[#86868b]">${fechaTexto}</span>
      </div>
    `;

    card.addEventListener("click", () => {
      window.location.hash = `#/miembro/${m.id}`;
    });

    container.appendChild(card);
  });
}

function renderizarTimelineGlobal() {
  const container = document.getElementById("timeline-global");
  if (!container) return;
  container.innerHTML = "";

  const recientes = estadoApp.commits.slice(0, 6);
  if (recientes.length === 0) {
    container.innerHTML = `<p class="p-6 text-xs text-[#86868b]">No hay commits recientes disponibles.</p>`;
    return;
  }

  recientes.forEach(c => {
    const row = document.createElement("div");
    row.className = "p-4 hover:bg-[#f5f5f7] transition flex items-center justify-between gap-4";
    
    const autorRaw = c.author ? c.author.login : (c.commit.author ? c.commit.author.name : "Autor");
    const miembro = encontrarIntegrante(autorRaw);
    const autorNombre = miembro ? miembro.nombre : autorRaw;
    const avatarUrl = miembro ? miembro.avatar : (c.author ? c.author.avatar_url : "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png");
    const fecha = new Date(c.commit.author.date);

    row.innerHTML = `
      <div class="flex items-center space-x-3 min-w-0">
        <img src="${avatarUrl}" alt="${autorNombre}" class="w-8 h-8 rounded-full border border-[#0000000d] object-cover bg-white shrink-0">
        <div class="min-w-0">
          <p class="text-xs font-semibold text-[#1d1d1f] truncate">${escapeHtml(c.commit.message.split("\n")[0])}</p>
          <p class="text-[11px] text-[#86868b] mt-0.5">
            Por <span class="font-medium text-[#1d1d1f]">${autorNombre}</span> • ${formatearFechaRelativa(fecha)}
          </p>
        </div>
      </div>
      <div class="shrink-0 flex items-center space-x-2">
        <span class="font-mono text-[11px] bg-[#f5f5f7] px-2 py-0.5 rounded text-[#86868b] border border-[#0000000d]">
          ${c.sha.substring(0, 7)}
        </span>
        <a href="${c.html_url}" target="_blank" rel="noopener noreferrer" class="text-xs text-[#0071e3] hover:underline font-medium">
          Ver
        </a>
      </div>
    `;

    container.appendChild(row);
  });
}

function mostrarVistaMiembro(idOMiembro) {
  const miembro = estadoApp.miembros.find(m => 
    m.id === idOMiembro || 
    m.login.toLowerCase() === idOMiembro.toLowerCase()
  );

  if (!miembro) {
    window.location.hash = "#/panel";
    return;
  }

  mostrarSeccion("vista-miembro");

  document.getElementById("perfil-avatar").src = miembro.avatar;
  document.getElementById("perfil-nombre").textContent = miembro.nombre;
  const badgeRol = document.getElementById("perfil-rol");
  badgeRol.textContent = miembro.rol;
  badgeRol.className = miembro.rol === "Profesor" 
    ? "apple-pill bg-[#0071e30f] text-[#0071e3] border border-[#0071e31f] font-semibold"
    : "apple-pill bg-[#f5f5f7] text-[#1d1d1f] border border-[#0000000d]";
  document.getElementById("perfil-github").textContent = `@${miembro.login}`;
  document.getElementById("perfil-commits").textContent = miembro.commits.length;
  document.getElementById("perfil-rama-pill").textContent = miembro.ramaActual;

  const contEnCurso = document.getElementById("perfil-en-curso");
  if (miembro.ultimoCommit) {
    contEnCurso.innerHTML = `
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-3">
        <div class="flex items-center space-x-2">
          <span class="text-xs font-medium text-[#86868b]">Rama activa:</span>
          <span class="font-mono text-xs font-semibold text-[#0071e3] bg-[#0071e30f] px-2.5 py-0.5 rounded-md border border-[#0071e31a]">
            ${miembro.ramaActual}
          </span>
        </div>
        <span class="text-xs text-[#86868b]">${formatearFechaRelativa(miembro.ultimoCommit.fecha)}</span>
      </div>
      <div class="bg-[#f5f5f7] border border-[#0000000d] rounded-xl p-4 mt-2">
        <p class="text-sm font-medium text-[#1d1d1f] leading-relaxed">
          ${escapeHtml(miembro.ultimoCommit.mensaje)}
        </p>
        <div class="mt-3 flex items-center justify-between text-xs text-[#86868b]">
          <span class="font-mono font-medium">${miembro.ultimoCommit.sha}</span>
          <a href="${miembro.ultimoCommit.url}" target="_blank" rel="noopener noreferrer" class="text-[#0071e3] hover:underline font-medium inline-flex items-center">
            Ver cambios en GitHub →
          </a>
        </div>
      </div>
    `;
  } else {
    contEnCurso.innerHTML = `
      <p class="text-xs text-[#86868b] italic">
        Aún no se registran commits consolidados en main por parte de este integrante. Su trabajo actual se encuentra en la rama <strong class="font-mono text-[#1d1d1f]">${miembro.ramaActual}</strong>.
      </p>
    `;
  }

  const contHistorial = document.getElementById("perfil-historial");
  if (miembro.commits.length > 0) {
    contHistorial.innerHTML = miembro.commits.map(c => `
      <div class="p-4 hover:bg-[#f5f5f7] transition flex items-center justify-between gap-4">
        <div class="min-w-0">
          <p class="text-xs font-medium text-[#1d1d1f] truncate">${escapeHtml(c.mensaje)}</p>
          <p class="text-[11px] text-[#86868b] mt-0.5">${formatearFechaRelativa(c.fecha)}</p>
        </div>
        <div class="shrink-0 flex items-center space-x-2">
          <span class="font-mono text-[11px] bg-[#f5f5f7] px-2 py-0.5 rounded text-[#86868b] border border-[#0000000d]">
            ${c.sha}
          </span>
          <a href="${c.url}" target="_blank" rel="noopener noreferrer" class="text-xs text-[#0071e3] hover:underline font-medium">
            Ver
          </a>
        </div>
      </div>
    `).join("");
  } else {
    contHistorial.innerHTML = `<div class="p-6 text-center text-xs text-[#86868b]">Sin historial de commits en la rama principal.</div>`;
  }
}

// ====================================================================
// SECCIÓN 3: EXPLORADOR DE ARCHIVOS Y AUTORÍA
// ====================================================================
function renderizarArchivos() {
  const container = document.getElementById("lista-archivos-contenedor");
  if (!container) return;
  container.innerHTML = "";

  const filtrados = ARCHIVOS_REPOSITORIO.filter(item => {
    if (estadoApp.filtroArchivos !== "todos" && item.categoria !== estadoApp.filtroArchivos) {
      return false;
    }
    if (estadoApp.busquedaArchivo) {
      const q = estadoApp.busquedaArchivo.toLowerCase();
      return item.path.toLowerCase().includes(q) || 
             item.descripcion.toLowerCase().includes(q) ||
             (EQUIPO_CANONICO.find(m => m.id === item.autorId)?.nombre.toLowerCase().includes(q));
    }
    return true;
  });

  if (filtrados.length === 0) {
    container.innerHTML = `<div class="p-8 text-center text-xs text-[#86868b]">No se encontraron archivos con ese criterio de búsqueda.</div>`;
    return;
  }

  filtrados.forEach(file => {
    const autor = EQUIPO_CANONICO.find(m => m.id === file.autorId) || EQUIPO_CANONICO[0];
    const row = document.createElement("div");
    row.className = "p-4 hover:bg-[#f5f5f7] transition flex flex-col sm:flex-row sm:items-center justify-between gap-3";

    const iconoColor = file.tipo === "SysML v2" ? "text-purple-600 bg-purple-50" : (file.tipo === "OpenSpec" ? "text-blue-600 bg-blue-50" : "text-emerald-600 bg-emerald-50");

    row.innerHTML = `
      <div class="flex items-start sm:items-center space-x-3.5 min-w-0">
        <div class="w-9 h-9 rounded-xl ${iconoColor} flex items-center justify-center font-mono text-xs font-bold shrink-0">
          ${file.tipo === "SysML v2" ? "v2" : (file.tipo === "OpenSpec" ? "Sp" : "Md")}
        </div>
        <div class="min-w-0">
          <div class="flex items-center gap-2">
            <span class="font-mono text-xs font-semibold text-[#1d1d1f] truncate">${file.path}</span>
            <span class="text-[10px] px-1.5 py-0.2 bg-[#0000000a] text-[#86868b] rounded font-medium">${file.tipo}</span>
          </div>
          <p class="text-xs text-[#86868b] mt-0.5 truncate">${file.descripcion}</p>
        </div>
      </div>

      <div class="flex items-center justify-between sm:justify-end space-x-4 shrink-0 pl-12 sm:pl-0">
        <div class="flex items-center space-x-2">
          <img src="${autor.avatar}" alt="${autor.nombre}" class="w-6 h-6 rounded-full border border-[#00000014] object-cover bg-white">
          <div class="text-left">
            <span class="text-xs font-medium text-[#1d1d1f] block leading-tight">${autor.nombre.split(" ")[0]}</span>
            <span class="text-[10px] text-[#86868b] block">Autor / Editor</span>
          </div>
        </div>

        <a href="https://github.com/${REPO_OWNER}/${REPO_NAME}/blob/main/${file.path}" target="_blank" rel="noopener noreferrer" class="text-xs text-[#0071e3] hover:underline font-medium inline-flex items-center gap-1">
          Ver código
          <svg class="w-3 h-3 text-[#86868b]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
          </svg>
        </a>
      </div>
    `;

    container.appendChild(row);
  });
}

// ====================================================================
// SECCIÓN 4: GESTOR DE TAREAS Y SINCRONIZACIÓN CON GITHUB ISSUES
// ====================================================================

function obtenerTareasPorDefecto() {
  return [
    {
      id: "t1",
      numero: null,
      texto: "Comprobar puertos de interfaz mecánica y bus CAN en 01_barcaza.sysml",
      miembroId: "pelayo",
      completada: true,
      fecha: "29 Oct",
      url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
      origen: "local"
    },
    {
      id: "t2",
      numero: null,
      texto: "Modelar balance energético y consumo de modo silencioso en 03_planta_motriz.sysml",
      miembroId: "jose",
      completada: false,
      fecha: "30 Oct",
      url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
      origen: "local"
    },
    {
      id: "t3",
      numero: null,
      texto: "Verificar especificación de suspensión neumática regulable en 02_tren_rodaje.sysml",
      miembroId: "eloy",
      completada: false,
      fecha: "30 Oct",
      url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
      origen: "local"
    },
    {
      id: "t4",
      numero: null,
      texto: "Revisar trazabilidad de requisitos del pliego CDTI en el README.md",
      miembroId: "cesar",
      completada: true,
      fecha: "29 Oct",
      url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
      origen: "local"
    },
    {
      id: "t5",
      numero: null,
      texto: "Comprobar cifrado COMSEC y enlaces tácticos en 05_comunicaciones.sysml",
      miembroId: "aimen",
      completada: false,
      fecha: "30 Oct",
      url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
      origen: "local"
    },
    {
      id: "t6",
      numero: null,
      texto: "Modelar módulo de acople del dron cenital en 07_uav_cenital.sysml",
      miembroId: "marcos",
      completada: false,
      fecha: "30 Oct",
      url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
      origen: "local"
    },
    {
      id: "t7",
      numero: null,
      texto: "Revisar algoritmo Detect & Avoid y navegación sin GNSS en 04_navegacion_control.sysml",
      miembroId: "juan",
      completada: false,
      fecha: "30 Oct",
      url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
      origen: "local"
    }
  ];
}

async function cargarTareasDesdeGitHub() {
  const token = obtenerGitHubToken();
  const headers = {
    "Accept": "application/vnd.github.v3+json"
  };
  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  const url = `https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues?state=all&per_page=100`;
  const cacheKey = "cache_gh_issues";
  const expKey = "exp_gh_issues";

  let issues = null;
  try {
    const res = await fetch(url, { headers });
    if (res.ok) {
      issues = await res.json();
      sessionStorage.setItem(cacheKey, JSON.stringify(issues));
      sessionStorage.setItem(expKey, (Date.now() + 2 * 60 * 1000).toString());
    } else if (res.status === 403) {
      console.warn("GitHub API rate limit alcanzado. Usando caché local.");
    }
  } catch (err) {
    console.warn("Aviso: Conexión con GitHub Issues no disponible:", err);
  }

  if (!issues) {
    const guardado = sessionStorage.getItem(cacheKey);
    if (guardado) {
      try { issues = JSON.parse(guardado); } catch(e){}
    }
  }

  return issues;
}

function mapearIssuesATareas(rawIssues) {
  if (!Array.isArray(rawIssues)) return [];

  // Filtrar Pull Requests (la API de GitHub los devuelve como issues con propiedad pull_request)
  const issuesPuros = rawIssues.filter(item => !item.pull_request);

  return issuesPuros.map(item => {
    let loginAsignado = null;
    if (item.assignee && item.assignee.login) {
      loginAsignado = item.assignee.login;
    } else if (Array.isArray(item.assignees) && item.assignees.length > 0) {
      loginAsignado = item.assignees[0].login;
    } else if (item.user && item.user.login) {
      loginAsignado = item.user.login;
    }

    const miembro = encontrarIntegrante(loginAsignado) || EQUIPO_CANONICO[0];

    return {
      id: "gh_" + item.number,
      numero: item.number,
      texto: item.title,
      miembroId: miembro.id,
      completada: item.state === "closed",
      fecha: formatearFechaRelativa(item.created_at),
      url: item.html_url,
      origen: "github"
    };
  });
}

async function cargarTareas() {
  actualizarIndicadorSync("cargando", "Consultando GitHub...");

  let tareasRemotas = [];
  const issuesRaw = await cargarTareasDesdeGitHub();

  if (issuesRaw) {
    tareasRemotas = mapearIssuesATareas(issuesRaw);
  }

  if (tareasRemotas.length > 0) {
    estadoApp.tareas = tareasRemotas;
    estadoApp.origenTareas = "github";
    localStorage.setItem("sysml_tareas_cache_github", JSON.stringify(tareasRemotas));
    actualizarIndicadorSync("conectado", `GitHub Issues (${tareasRemotas.length})`);
  } else {
    // Si no hay issues de tareas en el repositorio o hubo limitación de tasa:
    const cachePrevia = localStorage.getItem("sysml_tareas_cache_github");
    if (cachePrevia) {
      try {
        estadoApp.tareas = JSON.parse(cachePrevia);
        estadoApp.origenTareas = "cache";
        actualizarIndicadorSync("conectado", "Caché GitHub");
        renderizarTareas();
        return;
      } catch (e) {}
    }

    // Tareas base locales
    const guardadoLocal = localStorage.getItem("sysml_tareas_locales");
    if (guardadoLocal) {
      try {
        estadoApp.tareas = JSON.parse(guardadoLocal);
      } catch (e) {
        estadoApp.tareas = obtenerTareasPorDefecto();
      }
    } else {
      estadoApp.tareas = obtenerTareasPorDefecto();
    }
    estadoApp.origenTareas = "local";
    actualizarIndicadorSync("local", "Modo Local");
  }

  renderizarTareas();
}

function actualizarIndicadorSync(estado, texto) {
  estadoApp.syncStatus = estado;
  const dot = document.getElementById("sync-indicator-dot");
  const txt = document.getElementById("sync-status-texto");
  const bannerTxt = document.getElementById("banner-sync-texto");

  if (dot) {
    dot.className = "w-2 h-2 rounded-full";
    if (estado === "conectado") {
      dot.classList.add("bg-[#34c759]");
    } else if (estado === "cargando") {
      dot.classList.add("bg-[#ff9500]", "animate-pulse");
    } else if (estado === "local") {
      dot.classList.add("bg-[#0071e3]");
    } else {
      dot.classList.add("bg-[#86868b]");
    }
  }

  if (txt) {
    txt.textContent = texto || "GitHub Issues";
  }

  if (bannerTxt) {
    if (estado === "conectado") {
      bannerTxt.innerHTML = `<strong>Sincronización activa con GitHub Issues:</strong> Tareas compartidas en tiempo real. Cualquier compañero las ve al abrir la web en su ordenador.`;
    } else if (estado === "local") {
      bannerTxt.innerHTML = `<strong>Modo local activo:</strong> Aún no hay incidencias creadas en el repositorio. Las nuevas tareas se pueden publicar en GitHub con un solo clic.`;
    }
  }
}

function guardarTareasLocales() {
  localStorage.setItem("sysml_tareas_locales", JSON.stringify(estadoApp.tareas));
}

function renderizarTareas() {
  const container = document.getElementById("lista-tareas-contenedor");
  if (!container) return;
  container.innerHTML = "";

  const filtradas = estadoApp.tareas.filter(t => {
    if (estadoApp.filtroTareas === "pendientes") return !t.completada;
    if (estadoApp.filtroTareas === "completadas") return t.completada;
    return true;
  });

  // Conteo de tareas
  const total = estadoApp.tareas.length;
  const pendientes = estadoApp.tareas.filter(t => !t.completada).length;
  const completadas = estadoApp.tareas.filter(t => t.completada).length;

  document.getElementById("filtro-tarea-todas").textContent = `Todas (${total})`;
  document.getElementById("filtro-tarea-pendientes").textContent = `Pendientes (${pendientes})`;
  document.getElementById("filtro-tarea-completadas").textContent = `Completadas (${completadas})`;

  if (filtradas.length === 0) {
    container.innerHTML = `
      <div class="p-10 text-center text-xs text-[#86868b]">
        No hay tareas en esta vista. Asigna una nueva tarea arriba para que tu compañero la vea en su equipo.
      </div>
    `;
    return;
  }

  filtradas.forEach(tarea => {
    const miembro = EQUIPO_CANONICO.find(m => m.id === tarea.miembroId) || EQUIPO_CANONICO[0];
    const row = document.createElement("div");
    row.className = "p-4 hover:bg-[#f5f5f7] transition flex items-center justify-between gap-3 group";

    const badgeNumeroIssue = tarea.numero 
      ? `<a href="${tarea.url}" target="_blank" rel="noopener noreferrer" class="font-mono text-[11px] text-[#0071e3] hover:underline bg-[#0071e30f] px-2 py-0.5 rounded border border-[#0071e31a]">#${tarea.numero}</a>`
      : `<span class="text-[10px] text-[#86868b] bg-[#00000008] px-1.5 py-0.5 rounded">Local</span>`;

    row.innerHTML = `
      <div class="flex items-center space-x-3.5 min-w-0">
        <!-- Checkbox circular estilo Apple Reminders -->
        <button class="apple-checkbox ${tarea.completada ? 'checked' : ''}" data-id="${tarea.id}" title="${tarea.completada ? 'Marcar como pendiente' : 'Marcar como completada'}">
          <svg fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path>
          </svg>
        </button>

        <div class="min-w-0">
          <div class="flex items-center gap-2">
            ${badgeNumeroIssue}
            <p class="text-sm font-medium ${tarea.completada ? 'line-through text-[#86868b]' : 'text-[#1d1d1f]'} leading-tight truncate">
              ${escapeHtml(tarea.texto)}
            </p>
          </div>
          <div class="flex items-center gap-2 mt-1">
            <span class="text-[11px] text-[#86868b]">${tarea.fecha || "Reciente"}</span>
          </div>
        </div>
      </div>

      <div class="flex items-center space-x-3 shrink-0">
        <!-- Asignado a -->
        <div class="flex items-center space-x-1.5 bg-[#f5f5f7] px-2.5 py-1 rounded-full border border-[#0000000d]">
          <img src="${miembro.avatar}" alt="${miembro.nombre}" class="w-4 h-4 rounded-full object-cover">
          <span class="text-xs font-medium text-[#1d1d1f]">${miembro.nombre.split(" ")[0]}</span>
        </div>

        <!-- Enlace a GitHub si existe -->
        ${tarea.url ? `
          <a href="${tarea.url}" target="_blank" rel="noopener noreferrer" class="text-[#86868b] hover:text-[#0071e3] p-1 transition" title="Abrir en GitHub">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
            </svg>
          </a>
        ` : ''}

        <!-- Botón eliminar tarea -->
        <button class="btn-eliminar-tarea text-[#86868b] hover:text-red-500 p-1 opacity-40 group-hover:opacity-100 transition" data-id="${tarea.id}" title="Eliminar tarea">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
          </svg>
        </button>
      </div>
    `;

    // Conmutar estado de tarea
    row.querySelector(".apple-checkbox").addEventListener("click", () => {
      conmutarEstadoTarea(tarea);
    });

    // Eliminar tarea
    row.querySelector(".btn-eliminar-tarea").addEventListener("click", () => {
      eliminarTarea(tarea);
    });

    container.appendChild(row);
  });
}

async function conmutarEstadoTarea(tarea) {
  const nuevoEstado = !tarea.completada;
  tarea.completada = nuevoEstado;
  renderizarTareas();

  if (tarea.origen === "github" && tarea.numero) {
    const token = obtenerGitHubToken();
    if (token) {
      try {
        const stateStr = nuevoEstado ? "closed" : "open";
        const res = await fetch(`https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/${tarea.numero}`, {
          method: "PATCH",
          headers: {
            "Accept": "application/vnd.github.v3+json",
            "Authorization": `Bearer ${token}`,
            "Content-Type": "application/json"
          },
          body: JSON.stringify({ state: stateStr })
        });
        if (res.ok) {
          sessionStorage.removeItem("cache_gh_issues");
          mostrarToast(nuevoEstado ? `Issue #${tarea.numero} cerrado en GitHub` : `Issue #${tarea.numero} reabierto`, "exito");
          return;
        }
      } catch (e) {
        console.warn("Error conmutando estado en GitHub:", e);
      }
    }

    // Si no hay token configurado
    mostrarToast(`Estado cambiado localmente. Para guardarlo en GitHub, abre el <a href="${tarea.url}" target="_blank" class="underline font-bold text-white">Issue #${tarea.numero}</a>`, "info");
  } else {
    guardarTareasLocales();
  }
}

function eliminarTarea(tarea) {
  estadoApp.tareas = estadoApp.tareas.filter(t => t.id !== tarea.id);
  if (tarea.origen === "github") {
    mostrarToast(`Tarea removida de la vista local.`, "info");
  } else {
    guardarTareasLocales();
    mostrarToast("Tarea eliminada", "info");
  }
  renderizarTareas();
}

async function procesarCreacionTarea(texto, miembroId) {
  const miembro = EQUIPO_CANONICO.find(m => m.id === miembroId) || EQUIPO_CANONICO[0];
  const token = obtenerGitHubToken();

  if (token) {
    try {
      mostrarToast("Creando tarea en GitHub Issues...", "info");
      const res = await fetch(`https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues`, {
        method: "POST",
        headers: {
          "Accept": "application/vnd.github.v3+json",
          "Authorization": `Bearer ${token}`,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          title: texto,
          body: `Tarea asignada desde el Panel de Control Web a @${miembro.loginPrincipal}.\n\n- **Responsable:** ${miembro.nombre} (@${miembro.loginPrincipal})\n\n_Registrada colaborativamente mediante la interfaz del UGV SysML v2._`,
          assignees: [miembro.loginPrincipal],
          labels: ["tarea"]
        })
      });

      if (res.ok) {
        sessionStorage.removeItem("cache_gh_issues");
        mostrarToast("¡Tarea creada en GitHub y visible para todo el equipo!", "exito");
        await cargarTareas();
        return;
      } else {
        const errorData = await res.json().catch(() => ({}));
        mostrarToast(`Aviso GitHub: ${errorData.message || res.statusText}`, "error");
      }
    } catch (err) {
      mostrarToast("Error de conexión al crear en GitHub", "error");
    }
  }

  // Si no hay token configurado o falló: abrir opciones asistidas
  abrirModalOpcionesCreacion(texto, miembro);
}

function abrirModalOpcionesCreacion(texto, miembro) {
  estadoApp.tareaPendienteCrear = { texto, miembro };

  const modal = document.getElementById("modal-crear-opciones");
  const resumen = document.getElementById("modal-crear-resumen");
  if (resumen) {
    resumen.innerHTML = `Asignar: <strong class="text-[#1d1d1f]">"${escapeHtml(texto)}"</strong> a <strong class="text-[#0071e3]">${miembro.nombre}</strong>.`;
  }
  if (modal) modal.classList.remove("hidden");
}

function configurarModalesYEventos() {
  // Modal de Ajustes Sync
  const btnSyncAjustes = document.getElementById("btn-sync-ajustes");
  const modalSync = document.getElementById("modal-sync-ajustes");
  const btnCerrarModalSync = document.getElementById("btn-cerrar-modal-sync");
  const btnGuardarToken = document.getElementById("btn-guardar-token");
  const btnEliminarToken = document.getElementById("btn-eliminar-token");
  const btnForzarRecarga = document.getElementById("btn-forzar-recarga-modal");
  const btnBannerSync = document.getElementById("btn-banner-forzar-sync");

  if (btnSyncAjustes && modalSync) {
    btnSyncAjustes.addEventListener("click", () => {
      actualizarUIModalToken();
      modalSync.classList.remove("hidden");
    });
  }

  if (btnCerrarModalSync && modalSync) {
    btnCerrarModalSync.addEventListener("click", () => {
      modalSync.classList.add("hidden");
    });
  }

  if (btnGuardarToken) {
    btnGuardarToken.addEventListener("click", async () => {
      const input = document.getElementById("input-github-token");
      const valor = input.value.trim();
      if (valor && !valor.startsWith("•••")) {
        guardarGitHubToken(valor);
        mostrarToast("Token guardado de forma privada en tu navegador", "exito");
      }
      modalSync.classList.add("hidden");
      sessionStorage.clear();
      await cargarTareas();
    });
  }

  if (btnEliminarToken) {
    btnEliminarToken.addEventListener("click", () => {
      eliminarGitHubToken();
      modalSync.classList.add("hidden");
    });
  }

  if (btnForzarRecarga) {
    btnForzarRecarga.addEventListener("click", async () => {
      sessionStorage.removeItem("cache_gh_issues");
      await cargarTareas();
      mostrarToast("Tareas actualizadas desde GitHub", "info");
      modalSync.classList.add("hidden");
    });
  }

  if (btnBannerSync) {
    btnBannerSync.addEventListener("click", async () => {
      sessionStorage.removeItem("cache_gh_issues");
      await cargarTareas();
      mostrarToast("Tareas sincronizadas", "info");
    });
  }

  // Modal de Opciones al Crear
  const modalCrear = document.getElementById("modal-crear-opciones");
  const btnCerrarCrear = document.getElementById("btn-cerrar-modal-crear");
  const btnCrearGithub = document.getElementById("btn-modal-crear-github");
  const btnConfigurarToken = document.getElementById("btn-modal-configurar-token");
  const btnGuardarLocal = document.getElementById("btn-modal-guardar-local");

  if (btnCerrarCrear && modalCrear) {
    btnCerrarCrear.addEventListener("click", () => {
      modalCrear.classList.add("hidden");
    });
  }

  if (btnCrearGithub && modalCrear) {
    btnCrearGithub.addEventListener("click", () => {
      const p = estadoApp.tareaPendienteCrear;
      if (!p) return;

      const bodyTexto = `Tarea asignada desde el Panel de Control Web a @${p.miembro.loginPrincipal}.\n\n- **Responsable:** ${p.miembro.nombre}`;
      const urlIssue = `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues/new?title=${encodeURIComponent(p.texto)}&body=${encodeURIComponent(bodyTexto)}&labels=tarea&assignees=${encodeURIComponent(p.miembro.loginPrincipal)}`;
      
      window.open(urlIssue, "_blank");

      // Añadir de forma provisional en local
      const tareaProvisional = {
        id: "t_" + Date.now(),
        numero: null,
        texto: p.texto,
        miembroId: p.miembro.id,
        completada: false,
        fecha: "Pendiente en GitHub",
        url: `https://github.com/${REPO_OWNER}/${REPO_NAME}/issues`,
        origen: "local"
      };
      estadoApp.tareas.unshift(tareaProvisional);
      guardarTareasLocales();
      renderizarTareas();

      modalCrear.classList.add("hidden");
      mostrarToast("Ventana de GitHub abierta. Pulsa 'Submit new issue' para publicar para todos.", "info");
    });
  }

  if (btnConfigurarToken && modalCrear) {
    btnConfigurarToken.addEventListener("click", () => {
      modalCrear.classList.add("hidden");
      if (modalSync) {
        actualizarUIModalToken();
        modalSync.classList.remove("hidden");
      }
    });
  }

  if (btnGuardarLocal && modalCrear) {
    btnGuardarLocal.addEventListener("click", () => {
      const p = estadoApp.tareaPendienteCrear;
      if (!p) return;

      const tareaLocal = {
        id: "t_" + Date.now(),
        numero: null,
        texto: p.texto,
        miembroId: p.miembro.id,
        completada: false,
        fecha: "Hoy",
        url: null,
        origen: "local"
      };
      estadoApp.tareas.unshift(tareaLocal);
      guardarTareasLocales();
      renderizarTareas();

      modalCrear.classList.add("hidden");
      mostrarToast("Tarea guardada solo en este ordenador", "info");
    });
  }
}

function configurarEventosArchivosYTareas() {
  // Filtros de categoría de archivos
  const botonesArchivos = [
    { id: "filtro-arch-todos", valor: "todos" },
    { id: "filtro-arch-modelos", valor: "Modelos/" },
    { id: "filtro-arch-openspec", valor: "openspec/" },
    { id: "filtro-arch-docs", valor: "docs/" }
  ];

  botonesArchivos.forEach(item => {
    const btn = document.getElementById(item.id);
    if (!btn) return;
    btn.addEventListener("click", () => {
      botonesArchivos.forEach(b => {
        const el = document.getElementById(b.id);
        el.className = "px-3 py-1 rounded-lg text-[#86868b] hover:text-[#1d1d1f] transition";
      });
      btn.className = "px-3 py-1 rounded-lg bg-white shadow-sm font-semibold text-[#1d1d1f] transition";
      estadoApp.filtroArchivos = item.valor;
      renderizarArchivos();
    });
  });

  // Buscador de archivos
  const inputBusqueda = document.getElementById("busqueda-archivos");
  if (inputBusqueda) {
    inputBusqueda.addEventListener("input", (e) => {
      estadoApp.busquedaArchivo = e.target.value.trim();
      renderizarArchivos();
    });
  }

  // Filtros de estado de tareas
  const botonesTareas = [
    { id: "filtro-tarea-todas", valor: "todas" },
    { id: "filtro-tarea-pendientes", valor: "pendientes" },
    { id: "filtro-tarea-completadas", valor: "completadas" }
  ];

  botonesTareas.forEach(item => {
    const btn = document.getElementById(item.id);
    if (!btn) return;
    btn.addEventListener("click", () => {
      botonesTareas.forEach(b => {
        const el = document.getElementById(b.id);
        el.className = "px-3 py-1 rounded-lg text-[#86868b] hover:text-[#1d1d1f] transition";
      });
      btn.className = "px-3 py-1 rounded-lg bg-white shadow-sm font-semibold text-[#1d1d1f] transition";
      estadoApp.filtroTareas = item.valor;
      renderizarTareas();
    });
  });

  // Formulario de nueva tarea
  const formTarea = document.getElementById("form-nueva-tarea");
  if (formTarea) {
    formTarea.addEventListener("submit", async (e) => {
      e.preventDefault();
      const inputTexto = document.getElementById("input-tarea-texto");
      const selectMiembro = document.getElementById("select-tarea-miembro");

      const texto = inputTexto.value.trim();
      if (!texto) return;

      await procesarCreacionTarea(texto, selectMiembro.value);
      inputTexto.value = "";
    });
  }
}

// Fallback con datos locales estructurados si no hay conexión
function usarDatosLocales() {
  estadoApp.ramas = [
    { name: "main" }, { name: "Pelayo" }, { name: "Jose" }, { name: "Eloy" }, 
    { name: "anadir-requisito-direccion" }, { name: "requisitos-bateria" }, { name: "iacolab_jc" }
  ];
  estadoApp.commits = [
    { sha: "8296bc12345", author: { login: "juanuniovi" }, commit: { message: "Pruebas para mejorar las vistas", author: { date: "2026-10-25T19:30:00Z" } }, html_url: "https://github.com/juanuniovi/UGV-sysml-/commit/8296bc1" },
    { sha: "2da2a2a1234", author: { login: "juanuniovi" }, commit: { message: "Merge pull request #6 from juanuniovi/requisitos-bateria", author: { date: "2026-10-25T18:00:00Z" } }, html_url: "https://github.com/juanuniovi/UGV-sysml-/commit/2da2a2a" },
    { sha: "54920471234", author: { login: "josescobedov" }, commit: { message: "Nuevos requisitos para la batería", author: { date: "2026-10-25T17:45:00Z" } }, html_url: "https://github.com/juanuniovi/UGV-sysml-/commit/5492047" },
    { sha: "4814ce31234", author: { login: "juanuniovi" }, commit: { message: "Direccion requisitos", author: { date: "2026-10-25T16:20:00Z" } }, html_url: "https://github.com/juanuniovi/UGV-sysml-/commit/4814ce3" },
    { sha: "f4ae23d1234", author: { login: "EloySuarezCostales" }, commit: { message: "chore(openspec): archivar cambio estados-bateria y sincronizar specs", author: { date: "2026-10-24T14:10:00Z" } }, html_url: "https://github.com/juanuniovi/UGV-sysml-/commit/f4ae23d" },
    { sha: "509e1811234", author: { login: "cesarbobes" }, commit: { message: "docs: añadir guía de flujo Git+OpenSpec en README", author: { date: "2026-10-23T11:00:00Z" } }, html_url: "https://github.com/juanuniovi/UGV-sysml-/commit/509e181" }
  ];
  estadoApp.pullRequests = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }, { id: 6 }];

  estadoApp.miembros = procesarIntegrantes([
    { login: "juanuniovi", contributions: 12, avatar_url: "https://github.com/juanuniovi.png" },
    { login: "josescobedov", contributions: 10, avatar_url: "https://github.com/josescobedov.png" },
    { login: "EloySuarezCostales", contributions: 4, avatar_url: "https://github.com/EloySuarezCostales.png" },
    { login: "cesarbobes", contributions: 2, avatar_url: "https://github.com/cesarbobes.png" },
    { login: "juanuniovi", contributions: 1, avatar_url: "https://github.com/juanuniovi.png" }
  ], estadoApp.commits, estadoApp.ramas);

  estadoApp.tareas = obtenerTareasPorDefecto();
  estadoApp.origenTareas = "local";
  actualizarIndicadorSync("local", "Modo Local");

  renderizarMetricas();
  renderizarGridMiembros();
  renderizarTimelineGlobal();
  renderizarArchivos();
  renderizarTareas();
  procesarRutaActual();
}

function mostrarLoader(activo) {
  const loader = document.getElementById("loader");
  if (loader) loader.classList.toggle("hidden", !activo);
}

function formatearFechaRelativa(fecha) {
  const diffSegundos = Math.floor((Date.now() - new Date(fecha).getTime()) / 1000);
  if (isNaN(diffSegundos) || diffSegundos < 60) return "Hace un momento";
  if (diffSegundos < 3600) return `Hace ${Math.floor(diffSegundos / 60)} min`;
  if (diffSegundos < 86400) return `Hace ${Math.floor(diffSegundos / 3600)} h`;
  const dias = Math.floor(diffSegundos / 86400);
  return dias === 1 ? "Ayer" : `Hace ${dias} días`;
}

function escapeHtml(texto) {
  if (!texto) return "";
  return texto.replace(/[&<>"']/g, function(m) {
    return {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#039;'
    }[m];
  });
}

function mostrarToast(mensaje, tipo = "info") {
  const container = document.getElementById("apple-toast-container");
  if (!container) return;

  const toast = document.createElement("div");
  toast.className = "apple-toast";

  let icono = "";
  if (tipo === "exito") {
    icono = `<svg class="w-4 h-4 text-[#34c759] shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>`;
  } else if (tipo === "error") {
    icono = `<svg class="w-4 h-4 text-[#ff3b30] shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>`;
  } else {
    icono = `<svg class="w-4 h-4 text-[#0071e3] shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>`;
  }

  toast.innerHTML = `
    ${icono}
    <div class="leading-tight">${mensaje}</div>
  `;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = "0";
    toast.style.transform = "translateY(10px)";
    toast.style.transition = "all 0.3s ease";
    setTimeout(() => toast.remove(), 300);
  }, 4500);
}
