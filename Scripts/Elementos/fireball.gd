extends Area2D

@export var speed: float = 100
var player
var damage= 20
const time_life = 3.5
var disabled = false

func _ready() -> void:
	add_to_group("Enemies")
	print("inst")
	$Timer.wait_time = time_life
	$Timer.start()

func initialize(_player, _disabled):
	player = _player
	disabled = _disabled
	if disabled:
		$Sprite2D.modulate = Color(1, 1, 1, 0.9) 

func _physics_process(delta):
	if player and is_instance_valid(player):
		var direction = ((player.global_position - Vector2(0,-15)) - global_position).normalized()
		position += direction * speed * delta
		rotation = direction.angle()
	

func _on_body_entered(body):
	if body.is_in_group("player") and !disabled:
		body.take_damage(damage)
		queue_free()
	else:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
