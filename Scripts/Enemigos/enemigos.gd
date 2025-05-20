extends CharacterBody2D
class_name Enemies

var damage = 10
var max_health = 0
var current_health
var is_taking_damage := false

var knockback_duration = 1.5
var knockback_receive_damage = 1
var knockback_distance = 30

var num_coins = 1
var player
var slow_mode = false
var slow_timer: Timer
var pause_timer: Timer
var knockback_tween: Tween

var animPlayer: AnimationPlayer
var animation_tree: AnimationTree
var anim_state_machine
func _ready():
	add_to_group("Enemies")
	current_health = max_health
		# Asignaciones seguras
	animPlayer = get_node_or_null("AnimationPlayer")
	animation_tree = get_node_or_null("AnimationTree")
	if animation_tree:
		anim_state_machine = animation_tree.get("parameters/playback")
	
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
	current_health -= damage_received
	if is_taking_damage:
		return

	is_taking_damage = true

	# Referencia para restaurar animación después del daño (solo si hay AnimationTree)
	var previous_anim = ""
	if animation_tree and anim_state_machine:
		previous_anim = anim_state_machine.get_current_node()

	# 1. Reproducir animación de daño
	if animPlayer and animPlayer.has_animation("daño"):
		animPlayer.play("daño")

	# 2. Reproducir en AnimatedSprite2D si está presente
	if has_node("AnimatedSprite2D"):
		var sprite = $AnimatedSprite2D
		if "daño" in sprite.sprite_frames.get_animation_names():
			sprite.play("daño")

	# 3. Reproducir en AnimationTree si está activo
	if animation_tree and anim_state_machine:
		anim_state_machine.travel("daño")

	# 4. Espera para el efecto de daño (animación breve)
	await get_tree().create_timer(0.15).timeout

	# 5. Restaurar animación anterior (solo si no está muerto y había AnimationTree)
	if current_health > 0 and previous_anim != "":
		anim_state_machine.travel(previous_anim)

	is_taking_damage = false

	# 6. Si muere, soltar monedas y desaparecer
	if current_health <= 0:
		for i in range(num_coins):
			var moneda = preload("res://Scenes/Elementos/gema_drop.tscn").instantiate()
			get_parent().add_child(moneda)
			moneda.global_position = global_position + Vector2(i, -10)
		queue_free()

	# 7. Aplicar retroceso
	_knockback(knockback_receive_damage)

func _start_pause_and_slow():
	pause_timer.start()
	slow_mode = true
	slow_timer.start()

func _end_slow_effect():
	slow_mode = false

func _knockback(knockback: float):
	player = Globales.get_player()
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
