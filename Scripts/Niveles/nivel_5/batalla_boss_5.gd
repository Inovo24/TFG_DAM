extends Bosses

@onready var posicion_boss5 = $Marker2D

func _ready():
	level_name = "nivel5"
	initialPosition = posicion_boss5
	level_scene = "res://Scenes/Niveles/Nivel5/nivel_5.tscn"
	super._ready()
	var player = Globales.get_player()
	player.has_checkpoint = true
	player.checkpoint_position = posicion_boss5.position

'''
func reload_health_bar():
	healthBar.queue_free()
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
'''
'''
func return_to_level():
	get_tree().change_scene_to_file("res://Scenes/Niveles/Nivel1/nivel_1.tscn")
'''
