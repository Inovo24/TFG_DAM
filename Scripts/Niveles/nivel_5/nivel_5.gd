extends Levels

@onready var level5_camera = $Camera2D
@onready var level5_position = $Inicio

func _ready() -> void:
	camera = level5_camera
	initialPosition = level5_position
	level_name = "nivel5"
	super._ready()
