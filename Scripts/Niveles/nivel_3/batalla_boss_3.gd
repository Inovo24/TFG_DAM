extends Bosses

@onready var posicion_level3 = $Marker2D

func _ready():
	level_name = "nivel3"
	initialPosition = posicion_level3
	level_scene = "res://Scenes/Niveles/Nivel3/nivel_3.tscn"
	super._ready()
	
	


func reload_health_bar():
	var default = healthBar.default
	healthBar.queue_free()
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
	healthBar.default = default

'''
func return_to_level():
	get_tree().change_scene_to_file("res://Scenes/Niveles/Nivel3/nivel_3.tscn")
'''
