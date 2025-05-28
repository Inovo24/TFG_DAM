extends Levels

@onready var level5_camera = $Camera2D
@onready var level5_position = $Inicio

func _ready() -> void:
	camera = level5_camera
	initialPosition = level5_position
	level_name = "nivel5"
	super._ready()

func reload_health_bar():
	healthBar.queue_free()
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
