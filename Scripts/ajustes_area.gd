extends Area2D
var player_in_area = false

func _on_body_entered(_body: Node2D) -> void:
	$"../TextoAjustes".visible = true
	player_in_area = true

func _on_body_exited(_body: Node2D) -> void:
	player_in_area = false
	$"../TextoAjustes".visible = false

func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("arriba"):
		get_tree().change_scene_to_file("res://Scenes/ajustes.tscn")  # Cambia la escena
