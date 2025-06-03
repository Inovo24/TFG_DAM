extends Area2D

#@onready var endMenu = preload("res://Scenes/Niveles/menu_fin_nivel.tscn")

func _on_body_entered(body):
	print("dentro")
	if body.is_in_group("player"):
		get_parent().save_data()
		match get_parent().level_name:
			"nivel2":
				SceneTransition.change_scene("res://Scenes/cut_scenes/cinematicalvl_2.tscn")
			"nivel4":
				SceneTransition.change_scene("res://Scenes/cut_scenes/cinematicalvl_4_fin.tscn")
