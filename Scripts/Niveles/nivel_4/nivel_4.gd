extends Levels

@onready var level4_camera = $Camera2D
@onready var level4_position = $Camera2D/Marker2D

func _ready() -> void:
	camera = level4_camera
	initialPosition = level4_position
	Globales.character = null
	Globales.current_character = 2
	super._ready()
	
