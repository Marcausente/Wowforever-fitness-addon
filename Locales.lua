local _, ns = ...

local Locales = {}
ns.Locales = Locales

local strings = {
    en = {
        ADDON_NAME = "Fitness Exercise Forever",
        ADDON_SHORT = "FEF",
        TAGLINE = "Turn every gryphon flight into quick movement.",
        LOADED_MSG = "|cff00d4aaFitness Exercise Forever|r loaded! Type |cffffd780/fef|r to open or |cffffd780/fef test|r to preview the flight HUD.",

        -- Languages
        LANG_NAME = "English",
        LANG_AUTO = "Auto (Client)",
        LANG_ES = "Español",
        LANG_EN = "English",

        -- Flight HUD
        HUD_TITLE = "FLIGHT WORKOUT",
        HUD_PRACTICE = "PRACTICE",
        HUD_ESTIMATED = "EST.",
        HUD_EXACT = "EXACT",
        HUD_LANDED = "Landed!",
        HUD_NEXT_STOP = "Next stop: %s (%s)",
        HUD_REMAINING = "Flight: %s",
        HUD_ELAPSED_UNKNOWN = "Learning route: %s",
        HUD_EXERCISES_DONE = "Completed: %d",
        HUD_NEXT_UP = "Next: %s",
        HUD_ALL_DONE_TITLE = "Flight Routine Complete!",
        HUD_ALL_DONE_DESC = "Great job! Relax until landing or click Reroll for another exercise.",
        HUD_TOO_SHORT_TITLE = "Final Approach",
        HUD_TOO_SHORT_DESC = "Less than 12 seconds left — breathe deep and prepare to land!",
        HUD_TIMER_RUNNING = "Exercise timer: %s",
        HUD_TIMER_DONE = "Time's up! Click Complete.",
        HUD_NO_MATCH_TITLE = "No Matching Exercises",
        HUD_NO_MATCH_DESC = "Enable more exercises or adjust your filters in /fef.",

        -- Buttons
        BTN_COMPLETE = "Complete",
        BTN_SKIP = "Skip",
        BTN_REROLL = "New",
        BTN_CLOSE = "Close",
        BTN_DUMBBELLS_ON = "Dumbbells: ON",
        BTN_DUMBBELLS_OFF = "Dumbbells: OFF",
        BTN_START_TIMER = "Start",
        BTN_TEST_FLIGHT = "Test Flight (90s)",
        BTN_TEST_LONG = "Long Test (4m)",
        BTN_RESET_POS = "Reset HUD Position",
        BTN_ADD_CUSTOM = "Add Exercise",
        BTN_DELETE = "Delete",
        BTN_ENABLE_ALL = "Enable All",

        -- Equipment
        EQ_NONE = "Bodyweight",
        EQ_DUMBBELLS = "Dumbbells",
        EQ_MODE_NONE = "No Equipment (Bodyweight only)",
        EQ_MODE_MIXED = "Bodyweight + Dumbbells",
        EQ_MODE_PREFER_DB = "Prioritize Dumbbells",

        -- Categories
        CAT_ALL = "All",
        CAT_UPPER = "Upper Body",
        CAT_LOWER = "Lower Body",
        CAT_CORE = "Core",
        CAT_CARDIO = "Cardio",
        CAT_MOBILITY = "Mobility",

        -- Difficulties
        DIFF_ALL = "All Levels",
        DIFF_BEGINNER = "Beginner",
        DIFF_INTERMEDIATE = "Intermediate",
        DIFF_ADVANCED = "Advanced",

        -- Positions
        POS_STANDING = "Standing",
        POS_SEATED = "Seated",
        POS_FLOOR = "Floor",

        -- Units
        UNIT_REPS = "%d reps",
        UNIT_REPS_EACH_SIDE = "%d / side",
        UNIT_REPS_EACH_DIR = "%d / dir",
        UNIT_SECONDS = "%d sec",
        UNIT_SECONDS_EACH_SIDE = "%d sec / side",

        -- Tooltip
        TOOLTIP_FLIGHT_TIME = "Est. Flight: %s",
        TOOLTIP_FLIGHT_APPROX = "Est. Flight: ~%s (new route)",
        TOOLTIP_FREQUENT_FLIER = " (Frequent Flier)",
        TOOLTIP_WORKOUT_FIT = "Workout: ~%d exercises fit",
        TOOLTIP_MINIMAP_1 = "Click to open Fitness Exercise Forever",
        TOOLTIP_MINIMAP_2 = "Right-click to launch a 90s test flight",
        TOOLTIP_MINIMAP_3 = "Drag around the minimap to move",

        -- Tabs
        TAB_OVERVIEW = "Overview",
        TAB_EXERCISES = "Exercises",
        TAB_HISTORY = "History & Routes",
        TAB_SETTINGS = "Settings",

        -- Overview
        STAT_FLIGHTS = "Flights Tracked",
        STAT_COMPLETED = "Exercises Completed",
        STAT_SKIPPED = "Exercises Skipped",
        STAT_ACTIVE_TIME = "Estimated Active Time",
        STAT_DUMBBELL_DONE = "With Dumbbells",
        STAT_BODYWEIGHT_DONE = "Bodyweight",
        QUICK_CONTROLS = "Quick Setup",
        PREVIEW_SECTION = "Test & Preview",
        LAST_FLIGHT = "Last Flight",
        NO_FLIGHTS_YET = "No flights recorded yet. Hop on a gryphon or click Test Flight!",

        -- Exercises tab
        FILTER_EQUIPMENT = "Equipment:",
        FILTER_CATEGORY = "Category:",
        SEARCH_PLACEHOLDER = "Search exercises...",
        CUSTOM_EX_TITLE = "Create Custom Exercise",
        CUSTOM_NAME = "Name:",
        CUSTOM_REPS = "Amount:",
        CUSTOM_UNIT = "Type:",
        CUSTOM_UNIT_REPS = "Reps",
        CUSTOM_UNIT_SECS = "Seconds",
        CUSTOM_EQ = "Requires Dumbbells",
        CUSTOM_CAT = "Category:",
        CUSTOM_DESC = "Instructions (optional):",
        CUSTOM_ADDED = "Custom exercise added!",
        CUSTOM_EMPTY_NAME = "Please enter an exercise name.",

        -- History tab
        HISTORY_RECENT = "Recent Activity",
        HISTORY_ROUTES = "Learned Routes (%d)",
        HISTORY_NONE = "No completed or skipped exercises yet.",
        ROUTES_NONE = "No custom routes learned yet. Built-in Forever data already covers 1,900+ routes!",
        STATUS_COMPLETED = "Completed",
        STATUS_SKIPPED = "Skipped",

        -- Settings tab
        SET_LANGUAGE = "Language / Idioma",
        SET_EQUIPMENT = "Available Equipment",
        SET_DIFFICULTY = "Maximum Difficulty",
        SET_ALLOW_FLOOR = "Include floor exercises (planks, bridges, etc.)",
        SET_AUTO_ADVANCE_TIMED = "Auto-complete timed exercises when their timer finishes",
        SET_FILL_BAR = "Fill progress bar (unchecked = drain)",
        SET_SOUNDS = "Play sound cues on takeoff and completion",
        SET_TOOLTIP = "Show flight time & workout estimate on Flight Map tooltips",
        SET_AUTOHIDE = "Auto-hide HUD 4 seconds after landing if idle",
        SET_MINIMAP = "Show minimap button",
        SET_SCALE = "HUD Scale: %.0f%%",
        SET_RESET_STATS = "Reset Stats",
        SET_RESET_CONFIRM = "Stats cleared.",

        -- Chat messages
        MSG_FLIGHT_START = "Flight started: %s (%s). Let's move!",
        MSG_FLIGHT_LEARNED = "Learned route %s: %s (saved for future flights).",
        MSG_HUD_RESET = "HUD position reset to center.",
        MSG_HELP_HEADER = "Fitness Exercise Forever Commands:",
        MSG_HELP_1 = "/fef - Open/close main window",
        MSG_HELP_2 = "/fef test [seconds] - Start a simulated flight HUD (default 90s)",
        MSG_HELP_3 = "/fef dumbbells - Toggle Dumbbells ON/OFF",
        MSG_HELP_4 = "/fef lang [es|en|auto] - Switch language",
        MSG_HELP_5 = "/fef reset - Reset HUD position",
    },

    es = {
        ADDON_NAME = "Fitness Exercise Forever",
        ADDON_SHORT = "FEF",
        TAGLINE = "Aprovecha cada viaje en grifo para moverte un poco.",
        LOADED_MSG = "|cff00d4aaFitness Exercise Forever|r cargado. Escribe |cffffd780/fef|r para abrir o |cffffd780/fef test|r para probar la barra.",

        -- Languages
        LANG_NAME = "Español",
        LANG_AUTO = "Auto (Cliente)",
        LANG_ES = "Español",
        LANG_EN = "English",

        -- Flight HUD
        HUD_TITLE = "ENTRENO EN VUELO",
        HUD_PRACTICE = "PRÁCTICA",
        HUD_ESTIMATED = "EST.",
        HUD_EXACT = "EXACTO",
        HUD_LANDED = "¡Has aterrizado!",
        HUD_NEXT_STOP = "Siguiente parada: %s (%s)",
        HUD_REMAINING = "Vuelo: %s",
        HUD_ELAPSED_UNKNOWN = "Aprendiendo ruta: %s",
        HUD_EXERCISES_DONE = "Hechos: %d",
        HUD_NEXT_UP = "Siguiente: %s",
        HUD_ALL_DONE_TITLE = "¡Rutina de vuelo completada!",
        HUD_ALL_DONE_DESC = "¡Buen trabajo! Descansa hasta aterrizar o pulsa Cambiar para otro ejercicio.",
        HUD_TOO_SHORT_TITLE = "Aterrizaje inminente",
        HUD_TOO_SHORT_DESC = "Quedan menos de 12 segundos: respira hondo y prepárate para aterrizar.",
        HUD_TIMER_RUNNING = "Tiempo del ejercicio: %s",
        HUD_TIMER_DONE = "¡Tiempo! Pulsa Completado.",
        HUD_NO_MATCH_TITLE = "Sin ejercicios disponibles",
        HUD_NO_MATCH_DESC = "Activa más ejercicios o ajusta los filtros en /fef.",

        -- Buttons
        BTN_COMPLETE = "Completado",
        BTN_SKIP = "Saltar",
        BTN_REROLL = "Cambiar",
        BTN_CLOSE = "Cerrar",
        BTN_DUMBBELLS_ON = "Mancuernas: SÍ",
        BTN_DUMBBELLS_OFF = "Mancuernas: NO",
        BTN_START_TIMER = "Iniciar",
        BTN_TEST_FLIGHT = "Probar vuelo (90s)",
        BTN_TEST_LONG = "Prueba larga (4m)",
        BTN_RESET_POS = "Centrar barra",
        BTN_ADD_CUSTOM = "Añadir ejercicio",
        BTN_DELETE = "Borrar",
        BTN_ENABLE_ALL = "Activar todos",

        -- Equipment
        EQ_NONE = "Sin equipo",
        EQ_DUMBBELLS = "Mancuernas",
        EQ_MODE_NONE = "Sin equipo (solo peso corporal)",
        EQ_MODE_MIXED = "Sin equipo + Mancuernas",
        EQ_MODE_PREFER_DB = "Priorizar Mancuernas",

        -- Categories
        CAT_ALL = "Todos",
        CAT_UPPER = "Tren Superior",
        CAT_LOWER = "Tren Inferior",
        CAT_CORE = "Abdomen / Core",
        CAT_CARDIO = "Cardio",
        CAT_MOBILITY = "Movilidad",

        -- Difficulties
        DIFF_ALL = "Todos los niveles",
        DIFF_BEGINNER = "Principiante",
        DIFF_INTERMEDIATE = "Intermedio",
        DIFF_ADVANCED = "Avanzado",

        -- Positions
        POS_STANDING = "De pie",
        POS_SEATED = "Sentado",
        POS_FLOOR = "Suelo",

        -- Units
        UNIT_REPS = "%d repeticiones",
        UNIT_REPS_EACH_SIDE = "%d por lado",
        UNIT_REPS_EACH_DIR = "%d por dirección",
        UNIT_SECONDS = "%d seg",
        UNIT_SECONDS_EACH_SIDE = "%d seg / lado",

        -- Tooltip
        TOOLTIP_FLIGHT_TIME = "Vuelo est.: %s",
        TOOLTIP_FLIGHT_APPROX = "Vuelo est.: ~%s (ruta nueva)",
        TOOLTIP_FREQUENT_FLIER = " (Viajero frecuente)",
        TOOLTIP_WORKOUT_FIT = "Entreno: caben ~%d ejercicios",
        TOOLTIP_MINIMAP_1 = "Clic izquierdo para abrir Fitness Exercise Forever",
        TOOLTIP_MINIMAP_2 = "Clic derecho para probar la barra (90s)",
        TOOLTIP_MINIMAP_3 = "Arrastra alrededor del minimapa para mover",

        -- Tabs
        TAB_OVERVIEW = "Resumen",
        TAB_EXERCISES = "Ejercicios",
        TAB_HISTORY = "Historial y Rutas",
        TAB_SETTINGS = "Ajustes",

        -- Overview
        STAT_FLIGHTS = "Vuelos registrados",
        STAT_COMPLETED = "Ejercicios completados",
        STAT_SKIPPED = "Ejercicios saltados",
        STAT_ACTIVE_TIME = "Tiempo activo estimado",
        STAT_DUMBBELL_DONE = "Con mancuernas",
        STAT_BODYWEIGHT_DONE = "Sin equipo",
        QUICK_CONTROLS = "Ajustes rápidos",
        PREVIEW_SECTION = "Probar y previsualizar",
        LAST_FLIGHT = "Último vuelo",
        NO_FLIGHTS_YET = "Aún no hay vuelos registrados. ¡Súbete a un grifo o pulsa Probar vuelo!",

        -- Exercises tab
        FILTER_EQUIPMENT = "Equipo:",
        FILTER_CATEGORY = "Categoría:",
        SEARCH_PLACEHOLDER = "Buscar ejercicios...",
        CUSTOM_EX_TITLE = "Crear ejercicio personalizado",
        CUSTOM_NAME = "Nombre:",
        CUSTOM_REPS = "Cantidad:",
        CUSTOM_UNIT = "Tipo:",
        CUSTOM_UNIT_REPS = "Reps",
        CUSTOM_UNIT_SECS = "Segundos",
        CUSTOM_EQ = "Requiere mancuernas",
        CUSTOM_CAT = "Categoría:",
        CUSTOM_DESC = "Instrucciones (opcional):",
        CUSTOM_ADDED = "¡Ejercicio personalizado añadido!",
        CUSTOM_EMPTY_NAME = "Escribe un nombre para el ejercicio.",

        -- History tab
        HISTORY_RECENT = "Actividad reciente",
        HISTORY_ROUTES = "Rutas aprendidas (%d)",
        HISTORY_NONE = "Aún no has completado ni saltado ejercicios.",
        ROUTES_NONE = "Aún no hay rutas nuevas guardadas. ¡Los datos de Forever ya cubren más de 1.900 rutas!",
        STATUS_COMPLETED = "Completado",
        STATUS_SKIPPED = "Saltado",

        -- Settings tab
        SET_LANGUAGE = "Idioma / Language",
        SET_EQUIPMENT = "Equipo disponible",
        SET_DIFFICULTY = "Dificultad máxima",
        SET_ALLOW_FLOOR = "Incluir ejercicios en el suelo (planchas, puentes, etc.)",
        SET_AUTO_ADVANCE_TIMED = "Autocompletar ejercicios por tiempo al llegar a 0",
        SET_FILL_BAR = "Llenar barra de progreso (desmarcado = vaciar)",
        SET_SOUNDS = "Sonidos al despegar y completar",
        SET_TOOLTIP = "Mostrar tiempo de vuelo y entreno en el mapa de vuelo",
        SET_AUTOHIDE = "Ocultar barra automáticamente 4s tras aterrizar",
        SET_MINIMAP = "Mostrar botón del minimapa",
        SET_SCALE = "Escala del HUD: %.0f%%",
        SET_RESET_STATS = "Reiniciar estadísticas",
        SET_RESET_CONFIRM = "Estadísticas reiniciadas.",

        -- Chat messages
        MSG_FLIGHT_START = "Vuelo iniciado: %s (%s). ¡A moverse!",
        MSG_FLIGHT_LEARNED = "Ruta aprendida %s: %s (guardada para futuros vuelos).",
        MSG_HUD_RESET = "Posición del HUD restablecida al centro.",
        MSG_HELP_HEADER = "Comandos de Fitness Exercise Forever:",
        MSG_HELP_1 = "/fef - Abrir o cerrar ventana principal",
        MSG_HELP_2 = "/fef test [segundos] - Simular un vuelo con barra y ejercicios (90s por defecto)",
        MSG_HELP_3 = "/fef dumbbells - Activar o desactivar mancuernas",
        MSG_HELP_4 = "/fef lang [es|en|auto] - Cambiar idioma",
        MSG_HELP_5 = "/fef reset - Centrar el HUD en pantalla",
    },
}

function ns.GetLang()
    local pref = FitnessExcerciseForeverDB
        and FitnessExcerciseForeverDB.settings
        and FitnessExcerciseForeverDB.settings.language
        or "auto"
    if pref == "es" or pref == "en" then
        return pref
    end
    local clientLocale = GetLocale and GetLocale() or "enUS"
    if clientLocale == "esES" or clientLocale == "esMX" then
        return "es"
    end
    return "en"
end

function ns.T(key, ...)
    local lang = ns.GetLang()
    local dict = strings[lang] or strings.en
    local text = dict[key] or strings.en[key] or key
    if select("#", ...) > 0 then
        return string.format(text, ...)
    end
    return text
end
