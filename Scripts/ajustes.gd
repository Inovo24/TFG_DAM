extends Node2D

var language_codes = ["es", "en", "pt", "it"]

func _ready() -> void:
	var volGen = Globales.getVolumenGeneral()
	var volMus = Globales.getVolumenMusica()
	var volEne = Globales.getVolumenEnemigos()
	
	$HSplitContainer/Columna1/ContGeneral/NivelGeneral.text = str(volGen*100)
	$HSplitContainer/Columna1/ContMusica/NivelMusica.text = str(volMus*100)
	$HSplitContainer/Columna1/ContEnemigos/NivelEnemigos.text = str(volEne*100)
	
	$HSplitContainer/Columna1/ContGeneral/HSliderGeneral.value = volGen
	$HSplitContainer/Columna1/ContMusica/HSliderMusic.value = volMus
	$HSplitContainer/Columna1/ContEnemigos/HSliderEnemigos.value = volEne
	
	set_txt_salir()
	
	#Establecer que idioma esta selecionado
	var idioma_predeterminado = TranslationServer.get_locale()
	var language = language_codes.find(idioma_predeterminado)
	var btnIdiomas = $HSplitContainer/Columna2/Idiomas
	
	if language != -1:
		btnIdiomas.selected = language
	else: 
		btnIdiomas.selected = 1


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir"):
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")

func _on_boton_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/inicio.tscn")

#Sonido
func _on_h_slider_general_value_changed(value: float) -> void:
	$HSplitContainer/Columna1/ContGeneral/NivelGeneral.text = str(value*100)
	Globales.setVolumenGeneral(value)

func _on_h_slider_music_value_changed(value: float) -> void:
	$HSplitContainer/Columna1/ContMusica/NivelMusica.text = str(value*100)
	Globales.setVolumenMusica(value)

func _on_h_slider_enemigos_value_changed(value: float) -> void:
	$HSplitContainer/Columna1/ContEnemigos/NivelEnemigos.text = str(value*100)
	Globales.setVolumenEnemigos(value)


func _on_teclas_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/cambio_teclas.tscn")


func _on_option_button_item_selected(index: int) -> void:
	TranslationServer.set_locale(language_codes[index])
	set_txt_salir()

func set_txt_salir():
	#Cambiar texto salir
	var salir_tecla = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$BotonVolver/TextoSalir.text = tr("gen_salir").replace("{tecla}",salir_tecla)
