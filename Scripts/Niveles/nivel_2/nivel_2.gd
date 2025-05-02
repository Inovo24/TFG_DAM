extends Levels

@onready var level2_camera = $Camera2D
@onready var level2_position = $Marker2D

func _ready() -> void:
	camera = level2_camera
	position = level2_position
	super._ready()
