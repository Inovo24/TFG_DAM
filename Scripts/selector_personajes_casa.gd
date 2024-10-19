extends Area2D

# Variable para indicar si el jugador está dentro del área
var player_in_area = false

func _on_body_entered(body: Node2D) -> void:
	print("Pulsa W para entrar") 
	player_in_area = true


# Función que se ejecuta cuando algo sale del área
func _on_body_exited(body):
	player_in_area = false

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("arriba"):  # Detecta la tecla, por ejemplo "Enter" o "Espacio"
		get_tree().change_scene_to_file("res://selector_personajes.tscn")  # Cambia la escena
