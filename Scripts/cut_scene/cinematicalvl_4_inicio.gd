extends CinematicText


func _ready():
	next_scene = "res://Scenes/niveles/Nivel4/nivel_4.tscn"
	actionNeeded = false
	narration_data = [
		[tr("lvl4_cine_01"), 3.5],
		[tr("lvl4_cine_02"), 3.0],
		[tr("lvl4_cine_03"), 3.0],
		[tr("lvl4_cine_04"), 3.5],
		[tr("lvl4_cine_05"), 3.5],
		[tr("lvl4_cine_06"), 4.0],
	];
	super._ready()
