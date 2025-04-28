extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Personajes:
		var nivel = get_tree().current_scene
		if nivel.has_method("recoger_moneda"):
			nivel.recoger_moneda()
		queue_free()
