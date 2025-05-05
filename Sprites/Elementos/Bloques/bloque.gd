extends CharacterBody2D

@export var gravity := 1200.0

func _physics_process(delta):
	# Aplicar gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# Mover el cuerpo con colisiones
	move_and_slide()
