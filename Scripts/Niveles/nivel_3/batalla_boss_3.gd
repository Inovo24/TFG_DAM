extends Bosses
@onready var camara_level3 = $Camera2D
@onready var posicion_level3 = $Marker2D

#Nivel1 boss

func _ready():
	level_name = "nivel3"
	initialPosition = posicion_level3
	super._ready()
	

	
func return_to_level():
	get_tree().change_scene_to_file("res://Scenes/Niveles/Nivel1/nivel_3.tscn")
