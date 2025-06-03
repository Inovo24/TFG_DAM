extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true
	var level_name = Globales.data_current_level["level_name"]
	$Panel/VSplitContainer/Nivel.text = tr("lbl_nivel") +" "+level_name.replace("nivel","")
	var level = Guardado.level_progress[level_name]
	$Panel/VSplitContainer/GemasMax.text ="(" + tr("lbl_maximo_gemas")+": "+str(level["num_gems"]) + ")"
	
	$Panel/VSplitContainer/Gemas.text = tr("lbl_gemas_conseguidas") + ": "+str(Globales.data_current_level["num_gems"])
	
	var minutos = int(level["time"]) / 60
	var segundos_restantes = int(level["time"]) % 60
	$Panel/VSplitContainer/MejorTiempo.text ="(" + tr("lbl_tiempo_minimo")+": "+"%02d:%02d" % [minutos, segundos_restantes] + ")"
	#var time = get_parent().elapsed_time + get_parent().healthBar.default
	var time = Globales.data_current_level["time"]
	minutos = int(time) / 60
	segundos_restantes = int(time) % 60
	$Panel/VSplitContainer/Tiempo.text = tr("lbl_tiempo_en_completar")+": "+"%02d:%02d" % [minutos, segundos_restantes]


func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/inicio.tscn")


func _on_jugar_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(Globales.data_current_level["scence_to_return"])
	queue_free()
