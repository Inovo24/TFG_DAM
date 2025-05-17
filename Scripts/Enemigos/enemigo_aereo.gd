extends Enemies

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $Area2D  # General detection area
@onready var attack_area: Area2D = $AttackArea  # Attack area

var SPEED = 60
var dir: Vector2 = Vector2.ZERO
var is_chasing: bool = false
var is_attacking: bool = false

var attack_timer: Timer  # Timer for repeated attacks

func _ready() -> void:
	damage = 10
	max_health = 50
	num_coins = 2
	
	timer.start()  # Start patrol timer

	# Timer for repeated damage
	attack_timer = Timer.new()
	attack_timer.wait_time = 1  # Attacks every 1 second
	attack_timer.one_shot = false  # Repeats the attack
	attack_timer.timeout.connect(_perform_attack)  # Connects the function that applies the damage
	add_child(attack_timer)
	
	super._ready()

func _process(delta: float) -> void:
	move()
	handle_animation()

func handle_animation():
	if is_attacking:
		animated_sprite_2d.play("attack")
	elif velocity.length() > 0:
		animated_sprite_2d.play("flying")

	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false

func move():
	if pause_timer.is_stopped():
		if is_chasing and player != null:
			var direction = (player.position - position).normalized()
			var current_speed = SPEED if not slow_mode else SPEED / 2
			velocity = direction * current_speed
		elif not is_attacking:
			var current_speed = SPEED if not slow_mode else SPEED / 2
			velocity = dir * current_speed
	else:
		velocity = Vector2.ZERO  # Does not move during pause

	move_and_slide()

func _on_timer_timeout() -> void:
	if not is_chasing and not is_attacking:  # Only change direction if not in combat
		dir = choose([Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP])
		#print("New direction:", dir)

	timer.wait_time = choose([1.0, 1.5, 2.0])
	timer.start()

func choose(array):
	array.shuffle()
	return array[0]

# --- PLAYER DETECTION ---
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Characters:
		SPEED *= 2
		player = body
		is_chasing = true
		#print("Body detected, starting chase")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Characters:
		SPEED /= 2
		is_chasing = false
		player = null
		#print("Body left the area, stopping chase")
		_resume_patrol()  # Resume patrol when stopping chase

# --- ATTACK AREA DETECTION ---
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Characters:
		SPEED += 10
		is_attacking = true  # Start attacking
		
		body.take_damage(damage)  # Apply damage immediately
		
		attack_timer.start()  # Start timer for consecutive attacks
		_knockback(knockback_duration)
		#print("Player in attack area:", body.name)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Characters:
		SPEED -= 10
		#print("Player left the attack area:", body.name)
		is_attacking = false  # Stop attacking
		attack_timer.stop()  # Stop attack timer
		_resume_patrol()  # Resume patrol when stopping attack

# --- Repeated attack function ---
func _perform_attack():
	if player:
		player.take_damage(damage)  # Apply damage repeatedly
		#print("Attacking player, remaining health:", player.get_current_health())
		
		_knockback(knockback_duration)

# --- Resume patrol if no players nearby ---
func _resume_patrol():
	if not is_chasing and not is_attacking:  # If not attacking or chasing, patrol
		timer.start()
