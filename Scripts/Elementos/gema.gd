extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Characters:
		var level = get_tree().current_scene
		if level.has_method("collect_coin"):
			level.collect_coin()
		queue_free()
