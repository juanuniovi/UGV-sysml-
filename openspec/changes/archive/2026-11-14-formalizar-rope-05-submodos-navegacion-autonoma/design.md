# Design: Formalización y Tipado de Submodos de Autonomía de ROPE-05

## Context

El pliego oficial de prescripciones técnicas (`docs/ROBOT_TERRESTRE_Anexo_I.pdf`, sección 3.4, págs. 113-114) establece:
> *"ROPE-05 El modo AUTÓNOMO o de navegación autónoma, deberá estar orientado a que el UGV requiera el menor grado de interacción posible con el humano para su correcto funcionamiento. Este modo de navegación autónoma deberá incorporar, al menos, las siguientes funcionalidades (sub modos), que podrán ser habilitados y deshabilitados en cualquier momento antes y durante el transcurso de la misión:*
> *a. Navegación por puntos de paso (...)*
> *b. Navegación mediante punto de destino (...)*
> *c. Regreso autónomo a un punto de paso anterior, incluido el del origen del recorrido (o vuelta a “casa”).*
> *d. Seguimiento automático tanto de personas como de otros vehículos.*
> *e. Shuttle o lanzadera entre dos puntos específicos repitiendo el recorrido en un sentido y el inverso."*

En la arquitectura actual de `Modelos/04_1_control.sysml`:
- El modo macro `ModoOperacionConduccion` incluye `TELEOPERADO` y `NAVEGACION`.
- No están tipificados los submodos que estructuran la navegación autónoma, impidiendo una delimitación rigurosa entre las responsabilidades del sistema y la implementación concreta en ROS 2.

## Goals / Non-Goals

**Goals:**
- Tipar en SysML v2 los cinco submodos funcionales mediante `enum def SubmodoNavegacionAutonoma`.
- Tipar el comando de conmutación de submodos `item def ComandoSubmodoAutonomia` para canalización por el bus de datos de la plataforma (`dataBus`).
- Formalizar `requirement def ReqSubmodosNavegacionAutonoma` (`ROPE-05`) en `Modelos/04_1_control.sysml` con `subject ctrl : SistemaControl;`.
- Declarar la relación `satisfy ReqSubmodosNavegacionAutonoma by computadorAutonomia;` en `SistemaControl`.
- Declarar la relación `satisfy requirement : ReqSubmodosNavegacionAutonoma by control;` en `PlataformaUGV` ([Modelos/09_sistema_ugv.sysml](file:///C:/Users/mario/Desktop/ugv/UGV-SYSML-/Modelos/09_sistema_ugv.sysml)).
- Garantizar 0 errores y 0 avisos en Spec42.

**Non-Goals:**
- No se redefine la lógica algorítmica interna de los planificadores de ROS 2 ni la interfaz gráfica del puesto de mando (PMP).
- No se alteran requisitos vigentes (`ROPE-01`, `ROPE-06`, `RGEN-09`, `RGEN-17`).

## Decisions

### 1. Definición del Enumerado de Submodos en `SubsistemaControl`
- **Decisión**:
  ```sysml
  enum def SubmodoNavegacionAutonoma {
      doc /* Submodos funcionales de navegacion autonoma comandables antes y durante la mision (ROPE-05) */
      enum PUNTOS_PASO;           // Navegacion por waypoints definidos antes o durante el recorrido
      enum PUNTO_DESTINO;         // Navegacion autonoma eficiente a punto de destino final
      enum REGRESO_ORIGEN;        // Retorno autonomo a punto de paso previo o vuelta a casa
      enum SEGUIMIENTO_FOLLOW_ME; // Seguimiento automatico de personas o de otros vehiculos
      enum SHUTTLE_LANZADERA;     // Lanzadera ciclica de ida y vuelta entre dos puntos
  }
  ```
- **Justificación**: Mapea unívocamente los incisos a, b, c, d y e de la cláusula 3.4 del pliego oficial, permitiendo su uso por los ingenieros de software para orquestar la máquina de estados de autonomía.

### 2. Comando de Submodo de Autonomía
- **Decisión**:
  ```sysml
  item def ComandoSubmodoAutonomia {
      doc /* Orden de activacion y conmutacion de submodo de navegacion autonoma recibido desde las Estaciones de Control (ROPE-05) */
      attribute submodoObjetivo : SubmodoNavegacionAutonoma;
      attribute habilitado : Boolean;
  }
  ```
- **Justificación**: Representa la estructura de datos que viaja desde el Puesto de Mando (PMP) hacia `ComputadorAutonomia` a través de `dataBus`.

### 3. Trazabilidad y Satisfacción
- **Decisión**:
  - En `SistemaControl`: `satisfy ReqSubmodosNavegacionAutonoma by computadorAutonomia;`.
  - En `PlataformaUGV`: `satisfy requirement : ReqSubmodosNavegacionAutonoma by control;`.
- **Justificación**: Sigue el estándar arquitectural del repositorio para requisitos asignados a subsistemas.

## Risks / Trade-offs

- **[Riesgo]**: Ambigüedad en la coexistencia entre el modo macro (`ModoOperacionConduccion::NAVEGACION`) y los submodos.
  - *Mitigación*: Se documenta explícitamente que los submodos operan bajo el estado de autonomía (`NAVEGACION` / `AUTÓNOMO`), inhibiéndose cuando `gobiernoControl` conmute a `TELEOPERADO` conforme a `ROPE-01`.
