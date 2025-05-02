extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Vida que te quita el limite cuando lo tocas
		#body.return_to_safe_position()
		body.return_to_checkpoint()
		body.can_move = false
		await get_tree().create_timer(0.5).timeout
		body.can_move = true
	elif body.is_in_group("Enemigos"):
		body.queue_free()
