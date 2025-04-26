extends Niveles

@onready var camara_level1 = $Camera2D
@onready var posicion_leve1 = $Camera2D/Marker2D

func _ready():	
	camara = camara_level1
	posicion = posicion_leve1
	super._ready()
