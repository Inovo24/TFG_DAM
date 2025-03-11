extends Node2D

# Diccionario para almacenar las acciones y sus botones en la interfaz
var action_buttons = {}

# Acción actualmente en proceso de reasignación
var current_action = ""

var opcion #0 si es la principal, 1 si es la secundaria

func _ready():
	# Vincula acciones a botones
	action_buttons = {
		"mover_der": [$ContenedorPrincipal/Derecha/ButtonDerecha_1, $ContenedorPrincipal/Derecha/ButtonDerecha_2], 
		"mover_izq": [$ContenedorPrincipal/Izquierda/ButtonIzquierda_1, $ContenedorPrincipal/Izquierda/ButtonIzquierda_2],
		"arriba": [$ContenedorPrincipal/Arriba/ButtonArriba_1, $ContenedorPrincipal/Arriba/ButtonArriba_2],
		"abajo": [$ContenedorPrincipal/Abajo/ButtonAbajo_1, $ContenedorPrincipal/Abajo/ButtonAbajo_2],
		"salto": [$ContenedorPrincipal/Salto/ButtonSalto_1, $ContenedorPrincipal/Salto/ButtonSalto_2],
		"ataque":[$ContenedorPrincipal/Ataque/ButtonAtaque_1, $ContenedorPrincipal/Ataque/ButtonAtaque_2],
		"salir": [$ContenedorPrincipal/Salir/ButtonSalir_1, $ContenedorPrincipal/Salir/ButtonSalir_2],
		"aceptar_entrar": [$ContenedorPrincipal/Aceptar/ButtonAceptar_1, $ContenedorPrincipal/Aceptar/ButtonAceptar_2]
	}
# Muestra las teclas configuradas por defecto
	_update_button_texts()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir"):
		get_tree().change_scene_to_file("res://Scenes/ajustes/ajustes.tscn")

# Función para actualizar los textos de los botones con las teclas configuradas
func _update_button_texts():
	for action_name in action_buttons.keys():
		var events = InputMap.action_get_events(action_name)
		
		# Actualiza el texto del botón con la tecla configurada por defecto
		action_buttons[action_name][0].text = events[0].as_text().replace(" (Physical)", "")
		if events.size() > 1:
			action_buttons[action_name][1].text = events[1].as_text().replace(" (Physical)", "")
		else:
			action_buttons[action_name][1].text = "tecl_txt_noasignado"
	
	#Cambiar texto salir
	var salir_tecla = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$BotonVolver/TextoSalir.text = tr("gen_salir").replace("{tecla}",salir_tecla)

func _on_action_button_pressed(action_name):
	# Inicia el proceso de reasignación
	current_action = action_name
	action_buttons[action_name][opcion].text = "tecl_txt_pres"
	set_process_input(true)

# Maneja los eventos de entrada (como la tecla presionada)
func _input(event):
	if current_action != "" and event is InputEventKey and event.pressed:
		#Obtenemos la configuracion previa
		var eventosAntiguos = InputMap.action_get_events(current_action)
		
		#Cambiamos la configuracion
		if eventosAntiguos.size() < 2 && opcion == 1:
			eventosAntiguos.append(event)
		else:
			eventosAntiguos[opcion] = event
		
		# Remueve la configuración previa
		InputMap.action_erase_events(current_action)
		
		# Asigna las teclas de nuevo
		for tecla in eventosAntiguos:
			InputMap.action_add_event(current_action, tecla)

		# Resetea el estado de reasignación
		current_action = ""
		set_process_input(false)
		
		# Actualiza el texto del botón con el nombre de la tecla
		_update_button_texts()

#Vincular señales de botones
func _on_boton_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ajustes/ajustes.tscn")

func _on_button_derecha_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("mover_der")

func _on_button_derecha_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("mover_der")

func _on_button_izquierda_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("mover_izq")

func _on_button_izquierda_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("mover_izq")

func _on_button_arriba_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("arriba")

func _on_button_arriba_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("arriba")

func _on_button_abajo_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("abajo")

func _on_button_abajo_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("abajo")

func _on_button_aceptar_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("aceptar_entrar")

func _on_button_aceptar_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("aceptar_entrar")
	
func _on_button_salir_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("salir")

func _on_button_salir_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("salir")

func _on_button_ataque_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("ataque")

func _on_button_ataque_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("ataque")

func _on_button_salto_1_pressed() -> void:
	opcion = 0
	_on_action_button_pressed("salto")

func _on_button_salto_2_pressed() -> void:
	opcion = 1
	_on_action_button_pressed("salto")
