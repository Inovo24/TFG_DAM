extends Node2D

@export var speed = 160.0
var current_speed = 0.0
@export var daño: int = 40

func _physics_process(delta: float) -> void:
	position.y += current_speed * delta

func caer() -> void:
	current_speed = speed
	await get_tree().create_timer(5).timeout
	queue_free()


func _on_detectar_jugador_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		caer()
		print("jugador detectado")
	elif body.is_in_group("Enemigos"):
		caer()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.recibirDaño(daño)
		body.volver_a_posicion_segura()


	elif body.is_in_group("Enemigos"):
		current_speed = 0.0
		body.queue_free()
		queue_free()
