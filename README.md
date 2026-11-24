# Fitness Exercise Forever

Addon para **World of Warcraft Forever** (`Interface: 16001`) que calcula el tiempo de vuelo al subir a un grifo, muestra una barra de progreso en tiempo real y te propone ejercicios variados (sin equipo o con mancuernas) para hacer durante el trayecto.

## Características

- **Barra de tiempo en vivo**: 1.912 rutas integradas de WoW Forever (Alianza y Horda, incluidos puntos propios de Forever), soporte para la ventaja *Viajero frecuente* y aprendizaje automático de rutas nuevas.
- **HUD interactivo en vuelo**: muestra el ejercicio actual con repeticiones o duración, cuenta atrás para ejercicios por tiempo, botón de **Completado**, **Saltar**, **Cambiar** y toggle rápido de **Mancuernas: SÍ/NO**.
- **78 ejercicios integrados**: 54 ejercicios sin equipamiento y 24 ejercicios con mancuernas (ningún otro material requerido), repartidos entre tren superior, tren inferior, core, cardio y movilidad.
- **Bilingüe (Español / English)**: detección automática según el idioma del cliente y cambio manual en cualquier momento.
- **Ventana completa (`/fef`)**: resumen de estadísticas, librería de ejercicios con filtros y creador de ejercicios personalizados, historial/rutas aprendidas y ajustes.

## Instalación

1. Descarga o clona este repositorio dentro de tu carpeta de AddOns como `FitnessExcerciseForever`:
   ```
   World of Warcraft\_forever_\Interface\AddOns\FitnessExcerciseForever
   ```
2. Reinicia el juego o ejecuta `/reload`.

## Comandos

- `/fef` o `/fitness` — Abre o cierra la ventana principal.
- `/fef test [segundos]` — Simula un vuelo de prueba (90s por defecto) para probar y colocar la barra.
- `/fef dumbbells` — Activa o desactiva los ejercicios con mancuernas.
- `/fef lang [es|en|auto]` — Cambia entre Español, English o automático.
- `/fef reset` — Restablece la posición del HUD al centro.
