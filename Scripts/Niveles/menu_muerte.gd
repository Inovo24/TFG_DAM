extends CanvasLayer

@onready var ajustes = preload("res://Scenes/ajustes/ajustes.tscn")

func _ready() -> void:
	if get_parent() is Personajes:
		if get_parent().tiene_checkpoint:
			$Contenedor/FilaNormal/Reanudar.text = "menumuer_lab_check"
		else:
			$Contenedor/FilaNormal/Reanudar.text = "menumuer_lab_reiniciar"
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir") and $Contenedor.visible:
		#_on_cerrar_pressed()
		pass

func _on_ajustes_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/ajustes/ajustes.tscn")
	add_child(ajustes.instantiate())
	$Contenedor.visible = false


func _on_salir_pressed() -> void:
	$Contenedor/FilaNormal.visible = false
	$Contenedor/FilaSalir.visible = true
	$Contenedor/Salir.visible = false
	$Contenedor/Texto.text = "menuin_lab_confirmacion"


func _on_si_pressed() -> void:
	if get_parent().get_parent() is Niveles:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
	else:
		get_tree().quit()


func _on_no_pressed() -> void:
	$Contenedor/FilaSalir.visible = false
	$Contenedor/FilaNormal.visible = true
	$Contenedor/Salir.visible = true
	$Contenedor/Texto.text = "menuin_lab_titulo"


func hacer_visible_cont():
	$Contenedor.visible = true


func _on_reanudar_pressed() -> void:
	if get_parent().tiene_checkpoint:
		get_tree().paused = false
		get_parent().volver_a_checkpoint()
	else:
		get_tree().paused = false
		get_tree().change_scene_to_file(get_parent().get_parent().scene_file_path)
	queue_free()
