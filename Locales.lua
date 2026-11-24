local _, ns = ...

local Locales = {}
ns.Locales = Locales

local strings = {
    en = {
        ADDON_NAME = "Fitness Exercise Forever",
        LOADED_MSG = "|cff00d4aaFitness Exercise Forever|r loaded! Hop on a gryphon or type |cffffd780/fef|r.",

        LANG_NAME = "English",

        -- Flight Bar
        FLIGHT_READY = "On the ground — Ready for your next flight",
        FLIGHT_TEST_BTN = "Test 90s",
        FLIGHT_TIME_LEFT = "%s left",
        FLIGHT_TIME_TOTAL = "(%s total)",
        FLIGHT_ELAPSED = "Flying: %s",
        FLIGHT_LANDED = "Landed! (100%)",
        FLIGHT_NEXT_STOP = "Next stop: %s (%s)",
        BADGE_EXACT = "EXACT",
        BADGE_EST = "EST.",
        BADGE_TEST = "TEST",

        -- Setup Controls
        LABEL_EQUIPMENT = "Equipment:",
        LABEL_DIFFICULTY = "Difficulty:",
        EQ_NONE = "No Equipment",
        EQ_MIXED = "No Equip + Dumbbells",
        EQ_TAG_NONE = "Bodyweight",
        EQ_TAG_DB = "Dumbbells",

        DIFF_BEGINNER = "Beginner",
        DIFF_INTERMEDIATE = "Intermediate",
        DIFF_ADVANCED = "Advanced",

        SETUP_HINT = "Choose your equipment and difficulty above to start your flight exercises.",
        BTN_START_EXERCISES = "Show Exercises",

        -- Exercise Card
        CAT_UPPER = "Upper Body",
        CAT_LOWER = "Lower Body",
        CAT_CORE = "Core",
        CAT_CARDIO = "Cardio",
        CAT_MOBILITY = "Mobility",

        UNIT_REPS = "%d reps",
        UNIT_REPS_EACH_SIDE = "%d / side",
        UNIT_REPS_EACH_DIR = "%d / dir",
        UNIT_SECONDS = "%d sec",
        UNIT_SECONDS_EACH_SIDE = "%d sec / side",

        EX_DONE_COUNT = "Done: %d",
        EX_TIMER_PREP = "Get ready: %ds",
        EX_TIMER_LEFT = "Time left: %s",
        EX_TIMER_DONE = "Time's up! Click Complete.",
        EX_NEXT_UP = "Next: %s",
        EX_APPROACH_TITLE = "Final Approach",
        EX_APPROACH_DESC = "Less than 10 seconds left — breathe deep and prepare to land!",
        EX_LANDED_TITLE = "Flight Complete!",
        EX_LANDED_DESC = "Great work! Hop on another gryphon anytime or click Complete/Skip to keep moving.",
        EX_EMPTY_TITLE = "No Exercises Found",
        EX_EMPTY_DESC = "Try another difficulty or equipment option.",

        -- Buttons
        BTN_COMPLETE = "Complete",
        BTN_SKIP = "Skip",

        -- Map Tooltip & Minimap
        TOOLTIP_FLIGHT_TIME = "Flight time: %s",
        TOOLTIP_FLIGHT_APPROX = "Flight time: ~%s",
        TOOLTIP_FREQUENT_FLIER = " (Frequent Flier)",
        TOOLTIP_MINIMAP_1 = "Click to open Fitness Exercise Forever",
        TOOLTIP_MINIMAP_2 = "Right-click to test a 90s flight",
        TOOLTIP_MINIMAP_3 = "Drag around the minimap to move",

        -- Chat
        MSG_HUD_RESET = "Window position reset to center.",
        MSG_HELP_1 = "/fef - Open or close window",
        MSG_HELP_2 = "/fef test [seconds] - Simulate a flight (default 90s)",
        MSG_HELP_3 = "/fef lang [es|en|auto] - Switch language",
        MSG_HELP_4 = "/fef reset - Center window",
    },

    es = {
        ADDON_NAME = "Fitness Exercise Forever",
        LOADED_MSG = "|cff00d4aaFitness Exercise Forever|r cargado. Súbete a un grifo o escribe |cffffd780/fef|r.",

        LANG_NAME = "Español",

        -- Flight Bar
        FLIGHT_READY = "En tierra — Listo para tu próximo vuelo",
        FLIGHT_TEST_BTN = "Probar 90s",
        FLIGHT_TIME_LEFT = "%s restante",
        FLIGHT_TIME_TOTAL = "(%s total)",
        FLIGHT_ELAPSED = "Volando: %s",
        FLIGHT_LANDED = "¡Has aterrizado! (100%)",
        FLIGHT_NEXT_STOP = "Siguiente parada: %s (%s)",
        BADGE_EXACT = "EXACTO",
        BADGE_EST = "EST.",
        BADGE_TEST = "PRUEBA",

        -- Setup Controls
        LABEL_EQUIPMENT = "Equipo:",
        LABEL_DIFFICULTY = "Dificultad:",
        EQ_NONE = "Sin equipo",
        EQ_MIXED = "Sin equipo + Mancuernas",
        EQ_TAG_NONE = "Sin equipo",
        EQ_TAG_DB = "Mancuernas",

        DIFF_BEGINNER = "Principiante",
        DIFF_INTERMEDIATE = "Intermedio",
        DIFF_ADVANCED = "Avanzado",

        SETUP_HINT = "Elige tu equipo y dificultad arriba para ver los ejercicios del vuelo.",
        BTN_START_EXERCISES = "Ver ejercicios",

        -- Exercise Card
        CAT_UPPER = "Tren Superior",
        CAT_LOWER = "Tren Inferior",
        CAT_CORE = "Abdomen / Core",
        CAT_CARDIO = "Cardio",
        CAT_MOBILITY = "Movilidad",

        UNIT_REPS = "%d repeticiones",
        UNIT_REPS_EACH_SIDE = "%d por lado",
        UNIT_REPS_EACH_DIR = "%d por dirección",
        UNIT_SECONDS = "%d seg",
        UNIT_SECONDS_EACH_SIDE = "%d seg / lado",

        EX_DONE_COUNT = "Hechos: %d",
        EX_TIMER_PREP = "Prepárate: %ds",
        EX_TIMER_LEFT = "Tiempo: %s",
        EX_TIMER_DONE = "¡Tiempo! Pulsa Completado.",
        EX_NEXT_UP = "Siguiente: %s",
        EX_APPROACH_TITLE = "Aterrizaje inminente",
        EX_APPROACH_DESC = "Quedan menos de 10 segundos: respira hondo y prepárate para aterrizar.",
        EX_LANDED_TITLE = "¡Vuelo completado!",
        EX_LANDED_DESC = "¡Buen trabajo! La ventana se abrirá sola en tu próximo vuelo.",
        EX_EMPTY_TITLE = "Sin ejercicios",
        EX_EMPTY_DESC = "Prueba otra dificultad o selección de equipo.",

        -- Buttons
        BTN_COMPLETE = "Completado",
        BTN_SKIP = "Saltar",

        -- Map Tooltip & Minimap
        TOOLTIP_FLIGHT_TIME = "Tiempo de vuelo: %s",
        TOOLTIP_FLIGHT_APPROX = "Tiempo de vuelo: ~%s",
        TOOLTIP_FREQUENT_FLIER = " (Viajero frecuente)",
        TOOLTIP_MINIMAP_1 = "Clic izquierdo para abrir Fitness Exercise Forever",
        TOOLTIP_MINIMAP_2 = "Clic derecho para probar un vuelo de 90s",
        TOOLTIP_MINIMAP_3 = "Arrastra alrededor del minimapa para mover",

        -- Chat
        MSG_HUD_RESET = "Posición de la ventana restablecida al centro.",
        MSG_HELP_1 = "/fef - Abrir o cerrar ventana",
        MSG_HELP_2 = "/fef test [segundos] - Simular un vuelo (90s por defecto)",
        MSG_HELP_3 = "/fef lang [es|en|auto] - Cambiar idioma",
        MSG_HELP_4 = "/fef reset - Centrar ventana",
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
