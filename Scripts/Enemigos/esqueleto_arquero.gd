extends Enemies
class_name ArcherEnemy

@onready var player_detection: Area2D = $playerDetection

# --- Vida ---

# --- Zona de patrulla ---
var patrol_point_a: Vector2
var patrol_point_b: Vector2

# --- Movimiento y detección ---
@export var speed: float = 100.0
@export var gravity: float = 600.0
@export var jump_force: float = -220.0  # salto menos vertical
@export var detection_radius: float = 200.0
@export var attack_radius: float = 150.0
@export var attack_cooldown: float = 1.5
@export var idle_time: float = 1.0

@onready var floor_check: RayCast2D = $FloorChecker
@onready var obstacle_check: RayCast2D = $ObstacleChecker
@onready var obstacle_checker_2: RayCast2D = $ObstacleChecker2

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
var jump_counter := 0
var jump_timer: Timer

func _ready():
	damage = 10
	max_health = 50
	current_health = max_health
	num_coins = 2

	super._ready()

	# Definir puntos de patrulla fijos a 100 unidades del punto de inicio
	patrol_point_a = global_position + Vector2(-100, 0)
	patrol_point_b = global_position + Vector2(100, 0)
	# Definir puntos fijos de patrulla relativos a la posición inicial
	patrol_point_a = global_position + Vector2(-100, 0)
	patrol_point_b = global_position + Vector2(100, 0)
	sprite = $AnimatedSprite2D
	patrol_target = patrol_point_a

	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)
	attack_timer.start()

	idle_timer = Timer.new()
	idle_timer.wait_time = idle_time
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_idle_timeout)
	add_child(idle_timer)

	jump_timer = Timer.new()
	jump_timer.wait_time = 1.0
	jump_timer.one_shot = true
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	add_child(jump_timer)

	player_detection.body_entered.connect(_on_player_detection_body_entered)
	player_detection.body_exited.connect(_on_player_detection_body_exited)

func _physics_process(delta):
	_update_raycast_direction()
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
				return

			var dist = position.distance_to(player.position)
			if dist <= attack_radius:
				state = State.ATTACK
			else:
				_chase_player(delta)

		State.ATTACK:
			if not is_instance_valid(player):
				state = State.RETURN
				return

			_face_target(player.position)

			if position.distance_to(player.position) > attack_radius:
				state = State.CHASE

			var offset = player.position + Vector2(sign(player.position.x - position.x) * 20.0, 0)
			_move_towards(offset, delta)


		State.RETURN:
			_return_to_patrol(delta)

func _patrol(delta):
	if not idle_timer.is_stopped():
		return

	# Limitar patrullaje dentro del área
	if position.distance_to(patrol_point_a) > 300 or position.distance_to(patrol_point_b) > 300:
		state = State.RETURN
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

func _move_towards(target: Vector2, delta):
	if sprite.animation != "attack":
		sprite.play("walk")
	var dir = (target - position).normalized()
	var direction_sign = sign(dir.x)
	_update_raycast_direction(direction_sign)
	var current_speed = speed * (0.5 if slow_mode else 1.0)

	var jumped = false
	var on_ground = is_on_floor()
	var obstacle_ahead = false
	if obstacle_check.is_colliding():
		obstacle_ahead = true
	elif not obstacle_check.is_colliding() and obstacle_checker_2.is_colliding() and floor_check.is_colliding():
		# Solo avanzar, no saltar, al detectar suelo más adelante
		velocity.x = dir.x * current_speed


	if on_ground and obstacle_check.is_colliding():
		# Salto normal al detectar obstáculo real
		velocity.y = jump_force
		velocity.x = dir.x * current_speed * 2.2  # se impulsa en salto automáticamente
		jumped = true
		jump_counter += 1
		if jump_counter >= 3:
			if jump_timer.is_stopped():
				jump_timer.start()
			floor_check.target_position.y += 4.0
			obstacle_check.target_position.y += 4.0
		

		if jumped:
			velocity.x = dir.x * current_speed
		if not jumped:
			if floor_check.is_colliding() or state == State.CHASE:
				velocity.x = dir.x * current_speed
			elif not obstacle_check.is_colliding() and obstacle_checker_2.is_colliding():
				# Avance suave en bajada por pendiente
				velocity.x = dir.x * current_speed
			else:
				velocity.x = 0
		


	if not jumped:
		velocity.y += gravity * delta

	_face_target(target)
	move_and_slide()

func _update_raycast_direction(direction_sign: int = -999):
	if direction_sign == -999:
		direction_sign = 1 if not sprite.flip_h else -1

	# Mantener siempre las posiciones en (-2, 18)
	floor_check.target_position = Vector2(10.0 * direction_sign, 18.0)
	obstacle_check.target_position = Vector2(12.0 * direction_sign, 2.0)

	# Forzar dirección manual del segundo RayCast según el giro
	if direction_sign == 1:
		obstacle_checker_2.position = Vector2(-2, 18)
		obstacle_checker_2.target_position = Vector2(3.0, 10.0)
	else:
		obstacle_checker_2.position = Vector2(-2, 18)
		obstacle_checker_2.target_position = Vector2(-3.0, 10.0)


func _face_target(target: Vector2):
	sprite.flip_h = target.x < position.x

func _on_attack_timer_timeout():
	if state == State.ATTACK and is_instance_valid(player):
		if sprite.animation != "attack":
			sprite.play("attack")
		_shoot_arrow()

func _shoot_arrow():
	if not is_instance_valid(player): return
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	var dir = (player.position - global_position).normalized()
	arrow.direction = dir
	arrow.speed = arrow_speed
	arrow.atack_player = true

func receive_damage(damage_received: int):
	sprite.play("damage")
	current_health -= damage_received
	

	if current_health <= 0:
		for i in range(num_coins):
			var moneda = preload("res://Scenes/Elementos/gema_drop.tscn").instantiate()
			get_parent().add_child(moneda)
			moneda.global_position = global_position + Vector2(i, -10)
		queue_free()

	_knockback(knockback_receive_damage)
	_start_pause_and_slow()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Characters:
		player = body

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		if state != State.ATTACK:
			state = State.RETURN

func _on_jump_timer_timeout():
	jump_counter = 0

	# Forzar avance si sigue atascado saltando
	if is_instance_valid(player):
		velocity.x += 20.0 * sign(player.position.x - position.x)
	else:
		velocity.x += 20.0
func _knockback(knockback: float):
	sprite.stop()
	sprite.play("damage")
	if not is_instance_valid(player):
		return

	var knockback_dir = (position - player.position).normalized()
	var reduced_distance = 10  # 🔽 menor distancia
	var destination = position + knockback_dir * reduced_distance

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, destination)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)

	if result:
		destination = result.position

	# Aplicar un tween más corto
	if knockback_tween and knockback_tween.is_running():
		knockback_tween.kill()

	knockback_tween = create_tween()
	knockback_tween.tween_property(self, "position", destination, 0.3)  
