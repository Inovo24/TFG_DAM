extends CharacterBody2D
class_name Enemies

var damage = 10
var max_health = 0
var current_health

var knockback_damage = 0.5
var knockback_receive_damage = 1
var knockback_distance = 30

var player
var slow_mode = false
var slow_timer: Timer
var pause_timer: Timer
var knockback_tween: Tween

func _ready():
	add_to_group("Enemies")
	current_health = max_health
	# Timer for slowness after attacking or receiving damage
	slow_timer = Timer.new()
	slow_timer.wait_time = 2
	slow_timer.one_shot = true
	slow_timer.timeout.connect(_end_slow_effect)
	add_child(slow_timer)

	# Timer for briefly pausing movement
	pause_timer = Timer.new()
	pause_timer.wait_time = 0.5
	pause_timer.one_shot = true
	pause_timer.timeout.connect(Callable())
	add_child(pause_timer)
	
	knockback_tween = create_tween()

func receive_damage(damage_received: int):
	current_health = current_health - damage_received
	print(current_health)
	
	if current_health <= 0:
		queue_free()
	
	_knockback(knockback_receive_damage)

func _start_pause_and_slow():
	pause_timer.start()
	slow_mode = true
	slow_timer.start()

func _end_slow_effect():
	slow_mode = false

func _knockback(knockback: float):
	var knockback_dir = (position - player.position).normalized()
	var destination = position + knockback_dir * knockback_distance
	
	# Check collision before applying tween
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, destination)
	query.exclude = [self]  # Exclude the enemy itself
	var result = space_state.intersect_ray(query)

	if result:
		# Collision detected, adjust destination to collision point
		destination = result.position

	# Apply tween to valid destination
	knockback_tween = create_tween()
	knockback_tween.tween_property(self, "position", destination, knockback).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
