extends CanvasLayer

@onready var ajustes = preload("res://Scenes/ajustes/ajustes.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir") and $Contenedor.visible:
		_on_cerrar_pressed()

func _on_ajustes_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/ajustes/ajustes.tscn")
	add_child(ajustes.instantiate())
	$Contenedor.visible = false


func _on_salir_pressed() -> void:
	$Contenedor/Ajustes.visible = false
	$Contenedor/Salir.visible = false
	$Contenedor/FilaSalir.visible = true
	$Contenedor/Cerrar.visible = false
	$Contenedor/Texto.text = "menuin_lab_confirmacion"


func _on_si_pressed() -> void:
	if get_parent() is Levels || get_parent() is Bosses:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
	else:
		get_tree().quit()
		Guardado.save_game()


func _on_no_pressed() -> void:
	$Contenedor/FilaSalir.visible = false
	$Contenedor/Ajustes.visible = true
	$Contenedor/Salir.visible = true
	$Contenedor/Cerrar.visible = true
	$Contenedor/Texto.text = "menuin_lab_titulo"


func _on_cerrar_pressed() -> void:
	queue_free()
	get_tree().paused = false

func make_container_visible():
	$Contenedor.visible = true
