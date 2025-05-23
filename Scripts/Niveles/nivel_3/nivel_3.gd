extends Levels

@onready var camara_level3= $Camera2D
@onready var posicion_level3 = $Camera2D/Marker2D

func _ready() -> void:
	camera = camara_level3
	initialPosition = posicion_level3
	super._ready()
