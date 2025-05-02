extends StaticBody2D

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(body.getMaxHealth() / 2)
		body.return_to_safe_position()
		body.can_move = false
		await get_tree().create_timer(0.5).timeout
		body.can_move = true
	elif body.is_in_group("Enemies"):
		body.queue_free()
