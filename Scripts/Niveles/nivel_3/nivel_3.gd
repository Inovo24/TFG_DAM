extends Levels

@onready var level3_camera = $Camera2D
@onready var level3_position = $Marker2D

func _ready() -> void:
	camera = level3_camera
	initialPosition = level3_position
	super._ready()
