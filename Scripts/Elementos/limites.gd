extends StaticBody2D

@onready var death_menu = preload("res://Scenes/Niveles/menu_muerte.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Vida que te quita el limite cuando lo tocas
		#body.return_to_safe_position()
		'''
		if body.life_count > 1:
			body.return_to_checkpoint()
			body.life_count -= 1
		'''
		body.take_damage(body.max_health)
		get_tree().paused = true
		'''
		body.can_move = false
		await get_tree().create_timer(0.5).timeout
		body.can_move = true
		'''
	elif body.is_in_group("Enemies"):
		body.queue_free()
