extends Node

#Datos de guardado
var save_path = "user://save.game.dat"

var game_data : Dictionary = {
	"current_character" = Globales.current_character,
	"volumes" = Globales.volumes,
	"colorblindness_type" = Globales.colorblindness_type,
	"idioma" = TranslationServer.get_locale()
}
var primera_carga = true
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
	"idioma" = TranslationServer.get_locale()
	}

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
	

func reset_controls():
	for action in default_controls.keys():
		InputMap.action_erase_events(action)
		for key in default_controls[action]:
			var event = InputEventKey.new()
			event.physical_keycode = key
			event.pressed = true
			event.keycode = key 
			print(event.physical_keycode)
			InputMap.action_add_event(action, event)
