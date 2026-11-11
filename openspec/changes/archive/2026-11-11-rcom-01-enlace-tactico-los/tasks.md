# Tasks

## 1. Modelado en `Modelos/05_comunicaciones.sysml`

- [x] 1.1 Declarar los ítems de flujo `ComandoTelemandoLOS` y `TelemetriaVideoLOS`.
- [x] 1.2 Definir la parte `RadioEnlaceTacticoLOS` con sus atributos de latencia (`<= 100 ms`), alcance (`1.5 km`), frecuencia (`2.4 GHz`) y puertos internos.
- [x] 1.3 Formalizar el requisito `requirement def ReqEnlaceTacticoLOS` (`RCOM-01`).
- [x] 1.4 Instanciar `radioEnlaceTacticoLOS` dentro de `SistemaComunicacionesEmbarcado` y establecer la relación `satisfy requirement : ReqEnlaceTacticoLOS by radioEnlaceTacticoLOS;`.
- [x] 1.5 Preservar todos los puertos de contorno del subsistema (`chassisMount`, `powerInput`, `dataBus`, `salidaModoDeteccion`, `salidaInhabilitacionFrenado`, `entradaVideoTeleoperacion`, `entradaEstadoRodaje`, `rfPortLOS`, `rfPortBLOS`).

## 2. Modelado de Vistas en `Modelos/11_vistas.sysml`

- [x] 2.1 Añadir la vista `vistaConexionesComunicaciones : InterconnectionView` exponiendo `SubsistemaComunicaciones::SistemaComunicacionesEmbarcado`.

## 3. Verificación con Spec42 y Validación de Cambios

- [x] 3.1 Ejecutar `spec42 check Modelos` y verificar `0 error(s), 0 warning(s)` en todo el repositorio.
- [x] 3.2 Verificar mediante `git diff` que los cambios se circunscriben estrictamente a `05_comunicaciones.sysml` y `11_vistas.sysml` en la rama `Pelayo`.
