extends CinematicText

func _ready():
	next_scene = "res://Scenes/niveles/Nivel3/nivel_3.tscn"
	narration_data = [
		[tr("lvl3_loki_01"), 3.5],[tr("lvl3_loki_02"), 3.5],
		[tr("lvl3_loki_03"), 3.5],[tr("lvl3_loki_04"), 2.5],
		[tr("lvl3_loki_05"), 4.5],[tr("lvl3_loki_06"), 3.5],
		[tr("lvl3_loki_07"), 2.5],[tr("lvl3_loki_08"), 3.5],
		[tr("lvl3_loki_09"), 3.0],[tr("lvl3_loki_10"), 4.0],
		[tr("lvl3_loki_11"), 2.5],[tr("lvl3_loki_12"), 2.5],
		[tr("lvl3_loki_13"), 2.5],[tr("lvl3_loki_14"), 3.5],
		[tr("lvl3_loki_15"), 3.5],[tr("lvl3_loki_16"), 3.5],
		[tr("lvl3_loki_17"), 2.5],
	];
	super._ready()
