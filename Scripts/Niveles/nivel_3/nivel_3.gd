extends Levels

@onready var level3_camera = $Camera2D
@onready var level3_position = $Camera2D/Marker2D

func _ready() -> void:
	camera = level3_camera
	initialPosition = level3_position
	super._ready()
func reload_health_bar():
	healthBar.queue_free()
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
func _on_final_body_entered(body: Node2D) -> void:
	if body is Characters:
		save_data("nivel3")
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
