extends StaticBody2D


func _on_area_dano_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.recibirDaño(body.getVidaMaxima()/2)
		body.volver_a_posicion_segura()
	elif body.is_in_group("Enemigos"):
		body.queue_free()
