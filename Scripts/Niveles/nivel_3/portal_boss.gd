extends Node2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Ha entrado")
	if body.is_in_group("player"):
		get_parent().get_parent().save_data()
		get_tree().change_scene_to_file("res://Scenes/Niveles/Nivel3/batalla_boss_3.tscn")
