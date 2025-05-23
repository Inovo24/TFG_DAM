extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true
	var level_name = get_parent().level_name
	$Panel/VSplitContainer/Nivel.text = tr("lbl_nivel") +" "+level_name.replace("nivel","")
	var level = Guardado.level_progress[level_name]
	$Panel/VSplitContainer/GemasMax.text ="(" + tr("lbl_maximo_gemas")+": "+str(level["num_gems"]) + ")"
	if get_parent() is Levels:
		$Panel/VSplitContainer/Gemas.text = tr("lbl_gemas_conseguidas") + ": "+str(get_parent().collected_gems)
	else:
		$Panel/VSplitContainer/Gemas.text = tr("lbl_gemas_conseguidas") + ": "+str(Guardado.level_temporal_progress[level_name]["num_gems"])
	
	var minutos = int(level["time"]) / 60
	var segundos_restantes = int(level["time"]) % 60
	$Panel/VSplitContainer/MejorTiempo.text ="(" + tr("lbl_tiempo_minimo")+": "+"%02d:%02d" % [minutos, segundos_restantes] + ")"
	
	minutos = int(get_parent().elapsed_time) / 60
	segundos_restantes = int(get_parent().elapsed_time) % 60
	$Panel/VSplitContainer/Tiempo.text = tr("lbl_tiempo_en_completar")+": "+"%02d:%02d" % [minutos, segundos_restantes]


func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/inicio.tscn")


func _on_jugar_pressed() -> void:
	if get_parent() is Bosses:
		get_tree().paused = false
		get_parent().return_to_level()
	else:
		get_tree().paused = false
		get_tree().change_scene_to_file(get_parent().scene_file_path)
	queue_free()
