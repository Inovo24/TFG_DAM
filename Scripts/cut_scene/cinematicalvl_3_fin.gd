extends CinematicText


func _ready():
	actionNeeded = false
	narration_data = [
	[tr("lvl3_cine_01"), 3.5],[tr("lvl3_cine_02"), 3.5],
	[tr("lvl3_cine_03"), 3.5],[tr("lvl3_cine_04"), 3.5],
	[tr("lvl3_cine_05"), 3.5],
	[tr("lvl3_cine_06"), 3.5],[tr("lvl3_cine_07"), 3.5],
	[tr("lvl3_cine_08"), 3.5],
	[tr("lvl3_cine_09"), 3.5],[tr("lvl3_cine_10"), 3.5],
	[tr("lvl3_cine_11"), 3.5],[tr("lvl3_cine_12"), 3.5],
	[tr("lvl3_cine_13"), 3.5],[tr("lvl3_cine_14"), 2.5],
	[tr("lvl3_cine_15"), 2.5],[tr("lvl3_cine_16"), 2.5],
	[tr("lvl3_cine_17"), 2.5],
	];
	super._ready()
