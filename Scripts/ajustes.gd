extends Node2D

func _ready() -> void:
	var volGen = Globales.getVolumenGeneral()
	var volMus = Globales.getVolumenMusica()
	var volEne = Globales.getVolumenEnemigos()
	
	$Contenedor/ContGeneral/NivelGeneral.text = str(volGen*100)
	$Contenedor/ContMusica/NivelMusica.text = str(volMus*100)
	$Contenedor/ContEnemigos/NivelEnemigos.text = str(volEne*100)
	
	$Contenedor/ContGeneral/HSliderGeneral.value = volGen
	$Contenedor/ContMusica/HSliderMusic.value = volMus
	$Contenedor/ContEnemigos/HSliderEnemigos.value = volEne

func _on_boton_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/inicio.tscn")

#Sonido
func _on_h_slider_general_value_changed(value: float) -> void:
	$Contenedor/ContGeneral/NivelGeneral.text = str(value*100)
	Globales.setVolumenGeneral(value)

func _on_h_slider_music_value_changed(value: float) -> void:
	$Contenedor/ContMusica/NivelMusica.text = str(value*100)
	Globales.setVolumenMusica(value)

func _on_h_slider_enemigos_value_changed(value: float) -> void:
	$Contenedor/ContEnemigos/NivelEnemigos.text = str(value*100)
	Globales.setVolumenEnemigos(value)


func _on_teclas_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/cambio_teclas.tscn")
