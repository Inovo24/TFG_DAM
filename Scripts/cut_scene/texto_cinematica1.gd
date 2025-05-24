extends Node2D

# Ajusta estas rutas según tu estructura de nodos
@onready var narration_text = $Camera2D/Label #$Camera2D/RichTextLabel # O usa Label si prefieres
@onready var narration_timer = $Camera2D/Timer
@onready var ui_panel = $UI  # Panel contenedor (opcional)

# Datos de narración
var narration_data = [
	["Desde las profundidades de Niflheim hasta las alturas de Asgard,",3],[ "el gran árbol, Yggdrasill, une todos los reinos.", 3.0],
	["Nueve mundos, cada uno hogar de razas y deidades distintas:",3],[ "los Aesir y Vanir, los Gigantes de Hielo, los Elfos, los Enanos…", 3.0],
	["Durante eones, este equilibrio ha perdurado,",2.5],[ "tejido por los hilos del destino.", 2.5],
	["Pero el tiempo es un río que fluye,",3],[ "y con cada era, la marea de los acontecimientos se acerca al gran crepúsculo.", 6.0],
	["Se susurra entre los reinos que el Ragnarök,",2.5],[ "el fin de los tiempos, está cerca.", 2.5],
	["El invierno de Fimbulvetr ya se siente,",2.5],[ "sus garras congelan la esperanza.", 2.5],
	["Loki, el dios de la traición y las mentiras, permanece encadenado.",2.5],[ "O eso nos dicen.", 2.5],
	["Pero el engañoso dios no ha de permanecer cautivo por siempre.", 4.0],
	["Las señales son claras: su liberación se aproxima,",2.5],[ "y con ella, el caos.", 2.5],
	["Mientras los dioses se preparan para su destino,",3],[ "en los reinos inferiores, la vida cotidiana se desmorona.", 6.0],
	["Semanas de un clima gélido e implacable",2.5],[ "han cubierto la tierra de un gris perpetuo.", 2.5],
	["Los recursos escasean. El hambre acecha.", 3.0],
	["Fue la necesidad lo que impulsó a dos almas valientes",2.5],[ "a abandonar la seguridad de su pueblo.", 2.5],
	["Un arquero hábil y una guerrera de fuerza indomable",2.5],[ "partieron en busca de provisiones.", 2.5],
	["El rastro de humo en el horizonte",2.5],[ "les ofreció una chispa de esperanza.", 4.0],
	["En aquel asentamiento, encontraron ayuda...",2.5],[ "pero también una petición urgente.", 2.5],
	["La hija del poblado había sido secuestrada.", 3.0],
	["Si ayudaban a recuperarla, las provisiones serían suyas.", 4.0],
	["El destino de un pueblo, y quizás el suyo propio,",2.5],[ "pendía de esta decisión.", 2.5]
];
'''
var narration_data = [
	["Desde las profundidades de Niflheim hasta las alturas de Asgard, el gran árbol, Yggdrasill, une todos los reinos.", 6.0],
	["Nueve mundos, cada uno hogar de razas y deidades distintas: los Aesir y Vanir, los Gigantes de Hielo, los Elfos, los Enanos…", 6.0],
	["Durante eones, este equilibrio ha perdurado, tejido por los hilos del destino.", 5.0],
	["Pero el tiempo es un río que fluye, y con cada era, la marea de los acontecimientos se acerca al gran crepúsculo.", 6.0],
	["Se susurra entre los reinos que el Ragnarök, el fin de los tiempos, está cerca.", 5.0],
	["El invierno de Fimbulvetr ya se siente, sus garras congelan la esperanza.", 5.0],
	["Loki, el dios de la traición y las mentiras, permanece encadenado. O eso nos dicen.", 5.0],
	["Pero el engañoso dios no ha de permanecer cautivo por siempre.", 4.0],
	["Las señales son claras: su liberación se aproxima, y con ella, el caos.", 5.0],
	["Mientras los dioses se preparan para su destino, en los reinos inferiores, la vida cotidiana se desmorona.", 6.0],
	["Semanas de un clima gélido e implacable han cubierto la tierra de un gris perpetuo.", 5.0],
	["Los recursos escasean. El hambre acecha.", 3.0],
	["Fue la necesidad lo que impulsó a dos almas valientes a abandonar la seguridad de su pueblo.", 5.0],
	["Un arquero hábil y una guerrera de fuerza indomable partieron en busca de provisiones.", 5.0],
	["El rastro de humo en el horizonte les ofreció una chispa de esperanza.", 4.0],
	["En aquel asentamiento, encontraron ayuda... pero también una petición urgente.", 5.0],
	["La hija del poblado había sido secuestrada.", 3.0],
	["Si ayudaban a recuperarla, las provisiones serían suyas.", 4.0],
	["El destino de un pueblo, y quizás el suyo propio, pendía de esta decisión.", 5.0]
]
'''
var current_index = 0

func _ready():
	print("=== INICIANDO CINEMÁTICA ===")
	
	# Verificar nodos críticos
	if not narration_text:
		print("ERROR: Texto no encontrado. Estructura actual:")
		#print_node_structure()
		return
	
	if not narration_timer:
		print("ERROR: Timer no encontrado")
		return
	
	print("✓ Nodos encontrados")
	
	# Configurar texto
	setup_text_display()
	
	# Configurar timer
	narration_timer.one_shot = true
	narration_timer.timeout.connect(_on_timer_timeout)
	
	print("✓ Configuración completa")
	
	# Empezar con delay pequeño
	await get_tree().create_timer(0.5).timeout
	show_current_segment()

func setup_text_display():
	#narration_text.label_settings = preload("res://Scenes/UI/UI_laber_settings/inicioTexts.tres")
	# Configuración básica que funciona tanto para Label como RichTextLabel
	narration_text.text = ""
	narration_text.show()
	
	# Si es RichTextLabel, configurar BBCode
	if narration_text is RichTextLabel:
		narration_text.bbcode_enabled = true
		narration_text.fit_content = true
	
	# Si es Label normal, configurar autowrap
	if narration_text is Label:
		narration_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# Mostrar panel contenedor
	if ui_panel:
		ui_panel.show()

func show_current_segment():
	if current_index >= narration_data.size():
		end_narration()
		return
	
	var segment = narration_data[current_index]
	var text = segment[0]
	var duration = segment[1]
	
	print("Segmento %d/%d: %s" % [current_index + 1, narration_data.size(), text])
	
	# Mostrar texto simple y claro
	if narration_text is RichTextLabel:
		# Usar BBCode básico para centrar y dar formato
		narration_text.text = "[center]%s[/center]" % text
	else:
		# Para Label normal
		narration_text.text = text
		narration_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Iniciar timer para este segmento
	narration_timer.wait_time = duration
	narration_timer.start()
	
	current_index += 1

func _on_timer_timeout():
	print("→ Siguiente segmento")
	show_current_segment()

func end_narration():
	print("=== NARRACIÓN TERMINADA ===")
	
	# Mostrar mensaje final
	if narration_text is RichTextLabel:
		narration_text.text = "[center][i]Presiona cualquier tecla para continuar...[/i][/center]"
	else:
		narration_text.text = "FIN"
	
	# Esperar input del jugador
	await get_tree().process_frame
	set_process_input(true)

func continue_to_game():
	print("Continuando al juego...")
	if ui_panel:
		ui_panel.hide()
	
	# Aquí cambias a la siguiente escena
	# get_tree().change_scene_to_file("res://scen
