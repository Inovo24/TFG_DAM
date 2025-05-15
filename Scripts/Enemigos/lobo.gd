extends Enemies

const NORMAL_SPEED = 70
const RUN_SPEED = 220
var speed = NORMAL_SPEED
var direction = -1
const gravity = 98
var health = 100

var turning = false
var can_attack = true
var player_in_distance = false  # Is the player in the wolf's attack area?
var in_knockback := false
var knockback_duration := 0.1  # Knockback duration in seconds
var can_turn_from_rear := true

@onready var animationTree = $AnimationTree
@onready var attack_timer = $SpriteLobo/Atack/TimerAtack
@onready var turn_timer = $GiroTimer

@onready var front_ray = $SpriteLobo/Node2D/RayoDelante
@onready var rear_ray = $SpriteLobo/Node2D/RayoDetras

func _ready() -> void:
	velocity.x = -speed
	animationTree.active = true
	knockback_distance = 60
	damage = 20
	max_health = 70
	super._ready()

func _physics_process(_delta: float) -> void:
	if front_ray.is_colliding() and front_ray.get_collider().is_in_group("player"):
		speed = RUN_SPEED
	elif rear_ray.is_colliding() and can_turn_from_rear:
		start_delayed_turn()
	else:
		speed = NORMAL_SPEED
		if is_on_wall():
			if $SpriteLobo.scale.x == 1:
				direction = 1
			else:
				direction = -1
			turning = true
	
	velocity.y += gravity

	if not in_knockback:
		velocity.x = speed * direction

	if turning:
		turn_wolf()
		turning = false

	move_and_slide()

	if can_attack and player_in_distance:
		attack()

func _on_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_distance = false

func turn_wolf():
	if velocity.x < 0:
		$SpriteLobo.scale.x = 1
	elif velocity.x > 0:
		$SpriteLobo.scale.x = -1

func attack():
	can_attack = false
	attack_timer.start()
	player.take_damage(damage)

	# Knockback after attacking
	in_knockback = true
	velocity.x = -direction * 100  # Adjust knockback strength if needed
	await get_tree().create_timer(knockback_duration).timeout
	in_knockback = false
	
	_knockback(knockback_damage)

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_turn_timer_timeout() -> void:
	direction = -1 * direction
	turning = true

func start_delayed_turn() -> void:
	can_turn_from_rear = false
	await get_tree().create_timer(0.5).timeout  # Wait before turning
	direction *= -1
	turning = true
	await get_tree().create_timer(2.0).timeout  # Cooldown before turning again
	can_turn_from_rear = true


func _on_attack_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_in_distance = true
