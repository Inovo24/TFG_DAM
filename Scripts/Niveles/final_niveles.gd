extends Area2D

@onready var endMenu = preload("res://Scenes/Niveles/menu_fin_nivel.tscn")

func _on_body_entered(body):
	print("dentro")
	if body.is_in_group("player"):
		get_parent().save_data()
		
		get_parent().add_child(endMenu.instantiate())
		#
		#get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
