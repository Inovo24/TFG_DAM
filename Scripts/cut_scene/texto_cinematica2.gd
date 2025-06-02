extends CinematicText


func _ready():
	actionNeeded = false
	narration_data = [
		[tr("lvl2_cine_01"), 3.5],
		[tr("lvl2_cine_02"), 3.0],
		[tr("lvl2_cine_03"), 3.5],
		[tr("lvl2_cine_04"), 3.5],
		[tr("lvl2_cine_05"), 3.5],
	];
	super._ready()
