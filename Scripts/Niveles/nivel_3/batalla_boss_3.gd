

extends Bosses

@onready var posicion_boss3 = $Marker2D

func _ready():
	level_name = "nivel3"
	initialPosition = posicion_boss3
	super._ready()
	var player = Globales.get_player()
	player.has_checkpoint = true
	player.checkpoint_position = posicion_boss3.position

func _on_final_body_entered(body: Node2D) -> void:
	if body is Characters:
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
