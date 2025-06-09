extends CinematicText

func _ready():
	next_scene = "res://Scenes/Niveles/Nivel2/nivel_2.tscn"
	actionNeeded = false
	narration_data = [
		[tr("lvl1_cine_01"),3.5],[tr("lvl1_cine_02"), 3.5],
		[tr("lvl1_cine_03"),3.5],[tr("lvl1_cine_04"), 3.5],
		[tr("lvl1_cine_05"),2.5],[tr("lvl1_cine_06"), 2.5],
		[tr("lvl1_cine_07"),3.5],[tr("lvl1_cine_08"), 4.5],
		[tr("lvl1_cine_09"),2.5],[tr("lvl1_cine_10"), 2.5],
		[tr("lvl1_cine_11"),2.5],[tr("lvl1_cine_12"), 4.5],
		[tr("lvl1_cine_13"),3.5],
		[tr("lvl1_cine_14"),2.5],[tr("lvl1_cine_15"), 2.5],
		[tr("lvl1_cine_16"),2.5],[tr("lvl1_cine_17"), 3.0],
		[tr("lvl1_cine_18"),4.0],[tr("lvl1_cine_19"), 2.5],
	];
	super._ready()
