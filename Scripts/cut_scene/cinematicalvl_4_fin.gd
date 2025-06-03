extends CinematicText


func _ready():
	actionNeeded = false
	narration_data = [
		[tr("lvl4_cine_07"), 2.5],
		[tr("lvl4_cine_08"), 3.5],
		[tr("lvl4_cine_09"), 3.0],
		[tr("lvl4_cine_10"), 3.0],
		[tr("lvl4_cine_11"), 3.5],
		[tr("lvl4_cine_12"), 3.0],
		[tr("lvl4_cine_13"), 3.5],
	];
	super._ready()
