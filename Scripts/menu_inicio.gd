extends CanvasLayer

func _on_ajustes_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ajustes.tscn")


func _on_salir_pressed() -> void:
	$Contenedor/FilaNormal.visible = false
	$Contenedor/FilaSalir.visible = true
	$Contenedor/Texto.text = "¿Seguro que quieres salir?"


func _on_si_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	$Contenedor/FilaSalir.visible = false
	$Contenedor/FilaNormal.visible = true
	$Contenedor/Texto.text = "Menu"
