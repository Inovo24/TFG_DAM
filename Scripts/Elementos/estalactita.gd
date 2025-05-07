extends Node2D

@onready var raycastBreak = $DetectarSueloRomperse
@export var speed = 160.0
var current_speed = 0.0
@export var damage: int = 40

func _physics_process(delta: float) -> void:
	if current_speed != 0.0:
		position.y += current_speed * delta
		if raycastBreak.is_colliding():
			break_on_impact()

func fall() -> void:
	current_speed = speed
	await get_tree().create_timer(5).timeout
	queue_free()

func break_on_impact() -> void:
	current_speed = 0.0
	# Si se quiere animacion al romperse, la pones aqui @Mateo o @Camilo
	queue_free()

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		fall()
		print("player detected")
	elif body.is_in_group("enemies"):
		fall()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		body.return_to_safe_position()
	elif body.is_in_group("enemies"):
		current_speed = 0.0
		body.queue_free()
		queue_free()
