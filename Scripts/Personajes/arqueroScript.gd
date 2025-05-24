extends Characters

class_name Archer

@onready var arrow = preload("res://Scenes/flecha.tscn")
@onready var marker = $Sprite2D/Marker2D

#const ATTACK_COOLDOWN = 0.3

var can_attack : bool = true
#var cooldown_timer: Timer

var arrow_speed = 100
var charge_time : float = 0.0
var max_charge_time : float = 2.0
var is_charging : bool = false

var extra_jump_available: bool = false

func _ready() -> void:
	max_health = 75
	speed = 250
	current_health = max_health
	
	#cooldown_timer = Timer.new()
	#cooldown_timer.wait_time = ATTACK_COOLDOWN
	#cooldown_timer.one_shot = true
	#skill_active = true
	super._ready()
	print(max_health)

func _process(delta):
	add_to_group("player")
	if is_charging:
		charge_time = min(charge_time + delta, max_charge_time)

func attack():
	if can_attack:
		is_charging = true
		charge_time = 0.0
		
		#can_attack = false
		#cooldown_timer.start()
		
		anim_state_machine.travel("ataque1")
	else:
		print("You cannot spam the bow")
	deal_damage_archer()
	
func down_attack():
	print("ataque bajo")
	anim_state_machine.travel("ataqueBajo")
func _physics_process(delta):
	super._physics_process(delta)
	var attack_attempt = Input.is_action_pressed("ataque")
		
	if controls_inverted:
		attack_attempt = Input.is_action_just_pressed("salto")
		
	if attack_attempt:
		shoot_arrow()
		is_charging = false

func shoot_arrow():
	if arrow:
		var a = arrow.instantiate()
		get_parent().add_child(a)
		a.global_position = marker.global_position
		
		var charge_multiplier = 1.0 + (charge_time / max_charge_time)
		
		a.speed = arrow_speed * charge_multiplier
		a.charge_multiplier = charge_multiplier
		
		var direction = Vector2($Sprite2D.scale.x, 0)
		a.direction = direction
		a.scale.x = abs(a.scale.x) * direction.x
		print("Arrow shot with multiplier: ", charge_multiplier)
	else:
		print("Error: arrow.tscn not found!")
	switch_state(State.IDLE)

#Para romper bloques
func deal_damage_archer():
	var space_state = get_world_2d().direct_space_state
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(18, 18)  # Cuerpo a cuerpo del arquero, algo más pequeño

	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0, global_position + Vector2($Sprite2D.scale.x * 22, -10))
	params.collision_mask = 1 << 13
	params.collide_with_bodies = true

	var result = space_state.intersect_shape(params, 10)
	for hit in result:
		if hit.collider.has_method("take_damage"):
			hit.collider.take_damage(damage)

# Lógica de salto personalizado (doble salto si skill_active)
func jump(delta):
	var jump_attempt = Input.is_action_just_pressed("salto")
	if controls_inverted:
		jump_attempt = Input.is_action_just_pressed("ataque")

	if jump_attempt or input_buffer.time_left > 0:
		if is_on_floor():
			switch_state(State.JUMP)
			coyote_jump_available = false
			if skill_active:
				extra_jump_available = true
		elif coyote_jump_available:
			switch_state(State.JUMP)
			coyote_jump_available = false
			if skill_active:
				extra_jump_available = true
		elif skill_active and extra_jump_available:
			switch_state(State.JUMP)
			extra_jump_available = false
		elif jump_attempt:
			input_buffer.start()
	
	var jump_released = Input.is_action_just_released("salto")
	if controls_inverted:
		jump_released = Input.is_action_just_released("ataque")
	
	if jump_released and velocity.y < 0:
		velocity.y = JUMP_SPEED / 2

	if not is_on_floor() and current_state not in [State.AIR_ATTACK, State.DOWN_ATTACK, State.UP_ATTACK]:
		if velocity.y < 0:
			anim_state_machine.travel("saltar")
		else:
			switch_state(State.FALL)

	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
		last_safe_position = position
	else:
		if coyote_jump_available and coyote_timer.is_stopped():
			coyote_timer.start()
		velocity.y += GRAVITY * delta
