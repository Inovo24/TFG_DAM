extends Node2D

#Script ARea (portal al boss)
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Ha entrado")
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/Niveles/Nivel1/batalla_boss_1.tscn")
