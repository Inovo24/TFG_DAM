extends Node

#Datos de guardado
var save_path = "user://save.game.dat"
var game_data : Dictionary 
'''
var game_data : Dictionary = {
	"current_character" = Globales.current_character,
	"volumes" = Globales.volumes,
	"colorblindness_type" = Globales.colorblindness_type,
	"idioma" = TranslationServer.get_locale(),
	"controls" = {
		"mover_izq" = InputMap.action_get_events("mover_izq"),
		"mover_der" = InputMap.action_get_events("mover_der"),
		"salto" = InputMap.action_get_events("salto"),
		"ataque" = InputMap.action_get_events("ataque"),
		"arriba" = InputMap.action_get_events("arriba"),
		"abajo" = InputMap.action_get_events("abajo"),
		"aceptar_entrar" = InputMap.action_get_events("aceptar_entrar"),
		"salir" = InputMap.action_get_events("salir")
	}
}
'''
var primera_carga = true
var level_progress = {
	"nivel1" = {
		"hecho" = false,
		"num_gems" = 0,
		"time" = 0
	}
}

#Para guardar los datos de los niveles con boss
var level_temporal_progress = {
	"nivel1" = {
		"num_gems" = 0,
		"time" = 0
	}
}

var default_controls = {
	"mover_izq": [KEY_A, KEY_LEFT],
	"mover_der": [KEY_D, KEY_RIGHT],
	"salto": [KEY_X, KEY_SPACE],
	"ataque": [KEY_Z],
	"arriba": [KEY_UP, KEY_W],
	"abajo": [KEY_DOWN, KEY_S],
	"aceptar_entrar": [KEY_W, KEY_ENTER],
	"salir": [KEY_ESCAPE]
}

func save_game():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	upload_dictionary_data()
	print(level_progress)
	save_file.store_var(game_data)
	save_file = null
	print("guardado")

func load_game():
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		
		game_data = save_file.get_var()
		save_file = null
		load_dictionary_data()
		print("cargado")

#Actualizar diccionario antes de guardar
func upload_dictionary_data():
	game_data = {
		"current_character" = Globales.current_character,
		"volumes" = Globales.volumes,
		"colorblindness_type" = Globales.colorblindness_type,
		"idioma" = TranslationServer.get_locale(),
		"controls" = {
			"mover_izq" = [],
			"mover_der" = [],
			"salto" = [],
			"ataque" = [],
			"arriba" = [],
			"abajo" = [],
			"aceptar_entrar" = [],
			"salir" = []
		},
		"niveles" = level_progress
	}
	
	#Guardamos todas las acciones, una a una, con el codigo de la tecla correspondiente
	for action in game_data["controls"].keys():
		var events := InputMap.action_get_events(action)
		var keycodes := []
		
		for ev in events:
			if ev is InputEventKey:
				keycodes.append(ev.physical_keycode)
		
		game_data["controls"][action] = keycodes

#Actualizar datos con el diccionario cargado
func load_dictionary_data():
	if "current_character" in game_data:
		Globales.current_character = game_data["current_character"]
	
	if "volumes" in game_data:
		Globales.volumes = game_data["volumes"]
	
	if "colorblindness_type" in game_data:
		Globales.colorblindness_type = game_data["colorblindness_type"]
	
	if "idioma" in game_data:
		TranslationServer.set_locale(game_data["idioma"])
	
	if "controls" in game_data:
		for action in game_data["controls"].keys():
			InputMap.action_erase_events(action)
			for key in game_data["controls"][action]:
				var event = InputEventKey.new()
				event.physical_keycode = key
				event.pressed = true
				#print(event.physical_keycode)
				InputMap.action_add_event(action, event)
	

func save_temporal_data(level_name: String,num_gems: int, time: float):
	level_temporal_progress[level_name] = {
		"num_gems" = num_gems,
		"time" = time
	}

func mark_level_completed(level_name: String,num_gems: int, time: float):
	var level_data = level_progress[level_name]
	
	level_data["hecho"] = true
	# Solo guardar las nuevas gemas si son más que las anteriores
	if num_gems > level_data["num_gems"]:
		level_data["num_gems"] = num_gems
	# Solo guardar el nuevo tiempo si es menor (mejor tiempo)
	if time < level_data["time"]:
		level_data["time"] = time

	level_progress[level_name] = level_data
	save_game()

func reset_controls():
	for action in default_controls.keys():
		InputMap.action_erase_events(action)
		for key in default_controls[action]:
			var event = InputEventKey.new()
			event.physical_keycode = key
			event.pressed = true
			#print(event.physical_keycode)
			InputMap.action_add_event(action, event)
