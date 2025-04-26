extends Area2D
var player_in_area = false
@onready var ajustes = preload("res://Scenes/ajustes/ajustes.tscn")

func _on_body_entered(_body: Node2D) -> void:
	$"../TextoAjustes".visible = true
	player_in_area = true

func _on_body_exited(_body: Node2D) -> void:
	player_in_area = false
	$"../TextoAjustes".visible = false

func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("aceptar_entrar"):
		#get_tree().change_scene_to_file("res://Scenes/ajustes/ajustes.tscn")  # Cambia la escena
		add_child(ajustes.instantiate())
