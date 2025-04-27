extends Node

#Datos de guardado
var save_path = "user://save.game.dat"

var game_data : Dictionary = {
	"personaje_actual" = Globales.personaje_actual,
	"volumenes" = Globales.volumenes,
	"daltonismo_type" = Globales.daltonismo_type,
	"idioma" = TranslationServer.get_locale()
}
var primera_carga = true

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
	"personaje_actual" = Globales.personaje_actual,
	"volumenes" = Globales.volumenes,
	"daltonismo_type" = Globales.daltonismo_type,
	"idioma" = TranslationServer.get_locale()
	}

#Actualizar datos con el diccionario cargado
func load_dictionary_data():
	Globales.personaje_actual = game_data["personaje_actual"]
	Globales.volumenes = game_data["volumenes"]
	Globales.daltonismo_type = game_data["daltonismo_type"]
	TranslationServer.set_locale(game_data["idioma"])
