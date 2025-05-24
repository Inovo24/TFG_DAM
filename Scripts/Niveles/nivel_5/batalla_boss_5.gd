extends Bosses

@onready var posicion_boss5 = $Marker2D

func _ready():
	level_name = "nivel5"
	initialPosition = posicion_boss5
	super._ready()
	

'''
func reload_health_bar():
	healthBar.queue_free()
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
'''

func return_to_level():
	get_tree().change_scene_to_file("res://Scenes/Niveles/Nivel1/nivel_1.tscn")
