extends Niveles

@onready var camara_level2 = $Camera2D
@onready var posicion_level2 = $Marker2D

func _ready() -> void:
	camara = camara_level2
	posicion = posicion_level2
	super._ready()
