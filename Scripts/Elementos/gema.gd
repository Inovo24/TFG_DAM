extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Personajes:
		get_tree().current_scene.recoger_moneda()
		queue_free()
