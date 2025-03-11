extends CanvasLayer

func _on_ajustes_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ajustes/ajustes.tscn")


func _on_salir_pressed() -> void:
	$Contenedor/FilaNormal.visible = false
	$Contenedor/FilaSalir.visible = true
	$Contenedor/Cerrar.visible = false
	$Contenedor/Texto.text = "menuin_lab_confirmacion"


func _on_si_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	$Contenedor/FilaSalir.visible = false
	$Contenedor/FilaNormal.visible = true
	$Contenedor/Cerrar.visible = true
	$Contenedor/Texto.text = "menuin_lab_titulo"


func _on_cerrar_pressed() -> void:
	queue_free()
