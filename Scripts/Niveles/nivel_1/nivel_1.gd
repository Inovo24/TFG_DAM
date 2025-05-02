extends Levels

@onready var camara_level1 = $Camera2D
@onready var posicion_level1 = $Camera2D/Marker2D


func _ready():	
	camera = camara_level1
	initialPosition = posicion_level1
	super._ready()
