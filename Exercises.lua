local _, ns = ...

local Exercises = {}
ns.Exercises = Exercises

Exercises.DIFFICULTY_RANK = {
    beginner = 1,
    intermediate = 2,
    advanced = 3,
}

Exercises.POSE_TEXTURE = "Interface\\AddOns\\FitnessExcerciseForever\\Media\\Poses.tga"
Exercises.POSE_COLS = 8
Exercises.POSE_ROWS = 4

-- Pose indices in Media\Poses.tga (0..31):
--  0: wall_pushup      1: incline_pushup   2: floor_pushup     3: pike_pushup
--  4: arm_circles      5: wall_angels      6: shadow_boxing    7: superman
--  8: squat            9: jump_squat      10: lunge           11: side_lunge
-- 12: calf_raise      13: wall_sit        14: glute_bridge    15: good_morning
-- 16: plank           17: side_plank      18: dead_bug        19: bird_dog
-- 20: crunch_twist    21: jumping_jacks   22: high_knees      23: mountain_climber
-- 24: stretch_wrist   25: stretch_side    26: db_curl         27: db_press
-- 28: db_row          29: db_lateral      30: db_squat_rdl    31: db_carry

Exercises.DEFAULTS = {
    -- =========================================================================
    -- BODYWEIGHT: UPPER BODY
    -- =========================================================================
    {
        id = "wall_pushups", equipment = "none", category = "upper", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 0,
        en = {
            name = "Wall Push-Ups",
            setup = "Stand arm's length from a wall, palms flat on the wall at chest height.",
            move = "Keep your body straight like a plank, bend your elbows to bring your chest near the wall, then push back.",
            tip = "Squeeze your abs so your lower back stays straight; exhale as you push away.",
        },
        es = {
            name = "Flexiones en pared",
            setup = "Colócate a un brazo de distancia de la pared con las palmas apoyadas a la altura del pecho.",
            move = "Mantén el cuerpo recto, flexiona los codos acercando el pecho a la pared y empuja hasta estirar.",
            tip = "Aprieta el abdomen para no hundir la lumbar y suelta el aire al empujar.",
        },
    },
    {
        id = "incline_pushups", equipment = "none", category = "upper", difficulty = "beginner", position = "standing",
        amount = 10, unit = "reps", estSeconds = 25, pose = 1,
        en = {
            name = "Desk / Counter Push-Ups",
            setup = "Place hands shoulder-width on the edge of a sturdy desk or counter, step feet back.",
            move = "Lower your chest smoothly toward the edge with elbows tucked at 45°, pause briefly, and press up.",
            tip = "Make sure the surface cannot slide; keep heels lifted and body in one straight line.",
        },
        es = {
            name = "Flexiones inclinadas (mesa)",
            setup = "Apoya las manos al ancho de los hombros en una mesa firme o encimera y lleva los pies atrás.",
            move = "Baja el pecho hacia el borde con los codos a 45° respecto al cuerpo y empuja con fuerza.",
            tip = "Usa un apoyo que no resbale y mantén glúteos y abdomen firmes todo el tiempo.",
        },
    },
    {
        id = "standard_pushups", equipment = "none", category = "upper", difficulty = "intermediate", position = "floor",
        amount = 10, unit = "reps", estSeconds = 28, pose = 2,
        en = {
            name = "Push-Ups",
            setup = "Start in a high plank with hands just outside shoulder width and feet together.",
            move = "Lower your chest within a few inches of the floor, elbows angled back at 45°, then press back up.",
            tip = "Do not let your hips sag or pike up; keep your neck neutral looking slightly ahead.",
        },
        es = {
            name = "Flexiones clásicas",
            setup = "Ponte en plancha alta con manos algo más anchas que los hombros y piernas estiradas.",
            move = "Baja el pecho casi hasta tocar el suelo llevando los codos hacia atrás a 45° y sube.",
            tip = "Evita que caiga la cadera; mantén cabeza, espalda y piernas alineadas.",
        },
    },
    {
        id = "wide_pushups", equipment = "none", category = "upper", difficulty = "intermediate", position = "floor",
        amount = 10, unit = "reps", estSeconds = 28, pose = 2,
        en = {
            name = "Wide Push-Ups",
            setup = "High plank position with your hands placed noticeably wider than shoulder width.",
            move = "Bend elbows outward to lower your chest slowly toward the floor, then drive through your palms.",
            tip = "Keep your core braced and avoid flaring your shoulders up toward your ears.",
        },
        es = {
            name = "Flexiones abiertas",
            setup = "En plancha alta, coloca las manos bastante más separadas que el ancho de tus hombros.",
            move = "Baja el pecho de forma controlada abriendo los codos hacia los lados y vuelve a empujar.",
            tip = "Enfoca la fuerza en el pecho y evita encoger los hombros hacia el cuello.",
        },
    },
    {
        id = "diamond_pushups", equipment = "none", category = "upper", difficulty = "advanced", position = "floor",
        amount = 8, unit = "reps", estSeconds = 26, pose = 2,
        en = {
            name = "Diamond Push-Ups",
            setup = "High plank with thumbs and index fingers touching directly under your chest to form a diamond.",
            move = "Lower your chest slowly toward your hands keeping elbows close to your ribs, then press to lockout.",
            tip = "You can widen your feet slightly for better balance; drop to knees if form breaks.",
        },
        es = {
            name = "Flexiones diamante",
            setup = "En plancha alta, junta pulgares e índices bajo el pecho formando un triángulo o diamante.",
            move = "Baja despacio pegando los codos a las costillas hasta rozar las manos y empuja arriba.",
            tip = "Separa un poco los pies para tener más estabilidad; prioriza el control sobre la velocidad.",
        },
    },
    {
        id = "pike_pushups", equipment = "none", category = "upper", difficulty = "advanced", position = "floor",
        amount = 8, unit = "reps", estSeconds = 28, pose = 3,
        en = {
            name = "Pike Push-Ups",
            setup = "Start in a downward-dog inverted V: hips pushed high, hands and feet planted on the floor.",
            move = "Bend elbows out slightly to lower the top of your head forward between your hands, then press up.",
            tip = "Think of moving forward and down like a triangle rather than straight down between your wrists.",
        },
        es = {
            name = "Flexiones en pica",
            setup = "Forma una V invertida con la cadera bien alta, manos firmes en el suelo y talones cerca del piso.",
            move = "Flexiona los codos bajando la coronilla hacia delante de tus manos y empuja arriba con los hombros.",
            tip = "Dobla un poco las rodillas si te tiran los isquios para mantener la espalda recta.",
        },
    },
    {
        id = "knee_pushups", equipment = "none", category = "upper", difficulty = "beginner", position = "floor",
        amount = 10, unit = "reps", estSeconds = 25, pose = 2,
        en = {
            name = "Knee Push-Ups",
            setup = "Kneel on the floor, walk hands forward until there is a straight line from knees to shoulders.",
            move = "Lower your chest smoothly toward the floor with elbows at 45°, then push back up cleanly.",
            tip = "Keep your hips tucked forward (not sticking back) so your chest and core do the work.",
        },
        es = {
            name = "Flexiones de rodillas",
            setup = "Apoya rodillas y manos en el suelo formando una línea recta desde las rodillas hasta la cabeza.",
            move = "Baja el pecho hacia el suelo flexionando los codos a 45° y vuelve a empujar arriba.",
            tip = "No dejes el glúteo atrás; mantén la cadera alineada con el torso.",
        },
    },
    {
        id = "arm_circles", equipment = "none", category = "upper", difficulty = "beginner", position = "standing",
        amount = 15, unit = "seconds_each_side", estSeconds = 30, pose = 4,
        en = {
            name = "Arm Circles",
            setup = "Stand tall with feet hip-width apart and raise both straight arms out into a T shape.",
            move = "Draw medium controlled circles forward for 15 seconds, then reverse backward for 15 seconds.",
            tip = "Keep your shoulders relaxed down away from your ears and squeeze your shoulder blades gently.",
        },
        es = {
            name = "Círculos con los brazos",
            setup = "De pie con la espalda recta, extiende ambos brazos en cruz a la altura de los hombros.",
            move = "Haz círculos medianos y controlados hacia delante 15 seg y luego cambia hacia atrás otros 15 seg.",
            tip = "No subas los hombros hacia las orejas; mantén el cuello relajado.",
        },
    },
    {
        id = "front_lateral_raises_bw", equipment = "none", category = "upper", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 4,
        en = {
            name = "Controlled Arm Raises",
            setup = "Stand upright with arms hanging at your sides and chest lifted.",
            move = "Raise both arms forward to shoulder height, lower slowly, then raise them out to the sides (1 rep).",
            tip = "Move slowly without swinging your torso; pause 1 second at the top of each lift.",
        },
        es = {
            name = "Elevaciones de brazos",
            setup = "De pie, brazos relajados a los lados del cuerpo y pecho erguido.",
            move = "Sube ambos brazos al frente hasta los hombros, baja despacio y luego súbelos en cruz (1 rep).",
            tip = "Evita balancear la espalda; haz una pausa breve arriba en cada subida.",
        },
    },
    {
        id = "scapular_squeezes", equipment = "none", category = "upper", difficulty = "beginner", position = "seated",
        amount = 12, unit = "reps", estSeconds = 25, pose = 5,
        en = {
            name = "Shoulder Blade Squeezes",
            setup = "Sit or stand tall with elbows bent at 90° near your ribs and palms facing in.",
            move = "Pull your elbows slightly back and pinch your shoulder blades together for 2 seconds, then relax.",
            tip = "Imagine holding a pencil between your shoulder blades without arching your lower back.",
        },
        es = {
            name = "Retracción escapular",
            setup = "Sentado o de pie muy erguido, codos doblados a 90° pegados al cuerpo.",
            move = "Lleva los codos hacia atrás juntando los omóplatos durante 2 segundos y vuelve suave.",
            tip = "Imagina apretar un lápiz entre las escápulas sin sacar barriga ni arquear la lumbar.",
        },
    },
    {
        id = "ytw_raises", equipment = "none", category = "upper", difficulty = "intermediate", position = "standing",
        amount = 8, unit = "reps", estSeconds = 28, pose = 5,
        en = {
            name = "Standing Y-T-W Raises",
            setup = "Stand with soft knees, hinge your torso forward about 30° with a flat back, thumbs pointing up.",
            move = "Lift straight arms overhead into a Y, lower, out to a T, lower, then pull elbows back into a W.",
            tip = "Great for reversing desk posture; focus on squeezing your upper back on every letter.",
        },
        es = {
            name = "Elevaciones Y-T-W",
            setup = "Rodillas suaves, inclina el torso unos 30° hacia delante con espalda recta y pulgares arriba.",
            move = "Eleva brazos en diagonal (Y), baja, ábrelos en cruz (T), baja y encoge codos atrás formando una W.",
            tip = "Perfecto para corregir postura de ordenador; siente cómo trabaja la parte alta de la espalda.",
        },
    },
    {
        id = "wall_angels", equipment = "none", category = "upper", difficulty = "beginner", position = "standing",
        amount = 10, unit = "reps", estSeconds = 28, pose = 5,
        en = {
            name = "Wall Angels",
            setup = "Stand with heels 10 cm from a wall, press lower back, shoulders, and back of head lightly to wall.",
            move = "Place arms in a goalpost shape and slide wrists and elbows slowly up and down along the wall.",
            tip = "Only go as high as you can without your ribs flaring out or elbows popping off the wall.",
        },
        es = {
            name = "Ángeles en pared",
            setup = "Espalda apoyada en la pared con pies un paso delante, brazos doblados a 90° pegados a la pared.",
            move = "Desliza brazos y muñecas hacia arriba todo lo que puedas sin despegarlos y vuelve a bajar.",
            tip = "No despegues la zona lumbar de la pared; respira fluido durante todo el recorrido.",
        },
    },
    {
        id = "shadow_boxing", equipment = "none", category = "upper", difficulty = "beginner", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 6,
        en = {
            name = "Shadow Boxing Jabs",
            setup = "Take an athletic staggered stance, knees soft, and bring both fists up to guard your chin.",
            move = "Throw brisk alternating straight jabs and crosses forward, rotating your shoulders with each punch.",
            tip = "Exhale sharply on every punch and snap your fist right back to your guard.",
        },
        es = {
            name = "Boxeo al aire",
            setup = "Un pie ligeramente adelantado, rodillas flexionadas y puños arriba protegiendo la barbilla.",
            move = "Lanza golpes rectos alternos al frente girando ligeramente los hombros y la cadera.",
            tip = "No estires el codo de golpe hasta bloquearlo; recoge rápido el brazo tras cada golpe.",
        },
    },
    {
        id = "superman_hold", equipment = "none", category = "upper", difficulty = "intermediate", position = "floor",
        amount = 20, unit = "seconds", estSeconds = 22, pose = 7,
        en = {
            name = "Superman Back Hold",
            setup = "Lie face down on the floor with legs straight behind you and arms extended overhead.",
            move = "Simultaneously lift your chest, arms, and thighs a few inches off the floor and hold steadily.",
            tip = "Look down at the floor to keep your neck long and squeeze your glutes and upper back.",
        },
        es = {
            name = "Supermán isométrico",
            setup = "Túmbate boca abajo con brazos estirados por delante de la cabeza y piernas rectas.",
            move = "Despega a la vez pecho, brazos y piernas unos centímetros del suelo y mantén la posición.",
            tip = "Mira hacia el suelo para no forzar las cervicales y aprieta glúteos y espalda baja.",
        },
    },

    -- =========================================================================
    -- BODYWEIGHT: LOWER BODY
    -- =========================================================================
    {
        id = "bodyweight_squats", equipment = "none", category = "lower", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 8,
        en = {
            name = "Bodyweight Squats",
            setup = "Stand with feet shoulder-width apart, toes turned out slightly, arms out for balance.",
            move = "Push hips back and bend knees to lower until thighs are parallel to the floor, then drive up.",
            tip = "Keep your heels glued to the floor and push knees outward in line with your toes.",
        },
        es = {
            name = "Sentadillas sin peso",
            setup = "Pies al ancho de los hombros con puntas ligeramente hacia fuera y brazos al frente.",
            move = "Lleva la cadera atrás y abajo como si te sentaras hasta que los muslos queden paralelos y sube.",
            tip = "No levantes los talones del suelo y evita que las rodillas se metan hacia dentro.",
        },
    },
    {
        id = "sumo_squats", equipment = "none", category = "lower", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 8,
        en = {
            name = "Sumo Squats",
            setup = "Take a wide stance with feet outside shoulder width and toes pointed out at 45°.",
            move = "Keep your torso upright as you lower your hips straight down, pause 1s at the bottom, and stand.",
            tip = "Press knees out over your toes to feel a strong stretch and squeeze in inner thighs and glutes.",
        },
        es = {
            name = "Sentadilla sumo",
            setup = "Abre mucho las piernas con las puntas de los pies mirando hacia fuera a unos 45°.",
            move = "Baja recto manteniendo la espalda vertical, haz una pausa de 1s abajo y sube apretando glúteos.",
            tip = "Empuja las rodillas en dirección a los dedos de los pies; no inclines demasiado el pecho.",
        },
    },
    {
        id = "pulse_squats", equipment = "none", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 15, unit = "reps", estSeconds = 24, pose = 8,
        en = {
            name = "Pulse Squats",
            setup = "Feet shoulder-width apart, squat down to the lower half of your normal squat range.",
            move = "Perform small, controlled 10 cm up-and-down pulses without standing all the way up.",
            tip = "Keep weight centered over your heels and breathe steadily while the legs burn.",
        },
        es = {
            name = "Sentadillas con rebotes",
            setup = "Pies al ancho de hombros, baja a una sentadilla profunda y quédate en la mitad inferior.",
            move = "Haz pequeños rebotes controlados de unos 10 cm arriba y abajo sin llegar a estirar del todo.",
            tip = "Mantén la tensión constante en cuádriceps y glúteos y el peso en los talones.",
        },
    },
    {
        id = "jump_squats", equipment = "none", category = "lower", difficulty = "advanced", position = "standing",
        amount = 10, unit = "reps", estSeconds = 22, pose = 9,
        en = {
            name = "Jump Squats",
            setup = "Stand with feet shoulder-width apart, arms bent ready to swing.",
            move = "Drop into a half-squat, swing arms back, then explode upward into a jump and land softly.",
            tip = "Absorb each landing immediately by bending your knees softly into the next rep.",
        },
        es = {
            name = "Sentadillas con salto",
            setup = "Pies al ancho de los hombros y brazos listos para acompañar el impulso.",
            move = "Baja a media sentadilla, impúlsate hacia arriba con un salto explosivo y aterriza suave.",
            tip = "Amortigua la caída flexionando rodillas al instante para cuidar las articulaciones.",
        },
    },
    {
        id = "reverse_lunges", equipment = "none", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 8, unit = "reps_each_side", estSeconds = 30, pose = 10,
        en = {
            name = "Reverse Lunges",
            setup = "Stand tall with feet hip-width apart and hands on hips or in front for balance.",
            move = "Step one foot back, lower until both knees form 90° angles, then drive through the front heel to stand.",
            tip = "Keep your torso upright and stop your back knee just an inch above the floor.",
        },
        es = {
            name = "Zancadas hacia atrás",
            setup = "De pie muy erguido con pies al ancho de cadera y manos en la cintura o al frente.",
            move = "Da un paso amplio atrás, baja hasta formar 90° con ambas rodillas y empuja con el talón delantero.",
            tip = "Mantén el pecho recto sin inclinarte hacia delante; alterna piernas o completa un lado y cambia.",
        },
    },
    {
        id = "forward_lunges", equipment = "none", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 8, unit = "reps_each_side", estSeconds = 30, pose = 10,
        en = {
            name = "Forward Lunges",
            setup = "Stand tall with feet together and core lightly braced.",
            move = "Take a controlled step forward, lower hips until front thigh is parallel, then push back to start.",
            tip = "Keep your front knee stacked over your mid-foot, not collapsing inward.",
        },
        es = {
            name = "Zancadas frontales",
            setup = "De pie con pies juntos, abdomen activo y vista al frente.",
            move = "Da un paso adelante, flexiona ambas rodillas a 90° bajando vertical y empuja atrás para volver.",
            tip = "Asegúrate de dar un paso largo suficiente para que la rodilla no sobrepase en exceso la punta.",
        },
    },
    {
        id = "side_lunges", equipment = "none", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 8, unit = "reps_each_side", estSeconds = 30, pose = 11,
        en = {
            name = "Side Lunges",
            setup = "Stand tall with feet together and clear space to step wide to either side.",
            move = "Step wide to the side, sit your hips back into the stepping leg while keeping the other leg straight.",
            tip = "Keep both feet pointing forward and push off the bent leg strongly to return.",
        },
        es = {
            name = "Zancadas laterales",
            setup = "De pie con pies juntos y espacio libre a los lados para abrir el paso.",
            move = "Da un paso amplio lateral, lleva la cadera atrás flexionando esa pierna mientras la otra queda recta.",
            tip = "Mantén ambos pies mirando al frente y la espalda recta al bajar.",
        },
    },
    {
        id = "calf_raises", equipment = "none", category = "lower", difficulty = "beginner", position = "standing",
        amount = 18, unit = "reps", estSeconds = 24, pose = 12,
        en = {
            name = "Calf Raises",
            setup = "Stand upright with feet hip-width apart (touch a wall or desk lightly if you want balance).",
            move = "Rise up as high as possible onto the balls of your feet, squeeze 1 second, then lower heels slowly.",
            tip = "Avoid bouncing at the bottom; full slow lowering builds strength and ankle stability.",
        },
        es = {
            name = "Elevaciones de gemelos",
            setup = "De pie con pies al ancho de cadera (puedes rozar la mesa o pared si necesitas equilibrio).",
            move = "Sube de puntillas lo máximo posible, mantén 1 segundo arriba apretando y baja despacio.",
            tip = "No rebotes abajo; controlar la bajada durante 2 segundos multiplica el efecto.",
        },
    },
    {
        id = "single_leg_calf_raises", equipment = "none", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 10, unit = "reps_each_side", estSeconds = 28, pose = 12,
        en = {
            name = "Single-Leg Calf Raises",
            setup = "Place one hand on a wall or desk for support and lift one foot slightly off the floor.",
            move = "Press straight up onto the ball of your standing foot as high as you can, pause, then lower slowly.",
            tip = "Keep your standing knee almost straight and finish all reps on one leg before switching.",
        },
        es = {
            name = "Gemelos a una pierna",
            setup = "Apoya una mano suave en pared o mesa y deja un pie elevado detrás del otro tobillo.",
            move = "Eleva el talón de apoyo todo lo alto que puedas, aguanta arriba y baja lento hasta tocar el suelo.",
            tip = "Mantén la pierna estirada sin doblar la rodilla para aislar bien el gemelo.",
        },
    },
    {
        id = "wall_sit", equipment = "none", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 27, pose = 13,
        en = {
            name = "Wall Sit",
            setup = "Lean your back flat against a sturdy wall with feet shoulder-width and two steps ahead.",
            move = "Slide down until your knees are at 90° (thighs parallel to the floor) and hold still.",
            tip = "Do not rest your hands on your thighs; press your lower back into the wall and breathe.",
        },
        es = {
            name = "Sentadilla isométrica en pared",
            setup = "Pega toda la espalda a una pared firme con los pies adelantados unos 50 cm.",
            move = "Deslízate hacia abajo hasta formar 90° con las rodillas (muslos horizontales) y aguanta ahí.",
            tip = "No apoyes las manos sobre las piernas; mantén la respiración constante.",
        },
    },
    {
        id = "glute_bridges", equipment = "none", category = "lower", difficulty = "beginner", position = "floor",
        amount = 12, unit = "reps", estSeconds = 26, pose = 14,
        en = {
            name = "Glute Bridges",
            setup = "Lie on your back with knees bent, feet flat on the floor hip-width apart near your glutes.",
            move = "Drive through your heels to lift your hips until knees, hips, and shoulders align; squeeze 1s.",
            tip = "Push from the glutes rather than arching your lower back excessively at the top.",
        },
        es = {
            name = "Puente de glúteos",
            setup = "Boca arriba en el suelo, rodillas dobladas y pies apoyados cerca del glúteo al ancho de cadera.",
            move = "Empuja con los talones para subir la cadera hasta alinear rodillas y hombros; aprieta 1s arriba.",
            tip = "Evita arquear demasiado la espalda baja al subir; concéntrate en apretar los glúteos.",
        },
    },
    {
        id = "single_leg_glute_bridge", equipment = "none", category = "lower", difficulty = "advanced", position = "floor",
        amount = 8, unit = "reps_each_side", estSeconds = 30, pose = 14,
        en = {
            name = "Single-Leg Glute Bridge",
            setup = "Lie on your back, one foot planted flat and the other leg extended straight in the air.",
            move = "Press through the planted heel to raise your hips cleanly without twisting, then lower slowly.",
            tip = "Keep both hip bones level throughout the lift; switch legs after finishing your set.",
        },
        es = {
            name = "Puente de glúteo a una pierna",
            setup = "Boca arriba con un pie bien apoyado y la otra pierna estirada en el aire.",
            move = "Sube la cadera empujando con el talón de apoyo sin que se gire la pelvis y baja controlado.",
            tip = "Aprieta el abdomen para mantener la cadera nivelada; completa un lado y luego el otro.",
        },
    },
    {
        id = "good_mornings_bw", equipment = "none", category = "lower", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 25, pose = 15,
        en = {
            name = "Bodyweight Good Mornings",
            setup = "Stand feet hip-width apart, knees slightly bent, fingertips resting lightly behind your head.",
            move = "Push your hips straight backward keeping a flat back until torso is near 45°, then stand tall.",
            tip = "Feel the gentle stretch in your hamstrings; keep your elbows pulled wide.",
        },
        es = {
            name = "Buenos días sin peso",
            setup = "De pie con pies al ancho de cadera, rodillas apenas dobladas y manos detrás de las orejas.",
            move = "Lleva el glúteo atrás inclinando el torso recto hasta unos 45° y vuelve apretando glúteos.",
            tip = "No encorves la espalda; imagina cerrar una puerta detrás de ti con la cadera.",
        },
    },
    {
        id = "standing_hamstring_curls", equipment = "none", category = "lower", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps_each_side", estSeconds = 26, pose = 22,
        en = {
            name = "Standing Hamstring Curls",
            setup = "Stand tall with feet hip-width apart; hold a desk or wall lightly if needed.",
            move = "Keep thighs aligned and bend one knee to pull your heel briskly up toward your glute; alternate.",
            tip = "Squeeze the back of your thigh briefly at the top of each curl without swinging your hip.",
        },
        es = {
            name = "Curl femoral de pie",
            setup = "De pie erguido con pies al ancho de cadera (puedes apoyarte suave si quieres).",
            move = "Manteniendo las rodillas juntas, flexiona una pierna llevando el talón hacia el glúteo y alterna.",
            tip = "Aprieta la parte posterior del muslo arriba sin adelantar la rodilla.",
        },
    },
    {
        id = "seated_leg_extensions", equipment = "none", category = "lower", difficulty = "beginner", position = "seated",
        amount = 10, unit = "reps_each_side", estSeconds = 24, pose = 13,
        en = {
            name = "Seated Knee Extensions",
            setup = "Sit tall toward the front of your chair with your back straight and feet flat.",
            move = "Straighten one leg fully out in front of you, flex your thigh muscle hard for 1s, then lower.",
            tip = "Keep your torso upright instead of leaning back as you lift your foot.",
        },
        es = {
            name = "Extensiones de rodilla sentado",
            setup = "Siéntate erguido en tu silla con la espalda recta y los pies apoyados.",
            move = "Estira una pierna al frente por completo, aprieta fuerte el muslo 1 segundo y baja despacio.",
            tip = "No te eches hacia atrás al levantar la pierna; hazlo sin dejar caer el pie de golpe.",
        },
    },
    {
        id = "quick_squat_finish", equipment = "none", category = "lower", difficulty = "beginner", position = "standing",
        amount = 6, unit = "reps", estSeconds = 13, pose = 8,
        en = {
            name = "Quick Half-Squats",
            setup = "Stand quickly beside your chair with feet shoulder-width apart.",
            move = "Perform 6 crisp, controlled half-squats to wake up your legs on short flights.",
            tip = "Keep heels flat and stand tall between each rep.",
        },
        es = {
            name = "Medias sentadillas rápidas",
            setup = "Levántate junto a la silla con los pies al ancho de los hombros.",
            move = "Haz 6 medias sentadillas fluidas y limpias para activar las piernas en vuelos cortos.",
            tip = "Talones pegados al suelo y espalda recta en todo momento.",
        },
    },

    -- =========================================================================
    -- BODYWEIGHT: CORE
    -- =========================================================================
    {
        id = "forearm_plank", equipment = "none", category = "core", difficulty = "intermediate", position = "floor",
        amount = 25, unit = "seconds", estSeconds = 27, pose = 16,
        en = {
            name = "Forearm Plank",
            setup = "Rest on your forearms with elbows directly under shoulders and toes planted hip-width apart.",
            move = "Lift knees so your body forms a straight line from head to heels, bracing abs and glutes.",
            tip = "Breathe steadily; if your lower back starts sagging, drop to your knees or stop cleanly.",
        },
        es = {
            name = "Plancha abdominal",
            setup = "Apoya los antebrazos con los codos justo debajo de los hombros y las punteras atrás.",
            move = "Despega las rodillas formando una tabla recta de cabeza a talones apretando abdomen y glúteos.",
            tip = "No aguantes la respiración y evita que la cadera se hunda hacia el suelo.",
        },
    },
    {
        id = "plank_shoulder_taps", equipment = "none", category = "core", difficulty = "intermediate", position = "floor",
        amount = 10, unit = "reps_each_side", estSeconds = 28, pose = 16,
        en = {
            name = "Plank Shoulder Taps",
            setup = "High plank on straight arms with feet set slightly wider than hip-width for stability.",
            move = "Lift one hand slowly to tap the opposite shoulder, place it down, and alternate sides.",
            tip = "Imagine balancing a cup of water on your lower back—minimize hip sway!",
        },
        es = {
            name = "Toques de hombro en plancha",
            setup = "En plancha alta con brazos estirados, separa los pies un poco más del ancho de cadera.",
            move = "Lleva una mano despacio a tocar el hombro contrario, vuelve a apoyar y alterna lados.",
            tip = "Aprieta el abdomen para que la cadera no se balancee de lado a lado.",
        },
    },
    {
        id = "side_plank_hold", equipment = "none", category = "core", difficulty = "intermediate", position = "floor",
        amount = 15, unit = "seconds_each_side", estSeconds = 32, pose = 17,
        en = {
            name = "Side Plank",
            setup = "Lie on your side, prop up on your forearm with elbow right under your shoulder, feet stacked.",
            move = "Lift hips off the floor into a straight diagonal line for 15s, then switch to the other side.",
            tip = "Keep your chest open forward and bend your bottom knee for support if needed.",
        },
        es = {
            name = "Plancha lateral",
            setup = "De lado sobre un antebrazo (codo bajo el hombro) con piernas estiradas una sobre otra.",
            move = "Eleva la cadera formando una línea recta durante 15 seg y luego cambia al otro lado.",
            tip = "No dejes caer la cadera ni gires el hombro hacia el suelo; apoya la rodilla si lo necesitas.",
        },
    },
    {
        id = "dead_bug", equipment = "none", category = "core", difficulty = "beginner", position = "floor",
        amount = 8, unit = "reps_each_side", estSeconds = 28, pose = 18,
        en = {
            name = "Dead Bug",
            setup = "Lie on your back, arms reaching straight up and knees bent at 90° above your hips.",
            move = "Slowly lower your right arm overhead and straighten your left leg toward the floor, then switch.",
            tip = "Press your lower back gently into the floor the entire time—don't let it arch!",
        },
        es = {
            name = "Bicho muerto (Dead Bug)",
            setup = "Boca arriba, brazos estirados al techo y rodillas dobladas a 90° sobre la cadera.",
            move = "Extiende a la vez un brazo atrás y la pierna contraria al ras del suelo, vuelve y alterna.",
            tip = "Mantén la zona lumbar pegada al suelo en todo momento sin dejar hueco debajo.",
        },
    },
    {
        id = "bird_dog", equipment = "none", category = "core", difficulty = "beginner", position = "floor",
        amount = 8, unit = "reps_each_side", estSeconds = 28, pose = 19,
        en = {
            name = "Bird Dog",
            setup = "Get on hands and knees with wrists under shoulders and knees under hips.",
            move = "Extend one arm forward and the opposite leg straight back until parallel to floor, pause, alternate.",
            tip = "Reach long rather than kicking high so your lower back stays flat and steady.",
        },
        es = {
            name = "Perro-pájaro (Bird Dog)",
            setup = "A cuatro patas con manos debajo de los hombros y rodillas debajo de la cadera.",
            move = "Estira un brazo al frente y la pierna opuesta atrás hasta quedar horizontales, aguanta 1s y alterna.",
            tip = "Alarga el cuerpo en vez de subir la pierna demasiado para no arquear ni girar la cadera.",
        },
    },
    {
        id = "bicycle_crunches", equipment = "none", category = "core", difficulty = "intermediate", position = "floor",
        amount = 12, unit = "reps_each_side", estSeconds = 28, pose = 20,
        en = {
            name = "Bicycle Crunches",
            setup = "Lie on your back, fingertips lightly behind your ears, shoulders lifted slightly, knees up.",
            move = "Rotate your right shoulder toward your left knee while extending your right leg; alternate smoothly.",
            tip = "Lead the twist with your ribcage rather than pulling your neck forward with your hands.",
        },
        es = {
            name = "Abdominales bicicleta",
            setup = "Boca arriba, manos suaves tras las orejas, hombros un poco elevados y piernas en el aire.",
            move = "Gira el torso llevando un hombro hacia la rodilla contraria mientras estiras la otra pierna.",
            tip = "Gira desde las costillas sin tirar del cuello con las manos; ritmo lento y controlado.",
        },
    },
    {
        id = "russian_twists_bw", equipment = "none", category = "core", difficulty = "intermediate", position = "floor",
        amount = 12, unit = "reps_each_side", estSeconds = 25, pose = 20,
        en = {
            name = "Russian Twists",
            setup = "Sit with knees bent and heels on the floor, lean torso back slightly with chest proud.",
            move = "Clasp hands in front and rotate your torso smoothly from side to side tapping near each hip.",
            tip = "Keep your spine long rather than rounded; lift heels slightly for extra challenge.",
        },
        es = {
            name = "Giros rusos",
            setup = "Sentado con rodillas dobladas y talones en el suelo, inclina la espalda recta un poco atrás.",
            move = "Manos juntas al frente, gira el torso de lado a lado tocando cerca de cada cadera.",
            tip = "Saca pecho para no redondear la espalda; levanta ligeramente los pies si quieres más reto.",
        },
    },
    {
        id = "standing_knee_to_elbow", equipment = "none", category = "core", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps_each_side", estSeconds = 26, pose = 22,
        en = {
            name = "Standing Cross-Body Crunches",
            setup = "Stand tall with feet hip-width apart and fingertips lightly behind your head.",
            move = "Drive one knee up across your body while crunching the opposite elbow toward it; alternate.",
            tip = "Squeeze your abs hard as knee and elbow meet without rounding your neck.",
        },
        es = {
            name = "Abdominales cruzados de pie",
            setup = "De pie con pies al ancho de cadera y manos detrás de la cabeza con codos abiertos.",
            move = "Sube una rodilla hacia el pecho mientras giras para acercar el codo contrario y alterna.",
            tip = "Contrae el abdomen al juntar codo y rodilla manteniendo el ritmo firme.",
        },
    },
    {
        id = "seated_knee_tucks", equipment = "none", category = "core", difficulty = "beginner", position = "seated",
        amount = 14, unit = "reps", estSeconds = 24, pose = 20,
        en = {
            name = "Seated Core Knee Lifts",
            setup = "Sit near the front edge of your chair, hold the sides lightly, and lean back slightly.",
            move = "Brace your core and lift both knees up toward your chest together, then lower gently.",
            tip = "Exhale as you lift your knees and avoid letting your feet slam back to the floor.",
        },
        es = {
            name = "Elevación de rodillas sentado",
            setup = "Siéntate en el borde de la silla, agárrate a los lados e inclina la espalda ligeramente atrás.",
            move = "Activa el abdomen para subir ambas rodillas juntas hacia el pecho y baja sin golpear.",
            tip = "Suelta el aire al subir las rodillas y mantén el control en la bajada.",
        },
    },
    {
        id = "hollow_hold", equipment = "none", category = "core", difficulty = "advanced", position = "floor",
        amount = 20, unit = "seconds", estSeconds = 22, pose = 18,
        en = {
            name = "Hollow Body Hold",
            setup = "Lie flat on your back, reach arms straight overhead and squeeze legs together.",
            move = "Press your lower back firmly into the floor, then lift shoulder blades and legs a few inches.",
            tip = "Bend knees slightly if your lower back lifts off the floor; breathe steadily.",
        },
        es = {
            name = "Hollow Hold (barca)",
            setup = "Boca arriba, brazos estirados detrás de la cabeza y piernas juntas y rectas.",
            move = "Pega la lumbar al suelo y despega unos centímetros los hombros y las piernas manteniendo la postura.",
            tip = "Si notas que se despega la lumbar del suelo, sube un poco más las piernas o dobla rodillas.",
        },
    },

    -- =========================================================================
    -- BODYWEIGHT: CARDIO
    -- =========================================================================
    {
        id = "jumping_jacks", equipment = "none", category = "cardio", difficulty = "beginner", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 21,
        en = {
            name = "Jumping Jacks",
            setup = "Stand tall with feet together and arms resting at your sides.",
            move = "Jump feet wide while sweeping arms overhead, then jump back together at a steady rhythm.",
            tip = "Land lightly on the balls of your feet with soft knees.",
        },
        es = {
            name = "Saltos de tijera (Jumping Jacks)",
            setup = "De pie con pies juntos y brazos pegados a los lados del cuerpo.",
            move = "Salta abriendo piernas mientras subes brazos sobre la cabeza y vuelve a cerrar con ritmo.",
            tip = "Aterriza suave sobre la punta de los pies con rodillas ligeramente flexionadas.",
        },
    },
    {
        id = "high_knees", equipment = "none", category = "cardio", difficulty = "intermediate", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 22,
        en = {
            name = "High Knees",
            setup = "Stand tall with feet hip-width apart and elbows bent at 90° at your sides.",
            move = "Run briskly in place, driving each knee up to hip height while pumping your arms.",
            tip = "Stay tall through your torso instead of leaning backward as knees come up.",
        },
        es = {
            name = "Rodillas al pecho (Skipping)",
            setup = "De pie con cuerpo erguido y codos doblados a 90° listos para bracear.",
            move = "Corre en el sitio subiendo cada rodilla hasta la altura de la cadera con ritmo ágil.",
            tip = "Aterriza suave en las punteras y no inclines el torso hacia atrás.",
        },
    },
    {
        id = "march_in_place", equipment = "none", category = "cardio", difficulty = "beginner", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 22,
        en = {
            name = "Brisk March in Place",
            setup = "Stand tall with feet hip-width apart and shoulders relaxed.",
            move = "March energetically in place, lifting knees comfortably high and swinging opposite arms.",
            tip = "Zero-impact way to boost circulation; pick up the pace if you want more cardio.",
        },
        es = {
            name = "Marcha enérgica en el sitio",
            setup = "De pie con postura alta, hombros relajados y abdomen ligeramente activo.",
            move = "Marcha en el sitio levantando rodillas con decisión y moviendo los brazos contrarios.",
            tip = "Excelente cardio sin impacto; aumenta la velocidad si quieres subir pulsaciones.",
        },
    },
    {
        id = "skaters", equipment = "none", category = "cardio", difficulty = "intermediate", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 11,
        en = {
            name = "Speed Skaters",
            setup = "Stand with knees slightly bent and clear space to step or hop laterally.",
            move = "Leap softly to the right, tucking left foot behind you, then bound smoothly to the left.",
            tip = "Swing your arms across your body like a speed skater and absorb each landing softly.",
        },
        es = {
            name = "Patinadores laterales",
            setup = "Rodillas semiflexionadas con algo de espacio libre hacia ambos lados.",
            move = "Salta suave hacia un lado apoyando ese pie y cruzando el otro detrás, y cambia de lado.",
            tip = "Acompaña con los brazos como un patinador y amortigua suave con la rodilla.",
        },
    },
    {
        id = "mountain_climbers", equipment = "none", category = "cardio", difficulty = "intermediate", position = "floor",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 23,
        en = {
            name = "Mountain Climbers",
            setup = "Start in a strong high plank with hands stacked directly under your shoulders.",
            move = "Drive one knee rapidly toward your chest, then switch legs in a smooth running motion.",
            tip = "Keep your hips low and steady—don't bounce your glutes up into the air.",
        },
        es = {
            name = "Escaladores (Mountain Climbers)",
            setup = "Colócate en plancha alta con las manos justo debajo de los hombros.",
            move = "Lleva una rodilla rápido hacia el pecho y alterna las piernas como corriendo en horizontal.",
            tip = "Mantén la cadera baja y estable sin levantar demasiado el glúteo.",
        },
    },
    {
        id = "burpees_no_pushup", equipment = "none", category = "cardio", difficulty = "advanced", position = "standing",
        amount = 8, unit = "reps", estSeconds = 28, pose = 9,
        en = {
            name = "Athletic Burpees",
            setup = "Stand with feet shoulder-width apart and clear space behind you.",
            move = "Squat down to plant hands, hop feet back to plank, hop feet forward, and stand or jump tall.",
            tip = "Step back one foot at a time instead of jumping if you want a smoother, quieter pace.",
        },
        es = {
            name = "Burpees atléticos",
            setup = "De pie con pies al ancho de hombros y espacio detrás para estirar las piernas.",
            move = "Agáchate apoyando manos, salta atrás a plancha, vuelve a recoger pies y sube de pie o con salto.",
            tip = "Puedes dar pasos atrás y adelante en vez de saltar si quieres menos impacto.",
        },
    },
    {
        id = "butt_kicks", equipment = "none", category = "cardio", difficulty = "beginner", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 22,
        en = {
            name = "Butt Kicks",
            setup = "Stand upright with feet hip-width apart and arms relaxed at your sides.",
            move = "Jog lightly in place, snapping each heel up behind you toward your glutes.",
            tip = "Keep knees pointing down toward the floor and stay light on your toes.",
        },
        es = {
            name = "Talones al glúteo",
            setup = "De pie con espalda recta y brazos cómodos a los lados.",
            move = "Trota suave en el sitio llevando alternativamente cada talón hacia el glúteo.",
            tip = "Mantén las rodillas apuntando abajo y cae suave sobre la punta del pie.",
        },
    },

    -- =========================================================================
    -- BODYWEIGHT: MOBILITY / DESK RECOVERY
    -- =========================================================================
    {
        id = "wrist_stretches", equipment = "none", category = "mobility", difficulty = "beginner", position = "seated",
        amount = 15, unit = "seconds_each_side", estSeconds = 30, pose = 24,
        en = {
            name = "Gamer Wrist & Forearm Stretch",
            setup = "Extend one arm straight out in front of you at shoulder height, palm facing forward.",
            move = "With your other hand, gently pull your fingers back toward you for 15s, then switch hands.",
            tip = "Stretch only to mild tension, never pain—ideal after long mouse & keyboard sessions.",
        },
        es = {
            name = "Estiramiento de muñecas",
            setup = "Estira un brazo completamente al frente con la palma mirando hacia delante.",
            move = "Con la otra mano tira suavemente de los dedos hacia atrás 15 seg y luego cambia de brazo.",
            tip = "Busca tensión agradable sin dolor; alivia mucho tras ratón y teclado.",
        },
    },
    {
        id = "thoracic_rotations", equipment = "none", category = "mobility", difficulty = "beginner", position = "standing",
        amount = 8, unit = "reps_each_side", estSeconds = 24, pose = 6,
        en = {
            name = "Standing Trunk Twists",
            setup = "Stand with feet shoulder-width apart, knees soft, and hands across your chest or hips.",
            move = "Keep your hips facing forward while gently rotating your upper back and shoulders left and right.",
            tip = "Move slowly and exhale as you turn into each side to release upper-back stiffness.",
        },
        es = {
            name = "Rotaciones torácicas de pie",
            setup = "De pie con pies al ancho de hombros, rodillas suaves y manos cruzadas en el pecho.",
            move = "Deja la cadera mirando al frente y gira suavemente el torso y los hombros a izquierda y derecha.",
            tip = "Haz el giro lento soltando el aire al rotar para destensar la espalda.",
        },
    },
    {
        id = "neck_shoulder_reset", equipment = "none", category = "mobility", difficulty = "beginner", position = "seated",
        amount = 12, unit = "reps_each_dir", estSeconds = 22, pose = 4,
        en = {
            name = "Shoulder Rolls & Neck Reset",
            setup = "Sit or stand tall with arms hanging loose and chin slightly tucked.",
            move = "Make big slow shoulder circles backward 12 times, then forward 12 times, letting them drop.",
            tip = "Keep your jaw relaxed and drop your shoulders away from your ears at the end.",
        },
        es = {
            name = "Rotación de hombros y cuello",
            setup = "Sentado o de pie muy erguido, brazos sueltos a los lados y mirada al frente.",
            move = "Haz círculos amplios y lentos con ambos hombros 12 veces atrás y 12 veces hacia delante.",
            tip = "Al terminar, deja caer los hombros abajo lejos de las orejas y relaja la mandíbula.",
        },
    },
    {
        id = "chest_doorway_opener", equipment = "none", category = "mobility", difficulty = "beginner", position = "standing",
        amount = 20, unit = "seconds", estSeconds = 20, pose = 5,
        en = {
            name = "Chest & Posture Opener",
            setup = "Stand tall and interlace your fingers behind your lower back (or hold a towel/shirt).",
            move = "Gently straighten your arms and pull your shoulder blades together while lifting your chest.",
            tip = "Breathe deeply into your ribcage and keep your ribs tucked down instead of arching.",
        },
        es = {
            name = "Apertura de pecho y postura",
            setup = "De pie con postura alta, entrelaza las manos detrás de la espalda baja.",
            move = "Estira suave los brazos hacia atrás abriendo el pecho y juntando los omóplatos durante 20 seg.",
            tip = "Respira profundo sintiendo cómo se estira el pecho sin sacar demasiado la barriga.",
        },
    },
    {
        id = "standing_side_stretch", equipment = "none", category = "mobility", difficulty = "beginner", position = "standing",
        amount = 12, unit = "seconds_each_side", estSeconds = 24, pose = 25,
        en = {
            name = "Overhead Side Reach",
            setup = "Stand with feet hip-width apart and reach your right arm straight up toward the ceiling.",
            move = "Lean gently to your left side creating a long arc down your right ribs; hold 12s and switch.",
            tip = "Reach upward first before leaning sideways so you don't crunch your lower back.",
        },
        es = {
            name = "Estiramiento lateral",
            setup = "De pie con pies al ancho de cadera, estira un brazo bien alto hacia el techo.",
            move = "Inclínate suavemente hacia el lado contrario alargando el costado; aguanta 12s y cambia.",
            tip = "Piensa en crecer hacia arriba antes de inclinarte de lado para estirar mejor.",
        },
    },
    {
        id = "standing_calf_stretch", equipment = "none", category = "mobility", difficulty = "beginner", position = "standing",
        amount = 15, unit = "seconds_each_side", estSeconds = 30, pose = 10,
        en = {
            name = "Standing Calf Stretch",
            setup = "Step one foot back 50 cm, place hands lightly on a desk or wall, both toes pointing forward.",
            move = "Keep your back leg straight with the heel pressed flat into the floor and bend the front knee.",
            tip = "Hold calmly for 15s until you feel a comfortable stretch along the back calf, then switch.",
        },
        es = {
            name = "Estiramiento de gemelos",
            setup = "Da un paso atrás con un pie dejando ambos mirando al frente; apoya manos en mesa o pared.",
            move = "Mantén la pierna trasera estirada con el talón pegado al suelo mientras doblas la delantera.",
            tip = "Aguanta 15 seg por pierna sin hacer rebotes hasta notar un estiramiento cómodo.",
        },
    },
    {
        id = "quick_deep_breaths", equipment = "none", category = "mobility", difficulty = "beginner", position = "seated",
        amount = 15, unit = "seconds", estSeconds = 15, pose = 25,
        en = {
            name = "Posture & Breath Reset",
            setup = "Sit upright away from the backrest, feet flat, hands resting comfortably on your thighs.",
            move = "Inhale slowly through your nose for 4 seconds, pause 1s, and exhale smoothly for 5 seconds.",
            tip = "Great quick reset between flights to lower shoulder tension and clear your head.",
        },
        es = {
            name = "Respiración y postura",
            setup = "Siéntate recto despegado del respaldo, pies en el suelo y manos relajadas en los muslos.",
            move = "Inhala lento por la nariz en 4 segundos, aguanta 1s y suelta el aire despacio en 5 segundos.",
            tip = "Ideal para vuelos cortos: relaja hombros y despeja la mente en segundos.",
        },
    },

    -- =========================================================================
    -- DUMBBELLS: UPPER BODY
    -- =========================================================================
    {
        id = "db_bicep_curls", equipment = "dumbbells", category = "upper", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 26,
        en = {
            name = "Dumbbell Bicep Curls",
            setup = "Stand tall holding a dumbbell in each hand at your sides, palms facing forward, elbows tucked.",
            move = "Curl both weights smoothly toward your shoulders without moving your elbows, then lower in 2s.",
            tip = "Keep your back completely still—no swinging your hips to help lift the weights.",
        },
        es = {
            name = "Curl de bíceps con mancuernas",
            setup = "De pie muy recto con una mancuerna en cada mano, palmas al frente y codos pegados a las costillas.",
            move = "Sube ambas mancuernas hacia los hombros doblando solo los codos y baja controlado en 2 seg.",
            tip = "No balancees la espalda para impulsarte; si te cuesta, alterna un brazo cada vez.",
        },
    },
    {
        id = "db_hammer_curls", equipment = "dumbbells", category = "upper", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 26,
        en = {
            name = "Hammer Curls",
            setup = "Hold dumbbells at your sides with palms facing inward toward your thighs (neutral grip).",
            move = "Keeping thumbs pointed up, curl the weights smoothly to shoulder height, then lower slowly.",
            tip = "Keep your wrists straight and elbows pinned near your ribs on every rep.",
        },
        es = {
            name = "Curl martillo",
            setup = "Mancuernas a los lados con las palmas mirando hacia los muslos (agarre neutro).",
            move = "Sube las mancuernas con los pulgares arriba hacia los hombros y baja despacio sin soltarlas.",
            tip = "Mantén las muñecas rectas y los codos fijos; trabaja bíceps y antebrazo.",
        },
    },
    {
        id = "db_overhead_press", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "standing",
        amount = 10, unit = "reps", estSeconds = 26, pose = 27,
        en = {
            name = "Dumbbell Overhead Press",
            setup = "Stand feet shoulder-width apart, hold dumbbells just above shoulders with palms facing forward.",
            move = "Brace your abs and glutes, press both dumbbells straight overhead until arms are extended, lower.",
            tip = "Keep your ribcage down so your lower back does not arch as you press overhead.",
        },
        es = {
            name = "Press militar con mancuernas",
            setup = "De pie con pies al ancho de hombros, mancuernas a la altura de los hombros y palmas al frente.",
            move = "Aprieta abdomen y glúteos, empuja ambas mancuernas recto hacia el techo y baja controlado.",
            tip = "No arquees la lumbar al subir; exhala al empujar arriba.",
        },
    },
    {
        id = "db_arnold_press", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "seated",
        amount = 10, unit = "reps", estSeconds = 28, pose = 27,
        en = {
            name = "Seated Arnold Press",
            setup = "Sit upright holding dumbbells in front of your chest with palms facing toward you.",
            move = "As you press overhead, rotate your wrists smoothly so palms face forward at the top; reverse down.",
            tip = "Control the rotation on both the way up and the way down to engage all shoulder heads.",
        },
        es = {
            name = "Press Arnold sentado",
            setup = "Sentado con espalda recta, sujeta las mancuernas delante del pecho con palmas hacia ti.",
            move = "Al empujar arriba gira las muñecas hasta que las palmas miren al frente; deshaz el giro al bajar.",
            tip = "Movimiento fluido y controlado para trabajar todo el hombro de forma completa.",
        },
    },
    {
        id = "db_lateral_raises", equipment = "dumbbells", category = "upper", difficulty = "beginner", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 29,
        en = {
            name = "Dumbbell Lateral Raises",
            setup = "Stand tall holding dumbbells at your sides with a very slight bend in your elbows.",
            move = "Lift both arms out to the sides until they reach shoulder height, pause briefly, lower slowly.",
            tip = "Lead with your elbows and pinkies slightly up; don't shrug your traps up toward your neck.",
        },
        es = {
            name = "Elevaciones laterales",
            setup = "De pie con mancuernas a los lados y los codos apenas flexionados.",
            move = "Sube los brazos en cruz hasta la altura de los hombros, aguanta un instante y baja despacio.",
            tip = "Guía la subida con los codos y evita encoger el cuello o usar impulso.",
        },
    },
    {
        id = "db_front_raises", equipment = "dumbbells", category = "upper", difficulty = "beginner", position = "standing",
        amount = 10, unit = "reps_each_side", estSeconds = 28, pose = 29,
        en = {
            name = "Alternating Front Raises",
            setup = "Stand feet hip-width apart holding dumbbells in front of your thighs, palms facing back.",
            move = "Raise one straight arm forward to shoulder height, lower with control, then lift the other arm.",
            tip = "Keep your torso steady and avoid leaning backward to swing the dumbbell up.",
        },
        es = {
            name = "Elevaciones frontales alternas",
            setup = "De pie con mancuernas apoyadas delante de los muslos y palmas mirando hacia ti.",
            move = "Sube un brazo al frente hasta la altura del hombro, baja controlado y alterna con el otro.",
            tip = "No te eches hacia atrás al subir la mancuerna; abdomen firme.",
        },
    },
    {
        id = "db_bent_over_row", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 28, pose = 28,
        en = {
            name = "Dumbbell Bent-Over Rows",
            setup = "Soft knees, hinge hips back 45° keeping your spine straight, arms hanging below shoulders.",
            move = "Pull both dumbbells back toward your hips while squeezing shoulder blades together, then lower.",
            tip = "Keep your chest proud and back flat—never round your lower back.",
        },
        es = {
            name = "Remo inclinado con mancuernas",
            setup = "Rodillas suaves, inclina el torso a 45° con la espalda recta y brazos colgando.",
            move = "Tira de las mancuernas hacia la cadera pegando los codos atrás y juntando omóplatos; baja lento.",
            tip = "Mira un punto fijo en el suelo para mantener cuello y espalda bien rectos.",
        },
    },
    {
        id = "db_reverse_fly", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 28,
        en = {
            name = "Dumbbell Reverse Fly",
            setup = "Hinge forward 45° with flat back, dumbbells hanging together beneath your chest, palms facing in.",
            move = "With soft elbows, sweep both arms wide out to the sides squeezing rear shoulders, then lower.",
            tip = "Use light weights and avoid jerking your torso upward with momentum.",
        },
        es = {
            name = "Pájaros con mancuernas",
            setup = "Torso inclinado 45° con espalda recta, mancuernas juntas bajo el pecho y codos suaves.",
            move = "Abre los brazos en cruz hacia los lados apretando la parte trasera del hombro y baja lento.",
            tip = "Mejor con poco peso y técnica limpia sin levantar la espalda al subir.",
        },
    },
    {
        id = "db_overhead_tricep_ext", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 27,
        en = {
            name = "Overhead Tricep Extension",
            setup = "Stand tall holding one dumbbell vertically with both hands under the top plate overhead.",
            move = "Keep upper arms pointed up near your ears, bend elbows to lower the weight behind your head, extend.",
            tip = "Keep elbows pointed forward rather than flaring wide; brace your abs.",
        },
        es = {
            name = "Extensión de tríceps sobre cabeza",
            setup = "Sujeta una mancuerna vertical con ambas manos por encima de la cabeza.",
            move = "Sin abrir los codos, flexiónalos para bajar la mancuerna detrás de la nuca y estira arriba.",
            tip = "Mantén los codos apuntando hacia arriba y el abdomen apretado para no arquear la espalda.",
        },
    },
    {
        id = "db_tricep_kickbacks", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 26, pose = 28,
        en = {
            name = "Tricep Kickbacks",
            setup = "Hinge forward slightly with flat back, pull elbows up beside your ribs at 90°.",
            move = "Pin upper arms completely still and straighten forearms straight back, squeezing triceps 1s.",
            tip = "Only the forearm moves from the elbow; pause at full extension.",
        },
        es = {
            name = "Patada de tríceps",
            setup = "Inclina el torso con espalda recta y sube los codos pegados a los costados a 90°.",
            move = "Manteniendo los codos fijos arriba, estira los antebrazos hacia atrás apretando el tríceps 1s.",
            tip = "Solo se mueve el antebrazo desde el codo; controla la vuelta sin balanceo.",
        },
    },
    {
        id = "db_floor_press", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "floor",
        amount = 12, unit = "reps", estSeconds = 28, pose = 14,
        en = {
            name = "Dumbbell Floor Press",
            setup = "Lie on your back with knees bent, hold dumbbells over your chest with elbows angled at 45°.",
            move = "Press dumbbells straight up until arms extend, lower smoothly until upper arms touch the floor.",
            tip = "Pause briefly when your triceps tap the floor rather than bouncing off it.",
        },
        es = {
            name = "Press de pecho en el suelo",
            setup = "Boca arriba con rodillas dobladas y pies apoyados; mancuernas sobre el pecho.",
            move = "Empuja ambas mancuernas al techo y baja despacio hasta que los codos rocen el suelo a 45°.",
            tip = "Haz una micro-pausa al tocar el suelo con los brazos sin rebotar.",
        },
    },
    {
        id = "db_shrugs", equipment = "dumbbells", category = "upper", difficulty = "beginner", position = "standing",
        amount = 15, unit = "reps", estSeconds = 24, pose = 31,
        en = {
            name = "Dumbbell Shrugs",
            setup = "Stand tall holding dumbbells at your sides with arms relaxed and straight.",
            move = "Shrug your shoulders straight up toward your ears, hold 1 full second, then lower completely.",
            tip = "Move straight up and down—don't roll your shoulders forward or backward.",
        },
        es = {
            name = "Encogimientos de trapecio",
            setup = "De pie con una mancuerna en cada mano y brazos completamente estirados a los lados.",
            move = "Sube los hombros recto hacia las orejas, mantén 1 segundo apretando y baja del todo.",
            tip = "Sube y baja en línea vertical sin hacer giros circulares con los hombros.",
        },
    },
    {
        id = "db_upright_row", equipment = "dumbbells", category = "upper", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 25, pose = 27,
        en = {
            name = "Dumbbell Upright Row",
            setup = "Stand tall holding dumbbells in front of your thighs, palms facing your body.",
            move = "Pull elbows up and outward to bring dumbbells up to chest level, pause, and lower slowly.",
            tip = "Stop at chest height so shoulders stay comfortable; elbows always stay higher than wrists.",
        },
        es = {
            name = "Remo al mentón",
            setup = "De pie con mancuernas delante de los muslos y palmas mirando hacia ti.",
            move = "Lleva los codos hacia arriba y afuera subiendo las mancuernas pegadas al cuerpo hasta el pecho.",
            tip = "Los codos deben ir siempre más altos que las muñecas; para a la altura del pecho.",
        },
    },
    {
        id = "db_curl_to_press", equipment = "dumbbells", category = "upper", difficulty = "advanced", position = "standing",
        amount = 10, unit = "reps", estSeconds = 30, pose = 27,
        en = {
            name = "Curl to Overhead Press",
            setup = "Stand feet shoulder-width apart holding dumbbells at your sides, palms forward.",
            move = "Curl weights up to your shoulders, then smoothly press them overhead, and reverse back down.",
            tip = "Keep your core tight during the transition from curl to press so your back stays neutral.",
        },
        es = {
            name = "Curl + Press de hombros",
            setup = "De pie con mancuernas a los lados y palmas hacia delante.",
            move = "Haz un curl de bíceps hasta los hombros, empuja recto arriba y baja siguiendo el mismo camino.",
            tip = "Controla la transición en los hombros apretando el abdomen.",
        },
    },

    -- =========================================================================
    -- DUMBBELLS: LOWER BODY & FULL BODY
    -- =========================================================================
    {
        id = "db_goblet_squat", equipment = "dumbbells", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 28, pose = 30,
        en = {
            name = "Goblet Squat",
            setup = "Hold one dumbbell vertically cupped against your chest with both hands, feet shoulder-width.",
            move = "Sit hips back and down keeping chest tall until elbows pass inside your knees, then drive up.",
            tip = "Keep the dumbbell touching your chest throughout and push through your full foot.",
        },
        es = {
            name = "Sentadilla Goblet",
            setup = "Sujeta una mancuerna vertical pegada al pecho con ambas manos y pies al ancho de hombros.",
            move = "Baja en sentadilla profunda metiendo los codos entre las rodillas con pecho alto y empuja arriba.",
            tip = "No separes la mancuerna del pecho y mantén los talones pegados al suelo.",
        },
    },
    {
        id = "db_rdl", equipment = "dumbbells", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 28, pose = 15,
        en = {
            name = "Dumbbell Romanian Deadlift",
            setup = "Stand feet hip-width apart, soft knees, dumbbells resting in front of your thighs.",
            move = "Push hips backward sliding dumbbells down your shins with a flat back, then squeeze glutes up.",
            tip = "Stop as soon as your hips stop moving backward—feel the stretch in your hamstrings, not low back.",
        },
        es = {
            name = "Peso muerto rumano",
            setup = "Pies al ancho de cadera, rodillas apenas dobladas y mancuernas delante de los muslos.",
            move = "Empuja la cadera atrás deslizando las mancuernas pegadas a las piernas hasta media espinilla y sube.",
            tip = "Espalda completamente recta todo el tiempo; la fuerza al subir nace de glúteos e isquios.",
        },
    },
    {
        id = "db_reverse_lunges", equipment = "dumbbells", category = "lower", difficulty = "advanced", position = "standing",
        amount = 8, unit = "reps_each_side", estSeconds = 32, pose = 10,
        en = {
            name = "Dumbbell Reverse Lunges",
            setup = "Stand tall holding a dumbbell in each hand down at your sides.",
            move = "Step back cleanly into a 90° lunge keeping weights steady at your sides, drive through front heel.",
            tip = "Keep your torso tall and avoid letting the dumbbells swing forward or back.",
        },
        es = {
            name = "Zancadas atrás con mancuernas",
            setup = "De pie muy erguido sosteniendo una mancuerna a cada lado del cuerpo.",
            move = "Da un paso atrás bajando ambas rodillas a 90° sin balancear las pesas y empuja arriba.",
            tip = "Carga el peso en la pierna delantera para subir; respira fluido.",
        },
    },
    {
        id = "db_calf_raises", equipment = "dumbbells", category = "lower", difficulty = "beginner", position = "standing",
        amount = 16, unit = "reps", estSeconds = 24, pose = 12,
        en = {
            name = "Weighted Calf Raises",
            setup = "Stand feet hip-width apart holding dumbbells firmly down at your sides.",
            move = "Rise slowly onto your tiptoes as high as possible, pause 1 second at top, lower gently.",
            tip = "Keep ankles straight rather than rolling onto your outer toes.",
        },
        es = {
            name = "Gemelos con mancuernas",
            setup = "De pie con pies al ancho de cadera y mancuernas firmes a los lados.",
            move = "Sube de puntillas lo más alto posible, aguanta 1 segundo arriba y baja en 2 segundos.",
            tip = "Evita doblar las rodillas o torcer los tobillos hacia fuera.",
        },
    },
    {
        id = "db_sumo_squat", equipment = "dumbbells", category = "lower", difficulty = "intermediate", position = "standing",
        amount = 12, unit = "reps", estSeconds = 28, pose = 30,
        en = {
            name = "Dumbbell Sumo Squat",
            setup = "Take a wide stance with toes pointed out 45°, hold one dumbbell hanging between your legs.",
            move = "Keep chest upright as you squat straight down until the dumbbell nears the floor, then stand.",
            tip = "Push knees out over toes and squeeze your glutes hard at the top.",
        },
        es = {
            name = "Sentadilla sumo con mancuerna",
            setup = "Piernas bien abiertas con puntas a 45°, sujeta una mancuerna colgando en el centro.",
            move = "Baja recto con pecho erguido hasta acercar la mancuerna al suelo y sube apretando glúteos.",
            tip = "Asegúrate de que las rodillas sigan la línea de las punteras.",
        },
    },
    {
        id = "db_thrusters", equipment = "dumbbells", category = "cardio", difficulty = "advanced", position = "standing",
        amount = 10, unit = "reps", estSeconds = 28, pose = 27,
        en = {
            name = "Dumbbell Thrusters",
            setup = "Stand feet shoulder-width apart with dumbbells resting at shoulder height, elbows forward.",
            move = "Squat down cleanly, then drive up powerfully using your leg momentum to press weights overhead.",
            tip = "Make it one fluid motion from the bottom of the squat to full overhead extension.",
        },
        es = {
            name = "Thrusters con mancuernas",
            setup = "Pies al ancho de hombros y mancuernas apoyadas sobre los hombros con codos al frente.",
            move = "Haz una sentadilla completa y aprovecha el impulso de las piernas al subir para empujar arriba.",
            tip = "Encadena sentadilla y empuje en un solo gesto fluido; exhala al subir.",
        },
    },

    -- =========================================================================
    -- DUMBBELLS: CORE
    -- =========================================================================
    {
        id = "db_suitcase_march", equipment = "dumbbells", category = "core", difficulty = "beginner", position = "standing",
        amount = 15, unit = "seconds_each_side", estSeconds = 32, pose = 31,
        en = {
            name = "Single-Arm Suitcase March",
            setup = "Hold ONE dumbbell in one hand at your side like a heavy suitcase; keep shoulders level.",
            move = "March steadily in place for 15s resisting any sideways lean, then switch hands.",
            tip = "Your obliques work hardest when you stay 100% upright—don't lean toward or away from the weight!",
        },
        es = {
            name = "Marcha maleta (1 mancuerna)",
            setup = "Sujeta UNA sola mancuerna en una mano a tu lado como una maleta, hombros totalmente nivelados.",
            move = "Marcha en el sitio 15 seg evitando inclinarte hacia ningún lado y luego cambia de mano.",
            tip = "El secreto está en mantener el torso recto: tus oblicuos trabajan para equilibrarte.",
        },
    },
    {
        id = "db_side_bends", equipment = "dumbbells", category = "core", difficulty = "beginner", position = "standing",
        amount = 10, unit = "reps_each_side", estSeconds = 26, pose = 31,
        en = {
            name = "Dumbbell Oblique Side Bends",
            setup = "Stand feet hip-width apart holding one dumbbell at your side, free hand behind your head.",
            move = "Slide the dumbbell smoothly down your outer thigh a few inches, then pull upright with obliques.",
            tip = "Move strictly sideways without twisting forward; switch hands after completing the set.",
        },
        es = {
            name = "Inclinación lateral con mancuerna",
            setup = "De pie con una mancuerna en una mano y la otra detrás de la cabeza.",
            move = "Inclínate lateralmente bajando la mancuerna por el muslo unos centímetros y sube con el oblicuo.",
            tip = "No gires el torso hacia delante ni exageres el rango; haz un lado y cambia.",
        },
    },
    {
        id = "db_russian_twists", equipment = "dumbbells", category = "core", difficulty = "intermediate", position = "floor",
        amount = 10, unit = "reps_each_side", estSeconds = 26, pose = 20,
        en = {
            name = "Weighted Russian Twists",
            setup = "Sit with knees bent, heels on floor, lean back slightly holding one dumbbell at chest height.",
            move = "Rotate torso smoothly from side to side bringing the dumbbell beside each hip.",
            tip = "Turn your whole upper torso with the weight rather than just waving your arms.",
        },
        es = {
            name = "Giros rusos con mancuerna",
            setup = "Sentado con rodillas dobladas y espalda recta inclinada un poco atrás, mancuerna al pecho.",
            move = "Gira el torso suavemente a cada lado llevando la mancuerna cerca de la cadera.",
            tip = "Gira los hombros con la mancuerna en bloque sin mover solo los brazos.",
        },
    },
    {
        id = "db_farmers_march", equipment = "dumbbells", category = "core", difficulty = "beginner", position = "standing",
        amount = 25, unit = "seconds", estSeconds = 25, pose = 31,
        en = {
            name = "Farmer's Carry March",
            setup = "Hold two dumbbells firmly at your sides, shoulders pulled down and back, chest tall.",
            move = "March slowly and steadily in place lifting each knee cleanly while keeping torso rock-solid.",
            tip = "Great for grip, posture, and core stability—keep your gaze straight ahead.",
        },
        es = {
            name = "Paseo del granjero en el sitio",
            setup = "Sujeta dos mancuernas con agarre firme, hombros atrás y abajo, pecho erguido.",
            move = "Marcha de forma controlada en el sitio elevando rodillas sin balancear el torso.",
            tip = "Excelente para postura, agarre y abdomen; mantén la mirada al frente.",
        },
    },
}

function Exercises:GetAll()
    return self.DEFAULTS
end

function Exercises:GetLocalized(ex)
    local lang = ns.GetLang()
    local loc = ex[lang] or ex.en or ex.es or {}
    return loc.name or ex.id, loc.setup or "", loc.move or "", loc.tip or ""
end

function Exercises:GetDetailedGuide(ex)
    local _, setup, move, tip = self:GetLocalized(ex)
    local parts = {}
    if setup ~= "" then
        parts[#parts + 1] = "|cff00e5b8" .. ns.T("GUIDE_SETUP") .. "|r " .. setup
    end
    if move ~= "" then
        parts[#parts + 1] = "|cffffd25a" .. ns.T("GUIDE_MOVE") .. "|r " .. move
    end
    if tip ~= "" then
        parts[#parts + 1] = "|cff8fc4ff" .. ns.T("GUIDE_TIP") .. "|r " .. tip
    end
    return table.concat(parts, "\n")
end

function Exercises:GetPoseTexCoords(ex)
    local idx = tonumber(ex and ex.pose) or 8
    idx = math.max(0, math.min(self.POSE_COLS * self.POSE_ROWS - 1, idx))
    local col = idx % self.POSE_COLS
    local row = math.floor(idx / self.POSE_COLS)

    local cw = 1 / self.POSE_COLS
    local ch = 1 / self.POSE_ROWS
    local padX = 2 / 1024
    local padY = 2 / 512

    local left = col * cw + padX
    local right = (col + 1) * cw - padX
    local top = row * ch + padY
    local bottom = (row + 1) * ch - padY
    return left, right, top, bottom
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
    local maxDiff = settings.difficulty or "beginner"
    local maxRank = (maxDiff == "all") and 99 or (self.DIFFICULTY_RANK[maxDiff] or 1)
    local allowFloor = settings.allowFloor ~= false

    local eligible = {}
    for _, ex in ipairs(self:GetAll()) do
        if not (excludeMap and excludeMap[ex.id]) then
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

    if #pool == 0 then
        pool = self:GetEligible(budget, settings, sessionSeen)
    end
    if #pool == 0 then
        pool = self:GetEligible(budget, settings, nil)
    end
    if #pool == 0 and budget >= 12 then
        pool = self:GetEligible(budget, { equipmentMode = settings.equipmentMode or "none", difficulty = "all", allowFloor = true }, nil)
    end

    if #pool == 0 then
        return nil
    end

    local varied = {}
    for _, ex in ipairs(pool) do
        if ex.category ~= lastCategory then
            varied[#varied + 1] = ex
        end
    end
    if #varied > 0 then
        pool = varied
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
