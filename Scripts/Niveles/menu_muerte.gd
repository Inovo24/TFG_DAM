extends CanvasLayer

@onready var settings = preload("res://Scenes/ajustes/ajustes.tscn")

func _ready() -> void:
	if get_parent() is Characters:
		if get_parent().has_checkpoint and get_parent().life_count > 0:
			$Contenedor/Reanudar.text = "menumuer_lab_check"
		else:
			$Contenedor/Reanudar.text = "menumuer_lab_reiniciar"
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir") and $Contenedor.visible:
		#_on_close_pressed()
		pass

func _on_settings_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/ajustes/ajustes.tscn")
	add_child(settings.instantiate())
	$Contenedor.visible = false


func _on_exit_pressed() -> void:
	$Contenedor/Ajustes.visible = false
	$Contenedor/Reanudar.visible = false
	$Contenedor/FilaSalir.visible = true
	$Contenedor/Salir.visible = false
	$Contenedor/Texto.text = "menuin_lab_confirmacion"


func _on_yes_pressed() -> void:
	if get_parent().get_parent() is Levels:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
	else:
		get_tree().quit()


func _on_no_pressed() -> void:
	$Contenedor/FilaSalir.visible = false
	$Contenedor/Ajustes.visible = true
	$Contenedor/Reanudar.visible = true
	$Contenedor/Salir.visible = true
	$Contenedor/Texto.text = "menuin_lab_titulo"


func make_visible_container():
	$Contenedor.visible = true


func _on_resume_pressed() -> void:
	if get_parent().has_checkpoint and get_parent().life_count > 0:
		get_tree().paused = false
		get_parent().return_to_checkpoint()
	else:
		get_tree().paused = false
		get_tree().change_scene_to_file(get_parent().get_parent().scene_file_path)
	queue_free()
