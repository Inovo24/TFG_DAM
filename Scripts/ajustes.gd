extends Node2D

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
	
#Cambiar texto salir
	var salir_tecla = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$BotonVolver/TextoSalir.text = "Pulsa " + salir_tecla + " para salir"


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
