local _, ns = ...

local Exercises = {}
ns.Exercises = Exercises

Exercises.DIFFICULTY_RANK = {
    beginner = 1,
    intermediate = 2,
    advanced = 3,
}

-- Built-in bilingual exercise library.
-- Only two equipment types exist: "none" (bodyweight) and "dumbbells" (mancuernas).
Exercises.DEFAULTS = {
    -- =========================================================================
    -- BODYWEIGHT: UPPER BODY (Tren Superior)
    -- =========================================================================
    {
        id = "wall_pushups",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Wall Push-Ups", desc = "Hands on a wall at chest height, bend elbows cleanly and press back." },
        es = { name = "Flexiones en pared", desc = "Manos en la pared a la altura del pecho, flexiona codos y empuja." },
    },
    {
        id = "incline_pushups",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 10,
        unit = "reps",
        estSeconds = 25,
        en = { name = "Desk / Counter Push-Ups", desc = "Hands on a sturdy desk or counter, body straight, lower chest and press up." },
        es = { name = "Flexiones inclinadas (mesa)", desc = "Manos en una mesa firme o encimera, cuerpo recto, baja el pecho y sube." },
    },
    {
        id = "standard_pushups",
        equipment = "none",
        category = "upper",
        difficulty = "intermediate",
        position = "floor",
        amount = 10,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Push-Ups", desc = "Brace your core, lower chest near the floor with elbows at 45°, press up." },
        es = { name = "Flexiones clásicas", desc = "Activa el abdomen, baja el pecho hacia el suelo con codos a 45° y sube." },
    },
    {
        id = "wide_pushups",
        equipment = "none",
        category = "upper",
        difficulty = "intermediate",
        position = "floor",
        amount = 10,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Wide Push-Ups", desc = "Hands wider than shoulders to focus on chest; keep hips level." },
        es = { name = "Flexiones abiertas", desc = "Manos más anchas que los hombros para enfatizar pecho; cadera estable." },
    },
    {
        id = "diamond_pushups",
        equipment = "none",
        category = "upper",
        difficulty = "advanced",
        position = "floor",
        amount = 8,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Diamond Push-Ups", desc = "Thumbs and index fingers form a diamond under your chest; hits triceps hard." },
        es = { name = "Flexiones diamante", desc = "Junta pulgares e índices bajo el pecho formando un triángulo; enfoca tríceps." },
    },
    {
        id = "pike_pushups",
        equipment = "none",
        category = "upper",
        difficulty = "advanced",
        position = "floor",
        amount = 8,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Pike Push-Ups", desc = "Hips high in an inverted V, lower top of head toward hands and press up." },
        es = { name = "Flexiones en pica", desc = "Cadera alta en V invertida, baja la coronilla hacia las manos y empuja." },
    },
    {
        id = "knee_pushups",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "floor",
        amount = 10,
        unit = "reps",
        estSeconds = 25,
        en = { name = "Knee Push-Ups", desc = "Straight line from knees to head, lower chest under control and press up." },
        es = { name = "Flexiones de rodillas", desc = "Línea recta de rodillas a cabeza, baja el pecho con control y empuja." },
    },
    {
        id = "arm_circles",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 15,
        unit = "seconds_each_side",
        estSeconds = 30,
        en = { name = "Arm Circles", desc = "Arms out to the sides; 15s forward circles, then 15s backward." },
        es = { name = "Círculos con los brazos", desc = "Brazos en cruz; haz círculos controlados 15s hacia delante y 15s atrás." },
    },
    {
        id = "front_lateral_raises_bw",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Controlled Arm Raises", desc = "Alternate raising arms forward and out to shoulder height slowly." },
        es = { name = "Elevaciones de brazos", desc = "Alterna elevando los brazos al frente y a los lados hasta los hombros." },
    },
    {
        id = "scapular_squeezes",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "seated",
        amount = 12,
        unit = "reps",
        estSeconds = 25,
        en = { name = "Shoulder Blade Squeezes", desc = "Sit or stand tall, pull shoulder blades together and down, hold 1s." },
        es = { name = "Retracción escapular", desc = "Espalda recta, junta los omóplatos atrás y abajo manteniendo 1 segundo." },
    },
    {
        id = "ytw_raises",
        equipment = "none",
        category = "upper",
        difficulty = "intermediate",
        position = "standing",
        amount = 8,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Standing Y-T-W Raises", desc = "Hinge slightly at hips and form Y, T, and W shapes with thumbs up." },
        es = { name = "Elevaciones Y-T-W", desc = "Inclina el torso ligeramente y forma las letras Y, T y W con pulgares arriba." },
    },
    {
        id = "wall_angels",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 10,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Wall Angels", desc = "Back against a wall, slide elbows and wrists up and down like a snow angel." },
        es = { name = "Ángeles en pared", desc = "Espalda contra la pared, desliza codos y muñecas arriba y abajo." },
    },
    {
        id = "shadow_boxing",
        equipment = "none",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "Shadow Boxing Jabs", desc = "Light guard up, throw crisp alternating jabs and crosses at steady tempo." },
        es = { name = "Boxeo al aire", desc = "Guardia arriba, lanza golpes alternos rápidos y controlados al frente." },
    },
    {
        id = "superman_hold",
        equipment = "none",
        category = "upper",
        difficulty = "intermediate",
        position = "floor",
        amount = 20,
        unit = "seconds",
        estSeconds = 22,
        en = { name = "Superman Back Hold", desc = "Lie face down, gently lift chest and legs off the floor and squeeze back." },
        es = { name = "Supermán isométrico", desc = "Boca abajo, eleva suavemente pecho y piernas contrayendo la espalda." },
    },

    -- =========================================================================
    -- BODYWEIGHT: LOWER BODY (Tren Inferior)
    -- =========================================================================
    {
        id = "bodyweight_squats",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Bodyweight Squats", desc = "Feet shoulder-width, sit hips back and down, keep chest up, stand strong." },
        es = { name = "Sentadillas sin peso", desc = "Pies al ancho de hombros, lleva la cadera atrás y abajo, sube fuerte." },
    },
    {
        id = "sumo_squats",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Sumo Squats", desc = "Wide stance with toes pointed out 45°, squat straight down." },
        es = { name = "Sentadilla sumo", desc = "Piernas abiertas y puntas hacia fuera a 45°, baja recto con pecho alto." },
    },
    {
        id = "pulse_squats",
        equipment = "none",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 15,
        unit = "reps",
        estSeconds = 24,
        en = { name = "Pulse Squats", desc = "Hold the bottom half of a squat and perform small controlled pulses." },
        es = { name = "Sentadillas con rebotes", desc = "Quédate en la parte baja de la sentadilla haciendo pequeños pulsos." },
    },
    {
        id = "jump_squats",
        equipment = "none",
        category = "lower",
        difficulty = "advanced",
        position = "standing",
        amount = 10,
        unit = "reps",
        estSeconds = 22,
        en = { name = "Jump Squats", desc = "Squat down and explode into a soft jump, landing quietly on bent knees." },
        es = { name = "Sentadillas con salto", desc = "Baja en sentadilla y salta explosivo, aterrizando suave con rodillas flexionadas." },
    },
    {
        id = "reverse_lunges",
        equipment = "none",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 30,
        en = { name = "Reverse Lunges", desc = "Step back cleanly, drop back knee toward floor, drive through front heel." },
        es = { name = "Zancadas hacia atrás", desc = "Da un paso atrás, baja la rodilla trasera con control y empuja al frente." },
    },
    {
        id = "forward_lunges",
        equipment = "none",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 30,
        en = { name = "Forward Lunges", desc = "Step forward into a 90° bend on both knees, push back to standing." },
        es = { name = "Zancadas frontales", desc = "Paso al frente flexionando ambas rodillas a 90° y vuelve a la posición inicial." },
    },
    {
        id = "side_lunges",
        equipment = "none",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 30,
        en = { name = "Side Lunges", desc = "Step wide to the side, sit into that hip while the other leg stays straight." },
        es = { name = "Zancadas laterales", desc = "Paso amplio al lado flexionando esa pierna mientras la otra queda estirada." },
    },
    {
        id = "calf_raises",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "standing",
        amount = 18,
        unit = "reps",
        estSeconds = 24,
        en = { name = "Calf Raises", desc = "Rise high onto the balls of your feet, pause 1 second, lower slowly." },
        es = { name = "Elevaciones de gemelos", desc = "Sube de puntillas lo más alto posible, aguanta 1s y baja despacio." },
    },
    {
        id = "single_leg_calf_raises",
        equipment = "none",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 10,
        unit = "reps_each_side",
        estSeconds = 28,
        en = { name = "Single-Leg Calf Raises", desc = "Lightly touch a wall or desk for balance and lift one heel high." },
        es = { name = "Gemelos a una pierna", desc = "Apoya una mano suave para equilibrarte y sube con una sola pierna." },
    },
    {
        id = "wall_sit",
        equipment = "none",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 27,
        en = { name = "Wall Sit", desc = "Slide back down a wall until thighs are near parallel, hold steady." },
        es = { name = "Sentadilla isométrica en pared", desc = "Apoya la espalda en la pared bajando hasta unos 90° y mantén." },
    },
    {
        id = "glute_bridges",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "floor",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Glute Bridges", desc = "On your back, knees bent, drive through heels and squeeze glutes at top." },
        es = { name = "Puente de glúteos", desc = "Tumbado boca arriba con rodillas flexionadas, eleva la cadera apretando glúteos." },
    },
    {
        id = "single_leg_glute_bridge",
        equipment = "none",
        category = "lower",
        difficulty = "advanced",
        position = "floor",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 30,
        en = { name = "Single-Leg Glute Bridge", desc = "One leg extended straight, push hips up with the planted heel." },
        es = { name = "Puente de glúteo a una pierna", desc = "Una pierna estirada al frente, eleva la cadera empujando con el otro talón." },
    },
    {
        id = "good_mornings_bw",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 25,
        en = { name = "Bodyweight Good Mornings", desc = "Hands behind head, soft knees, hinge hips back with flat back, stand tall." },
        es = { name = "Buenos días sin peso", desc = "Manos tras la nuca, rodillas suaves, inclina el torso con espalda recta y sube." },
    },
    {
        id = "standing_hamstring_curls",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps_each_side",
        estSeconds = 26,
        en = { name = "Standing Hamstring Curls", desc = "Alternate bringing each heel briskly toward your glutes." },
        es = { name = "Curl femoral de pie", desc = "Alterna llevando cada talón hacia el glúteo con control." },
    },
    {
        id = "seated_leg_extensions",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "seated",
        amount = 10,
        unit = "reps_each_side",
        estSeconds = 24,
        en = { name = "Seated Knee Extensions", desc = "Sit tall, straighten one leg fully, squeeze quad 1s, lower slowly." },
        es = { name = "Extensiones de rodilla sentado", desc = "Sentado recto, estira una pierna del todo apretando el cuádriceps y baja." },
    },
    {
        id = "quick_squat_finish",
        equipment = "none",
        category = "lower",
        difficulty = "beginner",
        position = "standing",
        amount = 6,
        unit = "reps",
        estSeconds = 13,
        en = { name = "Quick Half-Squats", desc = "Fast, clean half-squats ideal for short flights." },
        es = { name = "Medias sentadillas rápidas", desc = "Repeticiones fluidas y limpias, ideales para vuelos cortos." },
    },

    -- =========================================================================
    -- BODYWEIGHT: CORE / ABDOMEN
    -- =========================================================================
    {
        id = "forearm_plank",
        equipment = "none",
        category = "core",
        difficulty = "intermediate",
        position = "floor",
        amount = 25,
        unit = "seconds",
        estSeconds = 27,
        en = { name = "Forearm Plank", desc = "Elbows under shoulders, body in a tight straight line, breathe steadily." },
        es = { name = "Plancha abdominal", desc = "Antebrazos bajo los hombros, cuerpo recto y abdomen firme sin bajar cadera." },
    },
    {
        id = "plank_shoulder_taps",
        equipment = "none",
        category = "core",
        difficulty = "intermediate",
        position = "floor",
        amount = 10,
        unit = "reps_each_side",
        estSeconds = 28,
        en = { name = "Plank Shoulder Taps", desc = "High plank, tap opposite shoulder without letting hips sway." },
        es = { name = "Toques de hombro en plancha", desc = "En plancha alta, toca el hombro contrario evitando balancear la cadera." },
    },
    {
        id = "side_plank_hold",
        equipment = "none",
        category = "core",
        difficulty = "intermediate",
        position = "floor",
        amount = 15,
        unit = "seconds_each_side",
        estSeconds = 32,
        en = { name = "Side Plank", desc = "Stack feet or drop bottom knee, lift hips straight up, switch sides." },
        es = { name = "Plancha lateral", desc = "Apoya el antebrazo, eleva la cadera formando línea recta y cambia de lado." },
    },
    {
        id = "dead_bug",
        equipment = "none",
        category = "core",
        difficulty = "beginner",
        position = "floor",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 28,
        en = { name = "Dead Bug", desc = "On your back, lower opposite arm and leg slowly while pressing low back down." },
        es = { name = "Bicho muerto (Dead Bug)", desc = "Boca arriba, extiende brazo y pierna contrarios sin despegar la lumbar." },
    },
    {
        id = "bird_dog",
        equipment = "none",
        category = "core",
        difficulty = "beginner",
        position = "floor",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 28,
        en = { name = "Bird Dog", desc = "On all fours, reach opposite arm and leg long without twisting hips." },
        es = { name = "Perro-pájaro (Bird Dog)", desc = "A cuatro patas, estira brazo y pierna opuestos manteniendo la espalda neutra." },
    },
    {
        id = "bicycle_crunches",
        equipment = "none",
        category = "core",
        difficulty = "intermediate",
        position = "floor",
        amount = 12,
        unit = "reps_each_side",
        estSeconds = 28,
        en = { name = "Bicycle Crunches", desc = "Rotate shoulder toward opposite knee smoothly; don't pull on your neck." },
        es = { name = "Abdominales bicicleta", desc = "Lleva el hombro hacia la rodilla contraria rotando el torso sin tirar del cuello." },
    },
    {
        id = "russian_twists_bw",
        equipment = "none",
        category = "core",
        difficulty = "intermediate",
        position = "floor",
        amount = 12,
        unit = "reps_each_side",
        estSeconds = 25,
        en = { name = "Russian Twists", desc = "Lean back slightly with chest proud and rotate torso smoothly side to side." },
        es = { name = "Giros rusos", desc = "Inclina el torso atrás con pecho alto y gira de lado a lado controlando." },
    },
    {
        id = "standing_knee_to_elbow",
        equipment = "none",
        category = "core",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps_each_side",
        estSeconds = 26,
        en = { name = "Standing Cross-Body Crunches", desc = "Hands behind head, bring right knee up toward left elbow and alternate." },
        es = { name = "Abdominales cruzados de pie", desc = "Manos tras la cabeza, sube la rodilla hacia el codo contrario alternando." },
    },
    {
        id = "seated_knee_tucks",
        equipment = "none",
        category = "core",
        difficulty = "beginner",
        position = "seated",
        amount = 14,
        unit = "reps",
        estSeconds = 24,
        en = { name = "Seated Core Knee Lifts", desc = "Sit near front of chair, brace abs and lift both knees slightly off floor." },
        es = { name = "Elevación de rodillas sentado", desc = "En el borde de la silla, activa el abdomen y eleva ambas rodillas a la vez." },
    },
    {
        id = "hollow_hold",
        equipment = "none",
        category = "core",
        difficulty = "advanced",
        position = "floor",
        amount = 20,
        unit = "seconds",
        estSeconds = 22,
        en = { name = "Hollow Body Hold", desc = "Press lower back into floor, lift shoulders and straight legs a few inches." },
        es = { name = "Hollow Hold (barca)", desc = "Lumbar pegada al suelo, despega hombros y piernas estiradas unos centímetros." },
    },

    -- =========================================================================
    -- BODYWEIGHT: CARDIO
    -- =========================================================================
    {
        id = "jumping_jacks",
        equipment = "none",
        category = "cardio",
        difficulty = "beginner",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "Jumping Jacks", desc = "Light on your feet, arms overhead and legs out in a brisk rhythm." },
        es = { name = "Saltos de tijera (Jumping Jacks)", desc = "Aterriza suave, abre piernas y junta brazos arriba a ritmo constante." },
    },
    {
        id = "high_knees",
        equipment = "none",
        category = "cardio",
        difficulty = "intermediate",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "High Knees", desc = "Drive knees up toward waist height rapidly while pumping arms." },
        es = { name = "Rodillas al pecho (Skipping)", desc = "Sube las rodillas rápido hacia la cintura acompañando con los brazos." },
    },
    {
        id = "march_in_place",
        equipment = "none",
        category = "cardio",
        difficulty = "beginner",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "Brisk March in Place", desc = "Lift knees briskly and swing arms to get blood flowing without impact." },
        es = { name = "Marcha enérgica en el sitio", desc = "Eleva rodillas con ritmo y mueve brazos para activar la circulación sin impacto." },
    },
    {
        id = "skaters",
        equipment = "none",
        category = "cardio",
        difficulty = "intermediate",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "Speed Skaters", desc = "Bound side to side softly like a speed skater, tapping back foot behind." },
        es = { name = "Patinadores laterales", desc = "Salta suave de lado a lado cruzando el pie trasero por detrás." },
    },
    {
        id = "mountain_climbers",
        equipment = "none",
        category = "cardio",
        difficulty = "intermediate",
        position = "floor",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "Mountain Climbers", desc = "High plank position, drive knees toward chest alternately at a crisp pace." },
        es = { name = "Escaladores (Mountain Climbers)", desc = "En plancha alta, lleva las rodillas al pecho alternando con agilidad." },
    },
    {
        id = "burpees_no_pushup",
        equipment = "none",
        category = "cardio",
        difficulty = "advanced",
        position = "standing",
        amount = 8,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Athletic Burpees", desc = "Hands down, hop back to plank, hop feet forward and stand/jump tall." },
        es = { name = "Burpees atléticos", desc = "Manos al suelo, salto atrás a plancha, salto adelante y arriba." },
    },
    {
        id = "butt_kicks",
        equipment = "none",
        category = "cardio",
        difficulty = "beginner",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "Butt Kicks", desc = "Jog lightly in place kicking heels back toward your glutes." },
        es = { name = "Talones al glúteo", desc = "Trote suave en el sitio llevando los talones hacia atrás." },
    },

    -- =========================================================================
    -- BODYWEIGHT: MOBILITY / DESK RECOVERY (Movilidad)
    -- =========================================================================
    {
        id = "wrist_stretches",
        equipment = "none",
        category = "mobility",
        difficulty = "beginner",
        position = "seated",
        amount = 15,
        unit = "seconds_each_side",
        estSeconds = 30,
        en = { name = "Gamer Wrist & Forearm Stretch", desc = "Extend arm forward, gently pull fingers down/back with the other hand." },
        es = { name = "Estiramiento de muñecas", desc = "Brazo estirado al frente, tira suavemente de los dedos hacia atrás." },
    },
    {
        id = "thoracic_rotations",
        equipment = "none",
        category = "mobility",
        difficulty = "beginner",
        position = "standing",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 24,
        en = { name = "Standing Trunk Twists", desc = "Hips facing forward, gently rotate upper torso left and right." },
        es = { name = "Rotaciones torácicas de pie", desc = "Cadera mirando al frente, gira suavemente la parte alta de la espalda." },
    },
    {
        id = "neck_shoulder_reset",
        equipment = "none",
        category = "mobility",
        difficulty = "beginner",
        position = "seated",
        amount = 12,
        unit = "reps_each_dir",
        estSeconds = 22,
        en = { name = "Shoulder Rolls & Neck Reset", desc = "Roll shoulders slowly back 12x then forward 12x; drop shoulders down." },
        es = { name = "Rotación de hombros y cuello", desc = "Gira hombros despacio atrás y adelante; relaja el cuello al soltar." },
    },
    {
        id = "chest_doorway_opener",
        equipment = "none",
        category = "mobility",
        difficulty = "beginner",
        position = "standing",
        amount = 20,
        unit = "seconds",
        estSeconds = 20,
        en = { name = "Chest & Posture Opener", desc = "Clasp hands behind back, gently lift chest and pull shoulders back." },
        es = { name = "Apertura de pecho y postura", desc = "Entrelaza manos detrás de la espalda, abre el pecho y junta hombros." },
    },
    {
        id = "standing_side_stretch",
        equipment = "none",
        category = "mobility",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "seconds_each_side",
        estSeconds = 24,
        en = { name = "Overhead Side Reach", desc = "Reach one arm high overhead and lean gently to the opposite side." },
        es = { name = "Estiramiento lateral", desc = "Estira un brazo hacia el techo e inclínate suave hacia el lado contrario." },
    },
    {
        id = "standing_calf_stretch",
        equipment = "none",
        category = "mobility",
        difficulty = "beginner",
        position = "standing",
        amount = 15,
        unit = "seconds_each_side",
        estSeconds = 30,
        en = { name = "Standing Calf Stretch", desc = "Step one foot back, keep back heel flat on floor and lean slightly forward." },
        es = { name = "Estiramiento de gemelos", desc = "Un pie atrás con el talón pegado al suelo, inclina suave el peso adelante." },
    },
    {
        id = "quick_deep_breaths",
        equipment = "none",
        category = "mobility",
        difficulty = "beginner",
        position = "seated",
        amount = 15,
        unit = "seconds",
        estSeconds = 15,
        en = { name = "Posture & Breath Reset", desc = "Sit tall, inhale 4s through nose, exhale 5s slowly. Great for short hops." },
        es = { name = "Respiración y postura", desc = "Espalda recta, inhala 4s por la nariz y suelta en 5s. Ideal para vuelos cortos." },
    },

    -- =========================================================================
    -- DUMBBELLS (Mancuernas): UPPER BODY
    -- =========================================================================
    {
        id = "db_bicep_curls",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Dumbbell Bicep Curls", desc = "Elbows tucked near your ribs, curl dumbbells up cleanly without swinging." },
        es = { name = "Curl de bíceps con mancuernas", desc = "Codos pegados al cuerpo, sube las mancuernas sin balancear la espalda." },
    },
    {
        id = "db_hammer_curls",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Hammer Curls", desc = "Palms facing each other, curl weights smoothly toward shoulders." },
        es = { name = "Curl martillo", desc = "Palmas mirándose entre sí, sube las mancuernas hacia los hombros con control." },
    },
    {
        id = "db_overhead_press",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "standing",
        amount = 10,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Dumbbell Overhead Press", desc = "Brace abs, press dumbbells straight overhead from shoulders without arching back." },
        es = { name = "Press militar con mancuernas", desc = "Abdomen firme, empuja las mancuernas sobre la cabeza sin arquear lumbar." },
    },
    {
        id = "db_arnold_press",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "seated",
        amount = 10,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Seated Arnold Press", desc = "Start palms facing you, rotate wrists outward as you press overhead." },
        es = { name = "Press Arnold sentado", desc = "Empieza con palmas hacia ti, rota las muñecas hacia fuera mientras subes." },
    },
    {
        id = "db_lateral_raises",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Dumbbell Lateral Raises", desc = "Soft bend in elbows, raise dumbbells out to shoulder height and lower slowly." },
        es = { name = "Elevaciones laterales", desc = "Codos ligeramente flexionados, sube los brazos en cruz hasta los hombros." },
    },
    {
        id = "db_front_raises",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 10,
        unit = "reps_each_side",
        estSeconds = 28,
        en = { name = "Alternating Front Raises", desc = "Raise one dumbbell forward to shoulder level, lower with control, alternate." },
        es = { name = "Elevaciones frontales alternas", desc = "Sube una mancuerna al frente hasta la altura del hombro y baja despacio." },
    },
    {
        id = "db_bent_over_row",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Dumbbell Bent-Over Rows", desc = "Hinge at hips with flat back, pull dumbbells toward your hips and squeeze." },
        es = { name = "Remo inclinado con mancuernas", desc = "Inclina el torso con espalda recta, tira de las mancuernas hacia la cadera." },
    },
    {
        id = "db_reverse_fly",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Dumbbell Reverse Fly", desc = "Hinge forward, lift weights out wide to squeeze rear shoulders and upper back." },
        es = { name = "Pájaros con mancuernas", desc = "Torso inclinado, abre los brazos en cruz juntando escápulas atrás." },
    },
    {
        id = "db_overhead_tricep_ext",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Overhead Tricep Extension", desc = "Hold one dumbbell with both hands overhead, bend elbows behind head and extend." },
        es = { name = "Extensión de tríceps sobre cabeza", desc = "Sujeta una mancuerna con ambas manos arriba, baja detrás de la cabeza y sube." },
    },
    {
        id = "db_tricep_kickbacks",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 26,
        en = { name = "Tricep Kickbacks", desc = "Hinge forward, pin elbows to sides, extend forearms straight back." },
        es = { name = "Patada de tríceps", desc = "Torso inclinado, codos fijos al costado, estira los antebrazos hacia atrás." },
    },
    {
        id = "db_floor_press",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "floor",
        amount = 12,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Dumbbell Floor Press", desc = "Lie on your back, knees bent, press dumbbells up and tap elbows softly." },
        es = { name = "Press de pecho en el suelo", desc = "Boca arriba con rodillas dobladas, empuja las mancuernas arriba y baja suave." },
    },
    {
        id = "db_shrugs",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "beginner",
        position = "standing",
        amount = 15,
        unit = "reps",
        estSeconds = 24,
        en = { name = "Dumbbell Shrugs", desc = "Hold dumbbells at your sides, shrug shoulders straight up toward ears, hold 1s." },
        es = { name = "Encogimientos de trapecio", desc = "Mancuernas a los lados, sube los hombros hacia las orejas y aguanta 1s." },
    },
    {
        id = "db_upright_row",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 25,
        en = { name = "Dumbbell Upright Row", desc = "Lead with elbows to pull dumbbells up to chest level, lower smoothly." },
        es = { name = "Remo al mentón", desc = "Sube las mancuernas pegadas al cuerpo guiando con los codos hasta el pecho." },
    },
    {
        id = "db_curl_to_press",
        equipment = "dumbbells",
        category = "upper",
        difficulty = "advanced",
        position = "standing",
        amount = 10,
        unit = "reps",
        estSeconds = 30,
        en = { name = "Curl to Overhead Press", desc = "Perform a bicep curl, then immediately press the dumbbells overhead." },
        es = { name = "Curl + Press de hombros", desc = "Haz un curl de bíceps y encadena directamente con un press arriba." },
    },

    -- =========================================================================
    -- DUMBBELLS (Mancuernas): LOWER BODY & FULL BODY
    -- =========================================================================
    {
        id = "db_goblet_squat",
        equipment = "dumbbells",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Goblet Squat", desc = "Hold one dumbbell vertically at chest height, squat deep with elbows inside knees." },
        es = { name = "Sentadilla Goblet", desc = "Sujeta una mancuerna pegada al pecho, baja profundo con espalda erguida." },
    },
    {
        id = "db_rdl",
        equipment = "dumbbells",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Dumbbell Romanian Deadlift", desc = "Soft knees, slide weights down thighs by pushing hips back, squeeze glutes up." },
        es = { name = "Peso muerto rumano", desc = "Rodillas semidobladas, desliza mancuernas bajando cadera atrás y sube." },
    },
    {
        id = "db_reverse_lunges",
        equipment = "dumbbells",
        category = "lower",
        difficulty = "advanced",
        position = "standing",
        amount = 8,
        unit = "reps_each_side",
        estSeconds = 32,
        en = { name = "Dumbbell Reverse Lunges", desc = "Hold dumbbells at sides, step back cleanly into a lunge and drive up." },
        es = { name = "Zancadas atrás con mancuernas", desc = "Mancuernas a los lados, da un paso atrás controlado y empuja arriba." },
    },
    {
        id = "db_calf_raises",
        equipment = "dumbbells",
        category = "lower",
        difficulty = "beginner",
        position = "standing",
        amount = 16,
        unit = "reps",
        estSeconds = 24,
        en = { name = "Weighted Calf Raises", desc = "Hold dumbbells at your sides, rise onto toes smoothly, pause and lower." },
        es = { name = "Gemelos con mancuernas", desc = "Sostén las mancuernas a los lados, sube de puntillas y baja despacio." },
    },
    {
        id = "db_sumo_squat",
        equipment = "dumbbells",
        category = "lower",
        difficulty = "intermediate",
        position = "standing",
        amount = 12,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Dumbbell Sumo Squat", desc = "Wide stance, hold one or two dumbbells hanging between knees, squat straight down." },
        es = { name = "Sentadilla sumo con mancuerna", desc = "Pies abiertos, sujeta una mancuerna en el centro y baja recto." },
    },
    {
        id = "db_thrusters",
        equipment = "dumbbells",
        category = "cardio",
        difficulty = "advanced",
        position = "standing",
        amount = 10,
        unit = "reps",
        estSeconds = 28,
        en = { name = "Dumbbell Thrusters", desc = "Dumbbells at shoulders, squat down and use leg drive to press weights overhead." },
        es = { name = "Thrusters con mancuernas", desc = "Mancuernas en hombros, haz sentadilla y aprovecha el impulso para subirlas." },
    },

    -- =========================================================================
    -- DUMBBELLS (Mancuernas): CORE
    -- =========================================================================
    {
        id = "db_suitcase_march",
        equipment = "dumbbells",
        category = "core",
        difficulty = "beginner",
        position = "standing",
        amount = 15,
        unit = "seconds_each_side",
        estSeconds = 32,
        en = { name = "Single-Arm Suitcase March", desc = "Hold one dumbbell at one side, march tall without leaning sideways, then switch." },
        es = { name = "Marcha maleta (1 mancuerna)", desc = "Sujeta una mancuerna de un lado, marcha recto sin inclinarte y cambia de mano." },
    },
    {
        id = "db_side_bends",
        equipment = "dumbbells",
        category = "core",
        difficulty = "beginner",
        position = "standing",
        amount = 10,
        unit = "reps_each_side",
        estSeconds = 26,
        en = { name = "Dumbbell Oblique Side Bends", desc = "Hold one dumbbell at your side, bend laterally slightly and pull back with obliques." },
        es = { name = "Inclinación lateral con mancuerna", desc = "Una mancuerna a un lado, inclina el torso lateralmente y vuelve con el oblicuo." },
    },
    {
        id = "db_russian_twists",
        equipment = "dumbbells",
        category = "core",
        difficulty = "intermediate",
        position = "floor",
        amount = 10,
        unit = "reps_each_side",
        estSeconds = 26,
        en = { name = "Weighted Russian Twists", desc = "Hold one dumbbell at chest, lean back slightly and rotate smoothly side to side." },
        es = { name = "Giros rusos con mancuerna", desc = "Sujeta una mancuerna al pecho, inclínate un poco y gira a ambos lados." },
    },
    {
        id = "db_farmers_march",
        equipment = "dumbbells",
        category = "core",
        difficulty = "beginner",
        position = "standing",
        amount = 25,
        unit = "seconds",
        estSeconds = 25,
        en = { name = "Farmer's Carry March", desc = "Hold both dumbbells firmly, shoulders down and back, march steadily in place." },
        es = { name = "Paseo del granjero en el sitio", desc = "Sujeta ambas mancuernas con postura erguida y marcha en el sitio." },
    },
}

function Exercises:GetAll()
    local list = {}
    for _, ex in ipairs(self.DEFAULTS) do
        list[#list + 1] = ex
    end
    local db = FitnessExcerciseForeverDB
    if db and db.customExercises then
        for _, ex in ipairs(db.customExercises) do
            list[#list + 1] = ex
        end
    end
    return list
end

function Exercises:IsEnabled(id)
    local db = FitnessExcerciseForeverDB
    if db and db.disabledExercises and db.disabledExercises[id] then
        return false
    end
    return true
end

function Exercises:GetLocalized(ex)
    local lang = ns.GetLang()
    if ex[lang] then
        return ex[lang].name or ex.id, ex[lang].desc or ""
    end
    local fallback = ex.en or ex.es or {}
    return fallback.name or ex.name or ex.id, fallback.desc or ex.desc or ""
end

function Exercises:FormatPrescription(ex)
    local amount = tonumber(ex.amount) or 10
    local unit = ex.unit or "reps"
    if unit == "reps" then
        return ns.T("UNIT_REPS", amount)
    elseif unit == "reps_each_side" then
        return ns.T("UNIT_REPS_EACH_SIDE", amount)
    elseif unit == "reps_each_dir" then
        return ns.T("UNIT_REPS_EACH_DIR", amount)
    elseif unit == "seconds" then
        return ns.T("UNIT_SECONDS", amount)
    elseif unit == "seconds_each_side" then
        return ns.T("UNIT_SECONDS_EACH_SIDE", amount)
    end
    return tostring(amount)
end

function Exercises:IsTimed(ex)
    return ex and ex.unit and (ex.unit == "seconds" or ex.unit == "seconds_each_side")
end

function Exercises:GetTimedSeconds(ex)
    if not self:IsTimed(ex) then return 0 end
    local amount = tonumber(ex.amount) or 15
    if ex.unit == "seconds_each_side" then
        return amount * 2
    end
    return amount
end

function Exercises:GetEligible(maxSeconds, settings, excludeMap)
    settings = settings or (FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings) or {}
    local eqMode = settings.equipmentMode or "none"
    local maxDiff = settings.difficulty or "all"
    local maxRank = (maxDiff == "all") and 99 or (self.DIFFICULTY_RANK[maxDiff] or 3)
    local allowFloor = settings.allowFloor ~= false

    local eligible = {}
    for _, ex in ipairs(self:GetAll()) do
        if self:IsEnabled(ex.id) and not (excludeMap and excludeMap[ex.id]) then
            local eqOK = (ex.equipment == "none")
                or (ex.equipment == "dumbbells" and (eqMode == "mixed" or eqMode == "prefer_dumbbells"))
            local diffRank = self.DIFFICULTY_RANK[ex.difficulty or "beginner"] or 1
            local diffOK = diffRank <= maxRank
            local posOK = allowFloor or (ex.position ~= "floor")
            local timeOK = (not maxSeconds) or ((ex.estSeconds or 20) <= maxSeconds)

            if eqOK and diffOK and posOK and timeOK then
                eligible[#eligible + 1] = ex
            end
        end
    end
    return eligible
end

function Exercises:PickNext(remainingSeconds, sessionSeen, lastCategory, settings)
    settings = settings or (FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings) or {}
    local db = FitnessExcerciseForeverDB or {}
    local recent = db.recentExercises or {}

    local budget = math.max(10, (remainingSeconds or 60) - 4)
    local exclude = {}
    if sessionSeen then
        for id, v in pairs(sessionSeen) do
            if v then exclude[id] = true end
        end
    end
    for _, id in ipairs(recent) do
        exclude[id] = true
    end

    local pool = self:GetEligible(budget, settings, exclude)

    -- Relax recent memory first, keeping current flight's sessionSeen excluded.
    if #pool == 0 then
        pool = self:GetEligible(budget, settings, sessionSeen)
    end
    -- Relax sessionSeen if the flight is super long and user cycled through everything.
    if #pool == 0 then
        pool = self:GetEligible(budget, settings, nil)
    end
    -- If remaining budget is tight (e.g. 12-18s), allow any quick <=15s exercise regardless of strict filters.
    if #pool == 0 and budget >= 12 then
        local all = self:GetEligible(budget, { equipmentMode = settings.equipmentMode or "none", difficulty = "all", allowFloor = true }, nil)
        pool = all
    end

    if #pool == 0 then
        return nil
    end

    -- Prefer a different category than the previous exercise for variety.
    local varied = {}
    for _, ex in ipairs(pool) do
        if ex.category ~= lastCategory then
            varied[#varied + 1] = ex
        end
    end
    if #varied > 0 then
        pool = varied
    end

    -- If "prefer_dumbbells" is active, weight dumbbell exercises higher (~75% chance).
    if settings.equipmentMode == "prefer_dumbbells" then
        local dbOnly = {}
        for _, ex in ipairs(pool) do
            if ex.equipment == "dumbbells" then
                dbOnly[#dbOnly + 1] = ex
            end
        end
        if #dbOnly > 0 and math.random() < 0.75 then
            pool = dbOnly
        end
    end

    local picked = pool[math.random(#pool)]
    return picked
end

function Exercises:MarkRecent(id)
    local db = FitnessExcerciseForeverDB
    if not db then return end
    db.recentExercises = db.recentExercises or {}
    for i = #db.recentExercises, 1, -1 do
        if db.recentExercises[i] == id then
            table.remove(db.recentExercises, i)
        end
    end
    table.insert(db.recentExercises, 1, id)
    while #db.recentExercises > 16 do
        table.remove(db.recentExercises)
    end
end
