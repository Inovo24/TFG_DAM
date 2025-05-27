extends Enemies
class_name ArcherEnemy

#region NODOS Y ESCENA
@onready var player_detection: Area2D = $playerDetection
@onready var suelo_detector: Area2D = $SueloDetector
@onready var obstacle_check: RayCast2D = $ObstacleChecker
@onready var sonido_daño: AudioStreamPlayer2D = $Sonido_daño
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var arrow_scene: PackedScene = preload("res://Scenes/Elementos/flecha_esqueleto.tscn")
#endregion

#region PARÁMETROS
@export var speed: float = 100.0
@export var gravity: float = 600.0
@export var attack_cooldown: float = 1.5
@export var idle_time: float = 1.0
@export var arrow_speed: float = 400.0
@export var attack_margin: float = 40.0
#endregion

#region ESTADOS
enum State { PATROL, IDLE, CHASE, ATTACK, RETURN }
var state: State = State.PATROL
#endregion

#region VARIABLES
var patrol_point_a: Vector2
var patrol_point_b: Vector2
var patrol_target: Vector2
var attack_timer: Timer
var idle_timer: Timer
var suelo_en_contacto := false
var can_attack := true
#endregion

func _ready():
	damage = 10
	max_health = 50
	current_health = max_health
	num_coins = 2

	super._ready()

	patrol_point_a = global_position + Vector2(-100, 0)
	patrol_point_b = global_position + Vector2(100, 0)
	patrol_target = patrol_point_a

	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	idle_timer = Timer.new()
	idle_timer.wait_time = idle_time
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_idle_timeout)
	add_child(idle_timer)

func _physics_process(delta):
	if is_taking_damage:
		return

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
			if player_detection.get_overlapping_bodies().has(player):
				state = State.ATTACK
			else:
				_chase_player(delta)
		State.ATTACK:
			if not is_instance_valid(player):
				state = State.RETURN
				return
			_face_target(player.position)
			if not player_detection.get_overlapping_bodies().has(player):
				state = State.CHASE
			else:
				velocity.x = 0
				velocity.y += gravity * delta
				move_and_slide()
				if can_attack:
					_attack()
		State.RETURN:
			_return_to_patrol(delta)

#region MOVIMIENTO

func _patrol(delta):
	if is_taking_damage or not idle_timer.is_stopped():
		return

	if obstacle_check.is_colliding():
		_flip_direction()

	_move_towards(patrol_target, delta)
	sprite.play("idle")

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
	sprite.play("idle")
	if position.distance_to(patrol_target) < 5.0:
		state = State.PATROL

func _chase_player(delta):
	_move_towards(player.position - Vector2(attack_margin * sign(player.position.x - position.x), 0), delta)
	sprite.play("idle")

func _move_towards(target: Vector2, delta):
	var dir = (target - position).normalized()
	var current_speed = speed * (0.5 if slow_mode else 1.0)

	if suelo_en_contacto:
		velocity.x = dir.x * current_speed
	else:
		velocity.x = 0

	velocity.y += gravity * delta
	_face_target(target)
	_rotate_raycast()
	move_and_slide()

#endregion

#region ORIENTACIÓN

func _face_target(target: Vector2):
	sprite.flip_h = target.x < position.x

func _flip_direction():
	patrol_target = patrol_point_b if patrol_target == patrol_point_a else patrol_point_a
	sprite.flip_h = not sprite.flip_h
	_rotate_raycast()

func _rotate_raycast():
	var direction = -1 if sprite.flip_h else 1
	obstacle_check.target_position.x = abs(obstacle_check.target_position.x) * direction

#endregion

#region ATAQUE

func _attack():
	can_attack = false
	sprite.play("ataque")
	_shoot_arrow()
	attack_timer.start()

func _on_attack_timer_timeout():
	can_attack = true

func _shoot_arrow():
	if not is_instance_valid(player): return
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	var offset_x = -10 if sprite.flip_h else 10
	arrow.global_position = global_position + Vector2(offset_x, -10)
	var dir = (player.position - arrow.global_position).normalized()
	arrow.direction = dir
	arrow.speed = arrow_speed
	arrow.atack_player = true

#endregion

#region DETECCIÓN

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Characters:
		player = body

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		if state != State.ATTACK:
			state = State.RETURN

func _on_suelo_detector_body_entered(body: Node2D) -> void:
	suelo_en_contacto = true

func _on_suelo_detector_body_exited(body: Node2D) -> void:
	suelo_en_contacto = false

#endregion

#region EFECTOS

func _on_animated_sprite_2d_animation_looped() -> void:
	if sprite.animation == "ataque":
		sprite.play("idle")
	sonido_daño.play()

#endregion
