extends Characters

class_name Archer

@onready var arrow = preload("res://Scenes/flecha.tscn")
@onready var front_marker = $Sprite2D/front
@onready var up_marker = $Sprite2D/up
@onready var down_marker = $Sprite2D/down

var can_attack : bool = true
var attack_cooldown_timer: Timer
const ATTACK_COOLDOWN := 0.1 # segundos

var arrow_speed = 200
var charge_time : float = 0.0
var max_charge_time : float = 2.0
var is_charging : bool = false

var attack_released

var extra_jump_available: bool = false

var arrow_direction := Vector2(1, 0) # Por defecto derecha

const MIN_CHARGE_TIME := 0.4 # segundos mínimos para poder disparar

func _ready() -> void:
	max_health = 75
	speed = 250
	current_health = max_health

	# Crear e inicializar el timer para el cooldown de ataque
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.wait_time = ATTACK_COOLDOWN
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.connect("timeout", Callable(self, "_on_attack_cooldown_timeout"))
	add_child(attack_cooldown_timer)

	super._ready()
	print(max_health)

func _on_attack_cooldown_timeout():
	if not is_charging:
		can_attack = true

func _process(delta):
	add_to_group("player")
	if is_charging:
		charge_time = min(charge_time + delta, max_charge_time)

func attack():
	if can_attack:
		is_charging = true
		charge_time = 0.0
		# Fijar dirección al iniciar ataque
		if Input.is_action_pressed("arriba"):
			arrow_direction = Vector2(0, -1)
		elif Input.is_action_pressed("abajo"):
			arrow_direction = Vector2(0, 1)
		else:
			arrow_direction = Vector2($Sprite2D.scale.x, 0)
		anim_state_machine.travel("ataque1")
	else:
		print("You cannot spam the bow")
		switch_state(State.IDLE)
	deal_damage_archer()
	

func down_attack():
	if can_attack:
		is_charging = true
		charge_time = 0.0
		arrow_direction = Vector2(0, 1)
		anim_state_machine.travel("ataqueBajo")
	else:
		print("You cannot spam the bow")
		switch_state(State.IDLE)
	deal_damage_archer()

func up_attack():
	if can_attack:
		is_charging = true
		charge_time = 0.0
		arrow_direction = Vector2(0, -1)
		anim_state_machine.travel("ataqueAlto")
	else:
		print("You cannot spam the bow")
		switch_state(State.IDLE)
	deal_damage_archer()

func _physics_process(delta):
	super._physics_process(delta)
	attack_released = Input.is_action_just_released("ataque")
	if controls_inverted:
		attack_released = Input.is_action_just_released("salto")

	if is_charging:
		charge_time = min(charge_time + delta, max_charge_time)
		if attack_released:
			is_charging = false
			if charge_time >= MIN_CHARGE_TIME:
				shoot_arrow()
			else:
				print("¡Carga insuficiente para disparar!")
			switch_state(State.IDLE)

func shoot_arrow():
	if not can_attack:
		return
	can_attack = false
	attack_cooldown_timer.start()

	if arrow:
		var a = arrow.instantiate()
		get_parent().add_child(a)
		if current_state == State.DOWN_ATTACK:
			a.global_position = down_marker.global_position
		elif current_state == State.UP_ATTACK:
			a.global_position = up_marker.global_position
		else:
			a.global_position = front_marker.global_position

		var charge_multiplier = 1.0 + (charge_time / max_charge_time)
		a.speed = arrow_speed * charge_multiplier
		a.charge_multiplier = charge_multiplier

		a.direction = arrow_direction.normalized()
		if arrow_direction == Vector2(0, -1):
			a.rotation = -PI / 2
		elif arrow_direction == Vector2(0, 1):
			a.rotation = PI / 2
		else:
			a.rotation = 0
			a.scale.x = abs(a.scale.x) * (arrow_direction.x if arrow_direction.x != 0 else 1)
		print("Arrow shot with multiplier: ", charge_multiplier)
	else:
		print("Error: arrow.tscn not found!")
		
		
	
	charge_time = 0.0

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


func _on_animation_player_animation_finished(anim_name):
	# Solo cambiar a IDLE si ya se soltó el botón de ataque
	if anim_name in ["ataque1", "ataqueBajo", "ataqueAlto"] and not is_charging:
		switch_state(State.IDLE)
	elif anim_name in ["ataque1", "ataqueBajo", "ataqueAlto"] and is_charging:
		# Si aún está cargando, repetir la animación
		if anim_name == "ataque1":
			anim_state_machine.travel("ataque1")
		elif anim_name == "ataqueBajo":
			anim_state_machine.travel("ataqueBajo")
		elif anim_name == "ataqueAlto":
			anim_state_machine.travel("ataqueAlto")
