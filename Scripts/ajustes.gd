extends Node2D

func _on_boton_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/inicio.tscn")

#Sonido
func _on_h_slider_music_value_changed(value: float) -> void:
	change_volume(linear_to_db(value), "Music")

func _on_h_slider_general_value_changed(value: float) -> void:
	change_volume(linear_to_db(value), "Master")

func _on_h_slider_enemigos_value_changed(value: float) -> void:
	change_volume(linear_to_db(value), "SFX")

func change_volume(value, bus: String) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)
