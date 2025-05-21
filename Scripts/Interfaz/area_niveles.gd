extends Area2D

var player_in_area = false
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _on_body_entered(_body: Node2D) -> void:
	$TextoNiveles.visible = true
	player_in_area = true


func _on_body_exited(_body):
	player_in_area = false
	$TextoNiveles.visible = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("aceptar_entrar"):  
		get_tree().change_scene_to_file("res://Scenes/selector_niveles/level_selector.tscn")
