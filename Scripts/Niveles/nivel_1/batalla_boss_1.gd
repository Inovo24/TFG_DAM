extends Bosses
@onready var camara_level1 = $Camera2D
@onready var posicion_level1 = $Marker2D

#Nivel1 boss

func _ready():
	level_name = "nivel1"
	initialPosition = posicion_level1
	super._ready()
	

	
func return_to_level():
	get_tree().change_scene_to_file("res://Scenes/Niveles/Nivel1/nivel_1.tscn")
