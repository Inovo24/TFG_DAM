extends Node2D

func _ready() -> void:
	var volGen = Globales.getVolumenGeneral()
	var volMus = Globales.getVolumenMusica()
	var volEne = Globales.getVolumenEnemigos()
	
	$NivelGeneral.text = str(volGen*100)
	$NivelMusica.text = str(volMus*100)
	$NivelEnemigos.text = str(volEne*100)
	
	$HSliderGeneral.value = volGen
	$HSliderMusic.value = volMus
	$HSliderEnemigos.value = volEne

func _on_boton_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/inicio.tscn")

#Sonido
func _on_h_slider_general_value_changed(value: float) -> void:
	$NivelGeneral.text = str(value*100)
	Globales.setVolumenGeneral(value)

func _on_h_slider_music_value_changed(value: float) -> void:
	$NivelMusica.text = str(value*100)
	Globales.setVolumenMusica(value)

func _on_h_slider_enemigos_value_changed(value: float) -> void:
	$NivelEnemigos.text = str(value*100)
	Globales.setVolumenEnemigos(value)
