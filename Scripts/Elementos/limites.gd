extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Vida que te quita el limite cuando lo tocas
		body.volver_a_posicion_segura()
	elif body.is_in_group("Enemigos"):
		body.queue_free()
