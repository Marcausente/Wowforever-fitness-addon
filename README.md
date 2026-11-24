# Fitness Exercise Forever

Addon para **World of Warcraft Forever** (`Interface: 16001`) que se abre automáticamente cuando te subes a un grifo, muestra una barra de tiempo de vuelo clara con el tiempo restante y te guía con ejercicios precargados (sin equipo o con mancuernas) durante el viaje.

## Características

- **Apertura automática al volar**: al tomar un grifo se abre directamente la ventana con el temporizador de vuelo en vivo (1.912 rutas integradas de WoW Forever, soporte para *Viajero frecuente* y aprendizaje de rutas nuevas).
- **Interfaz directa y sencilla**: elige **Sin equipo** o **Sin equipo + Mancuernas**, selecciona la **Dificultad** (*Principiante*, *Intermedio* o *Avanzado*) y al instante aparecen los ejercicios.
- **78 ejercicios precargados**: 54 sin equipamiento y 24 con mancuernas, con repeticiones o cuenta atrás integrada, botón de **Completado** y **Saltar** para ir cambiando de ejercicio durante todo el vuelo.
- **Bilingüe (Español / English)**: detección automática del cliente y botón rápido `ES | EN` en la esquina superior.

## Instalación

1. Descarga o clona este repositorio dentro de tu carpeta de AddOns como `FitnessExcerciseForever`:
   ```
   World of Warcraft\_forever_\Interface\AddOns\FitnessExcerciseForever
   ```
2. Reinicia el juego o ejecuta `/reload`.

## Comandos

- `/fef` o `/fitness` — Abre o cierra la ventana.
- `/fef test [segundos]` — Simula un vuelo de prueba (90s por defecto).
- `/fef lang [es|en|auto]` — Cambia entre Español, English o automático.
- `/fef reset` — Centra la ventana en pantalla.
