extends Area2D




func _on_body_entered(body):
	if body.is_in_group("player"):
		get_parent().collect_sword()
		print("adios")
		queue_free()
