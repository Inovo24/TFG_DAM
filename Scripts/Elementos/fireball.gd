extends Area2D

@export var speed: float = 100
var player
var damage= 20
const time_life = 3.5

func _ready() -> void:
	add_to_group("Enemies")
	print("inst")
	$Timer.wait_time = time_life
	$Timer.start()

func initialize(_player):
	player = _player

func _physics_process(delta):
	if player and is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		position += direction * speed * delta
		rotation = direction.angle()
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
	else:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
