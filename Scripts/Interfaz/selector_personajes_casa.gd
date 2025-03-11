extends Area2D

# Variable para indicar si el jugador está dentro del área
var player_in_area = false

func _on_body_entered(_body: Node2D) -> void:
	$"../TextoSelector".visible = true
	player_in_area = true

# Función que se ejecuta cuando algo sale del área
func _on_body_exited(_body):
	player_in_area = false
	$"../TextoSelector".visible = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("aceptar_entrar"):  # Detecta la tecla, por ejemplo "Enter" o "Espacio"
		get_tree().change_scene_to_file("res://Scenes/selector_personajes.tscn")  # Cambia la escena
