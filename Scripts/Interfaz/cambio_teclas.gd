extends CanvasLayer

# Dictionary to store actions and their buttons in the interface
var action_buttons = {}

# Action currently in the process of reassignment
var current_action = ""

var option # 0 if it's the primary, 1 if it's the secondary

func _ready():
	# Links actions to buttons
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
	# Displays the default configured keys
	_update_button_texts()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir"):
		_on_button_back_pressed()

# Function to update the button texts with the configured keys
func _update_button_texts():
	for action_name in action_buttons.keys():
		var events = InputMap.action_get_events(action_name)
		
		# Updates the button text with the default configured key
		action_buttons[action_name][0].text = events[0].as_text().replace(" (Physical)", "")
		if events.size() > 1:
			action_buttons[action_name][1].text = events[1].as_text().replace(" (Physical)", "")
		else:
			action_buttons[action_name][1].text = "tecl_txt_noasignado"
	
	# Change back button text
	var salir_key = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$BotonVolver/TextoSalir.text = tr("gen_salir").replace("{tecla}", salir_key)

func _on_action_button_pressed(action_name):
	# Starts the reassignment process
	current_action = action_name
	action_buttons[action_name][option].text = "tecl_txt_pres"
	set_process_input(true)

# Handles input events (like the pressed key)
func _input(event):
	if current_action != "" and event is InputEventKey and event.pressed:
		# Get the previous configuration
		var old_events = InputMap.action_get_events(current_action)
		
		# Change the configuration
		if old_events.size() < 2 && option == 1:
			old_events.append(event)
		else:
			old_events[option] = event
		
		# Remove the previous configuration
		InputMap.action_erase_events(current_action)
		
		# Assign the keys again
		for key in old_events:
			InputMap.action_add_event(current_action, key)

		# Reset the reassignment state
		current_action = ""
		set_process_input(false)
		
		# Update the button text with the key name
		_update_button_texts()

# Link button signals
func _on_button_back_pressed() -> void:
	get_parent().key_change_open = false
	queue_free()

func _on_button_derecha_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("mover_der")

func _on_button_derecha_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("mover_der")

func _on_button_izquierda_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("mover_izq")

func _on_button_izquierda_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("mover_izq")

func _on_button_arriba_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("arriba")

func _on_button_arriba_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("arriba")

func _on_button_abajo_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("abajo")

func _on_button_abajo_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("abajo")

func _on_button_aceptar_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("aceptar_entrar")

func _on_button_aceptar_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("aceptar_entrar")
	
func _on_button_salir_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("salir")

func _on_button_salir_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("salir")

func _on_button_ataque_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("ataque")

func _on_button_ataque_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("ataque")

func _on_button_salto_1_pressed() -> void:
	option = 0
	_on_action_button_pressed("salto")

func _on_button_salto_2_pressed() -> void:
	option = 1
	_on_action_button_pressed("salto")
