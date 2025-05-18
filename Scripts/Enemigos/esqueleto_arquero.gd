extends Enemies
class_name ArcherEnemy

@onready var player_detection: Area2D = $playerDetection

# --- Zona de patrulla ---
@export var patrol_point_a: Vector2
@export var patrol_point_b: Vector2

# --- Movimiento y detección ---
@export var speed: float = 100.0
@export var gravity: float = 600.0
@export var jump_force: float = -300.0
@export var detection_radius: float = 200.0
@export var attack_radius: float = 150.0
@export var attack_cooldown: float = 1.5
@export var idle_time: float = 1.0

@onready var floor_check: RayCast2D = $FloorChecker
@onready var obstacle_check: RayCast2D = $ObstacleChecker

# --- Flechas ---
@export var arrow_scene: PackedScene = preload("res://Scenes/Enemigos/Esqueleto_Arquero/flecha_esquelo.tscn")
@export var arrow_speed: float = 400.0

# --- Estados ---
enum State { PATROL, IDLE, CHASE, ATTACK, RETURN }
var state: State = State.PATROL

# --- Internos ---
var patrol_target: Vector2
var sprite: AnimatedSprite2D
var attack_timer: Timer
var idle_timer: Timer

func _ready():
	sprite = $AnimatedSprite2D
	patrol_target = patrol_point_a

	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = false
	add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.start()

	idle_timer = Timer.new()
	idle_timer.wait_time = idle_time
	idle_timer.one_shot = true
	add_child(idle_timer)
	idle_timer.timeout.connect(_on_idle_timeout)

	player_detection.body_entered.connect(_on_player_detection_body_entered)
	player_detection.body_exited.connect(_on_player_detection_body_exited)

func _physics_process(delta):
	# --- PRIORIDAD: jugador dentro del área siempre activa persecución ---
	if player and state != State.ATTACK:
		state = State.CHASE

	match state:
		State.PATROL:
			_patrol(delta)

		State.IDLE:
			velocity.x = 0
			velocity.y += gravity * delta
			sprite.play("idle")
			move_and_slide()

		State.CHASE:
			if not is_instance_valid(player):
				state = State.RETURN
				player = null
				return

			var dist = position.distance_to(player.position)
			if dist <= attack_radius:
				state = State.ATTACK
			else:
				_chase_player(delta)

		State.ATTACK:
			if not is_instance_valid(player):
				state = State.RETURN
				player = null
				return

			sprite.play("attack")
			_face_target(player.position)

			if position.distance_to(player.position) > attack_radius:
				state = State.CHASE

			velocity.x = 0
			velocity.y += gravity * delta
			move_and_slide()

		State.RETURN:
			_return_to_patrol(delta)

# --- Patrulla ---
func _patrol(delta):
	if not idle_timer.is_stopped():
		return
	_move_towards(patrol_target, delta)
	sprite.play("walk")
	if position.distance_to(patrol_target) < 5.0:
		state = State.IDLE
		idle_timer.start()

func _on_idle_timeout():
	patrol_target = patrol_point_b if patrol_target == patrol_point_a else patrol_point_a
	state = State.PATROL

func _return_to_patrol(delta):
	var dist_a = position.distance_to(patrol_point_a)
	var dist_b = position.distance_to(patrol_point_b)
	patrol_target = patrol_point_a if dist_a < dist_b else patrol_point_b
	_move_towards(patrol_target, delta)
	sprite.play("walk")
	if position.distance_to(patrol_target) < 5.0:
		state = State.PATROL

func _chase_player(delta):
	if not is_instance_valid(player): return
	_move_towards(player.position, delta)
	sprite.play("walk")

# --- Movimiento con salto e impulso horizontal ---
func _move_towards(target: Vector2, delta):
	var dir = (target - position).normalized()
	var direction_sign = sign(dir.x)
	var current_speed = speed * (0.5 if slow_mode else 1.0)

	floor_check.target_position = Vector2(10.0 * direction_sign, 10.0)
	obstacle_check.target_position = Vector2(12.0 * direction_sign, 2.0)

	var jumped = false
	var on_ground = is_on_floor()
	var obstacle_ahead = obstacle_check.is_colliding()

	if on_ground and obstacle_ahead and not slow_mode:
		velocity.y = jump_force
		velocity.x = dir.x * current_speed
		jumped = true

	if not jumped:
		if floor_check.is_colliding() or state == State.CHASE:
			velocity.x = dir.x * current_speed
		else:
			velocity.x = 0

	if not jumped:
		velocity.y += gravity * delta

	_face_target(target)
	move_and_slide()

func _face_target(target: Vector2):
	sprite.flip_h = target.x < position.x

# --- Ataque ---
func _on_attack_timer_timeout():
	if state == State.ATTACK and is_instance_valid(player):
		_shoot_arrow()

func _shoot_arrow():
	if not is_instance_valid(player): return
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	var dir = (player.position - global_position).normalized()
	arrow.direction = dir
	arrow.speed = arrow_speed

# --- Recibir daño ---
func receive_damage(damage_received: int):
	current_health -= damage_received
	sprite.play("damage")

	if current_health <= 0:
		for i in range(num_coins):
			var moneda = preload("res://Scenes/Elementos/gema_drop.tscn").instantiate()
			get_parent().add_child(moneda)
			moneda.global_position = global_position + Vector2(i, -10)
		queue_free()

	_knockback(knockback_receive_damage)
	_start_pause_and_slow()

# --- Área de detección del jugador ---
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		if state != State.ATTACK:
			state = State.RETURN
