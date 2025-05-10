extends Bosses
@onready var camara_level1 = $Camera2D
@onready var posicion_level1 = $Camera2D/Marker2D

#Nivel1 boss

func _ready():
	initialPosition = posicion_level1
	super._ready()
	

	
