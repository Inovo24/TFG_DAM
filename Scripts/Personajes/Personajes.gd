extends CharacterBody2D
class_name Characters

const JUMP_SPEED = -400.0
const GRAVITY = 1500

const COYOTE_TIME = 0.08
const INPUT_BUFFER_PATIENCE = 0.2
const COMBO_TIME = 0.8

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true
var combo_timer : Timer

var controls_inverted := false

var is_taking_damage := false
var max_health = 125
var current_health
var life_count = 3
var remaining_lives
var damage = 10
var speed = 200
var push_force = 80.0
var initial_speed

var thorns_touching = 0
var secretAreas =0

var combo_count = 0
var next_attack : bool = false
@onready var sprite = $Sprite2D
@onready var animPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var anim_state_machine = animation_tree.get("parameters/playback")
@onready var anim_appearing = preload("res://Scenes/Elementos/Decoracion/EfectoAparecer.tscn")

@onready var sfx_run = $SFX_Run
@onready var sfx_jump = $SFX_Jump
@onready var sfx_attack = $SFX_Attack
@onready var sfx_damaged = $SFX_Damaged

enum State { IDLE, RUN, JUMP, FALL, ATTACK, AIR_ATTACK, UP_ATTACK, DOWN_ATTACK, DAMAGE, WALL_CLIMB  }
var current_state : State = State.IDLE
var previous_state : State = State.IDLE

var last_safe_position: Vector2
var checkpoint_position: Vector2
var has_checkpoint = false
var skill_active = false

var can_move = true
var in_death = false

@onready var death_menu = preload("res://Scenes/Niveles/menu_muerte.tscn")

func _ready():
	add_to_group("player")
	remaining_lives = life_count
	current_health = max_health
	animation_tree.active = true
	switch_state(State.IDLE)

	initial_speed = speed

	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)

	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

	combo_timer = Timer.new()
	combo_timer.wait_time = COMBO_TIME
	combo_timer.one_shot = true
	add_child(combo_timer)
	combo_timer.timeout.connect(combo_timeout)

	Globales.character = self
	
	if Guardado.level_progress["nivel4"]["hecho"]:
		skill_active = true

func _physics_process(delta):
	#print(current_state)
	if can_move and current_state != State.DAMAGE:
		var input_horizontal = Input.get_axis("mover_izq", "mover_der")
		if controls_inverted:
			input_horizontal *= -1

		#var jump_attempt = Input.is_action_just_pressed("salto")
		var attack_attempt = Input.is_action_just_pressed("ataque")
		var input_up = Input.is_action_pressed("arriba")
		var input_down = Input.is_action_pressed("abajo")
		if controls_inverted:
			attack_attempt = Input.is_action_just_pressed("salto")
			input_up = Input.is_action_pressed("abajo")
			input_down = Input.is_action_pressed("arriba")
			

		if current_state in [State.UP_ATTACK, State.DOWN_ATTACK]:
			velocity.x = 0
		elif current_state == State.ATTACK:
			velocity.x = move_toward(velocity.x, input_horizontal * speed, speed * delta * 5)

		if attack_attempt:
			if not is_on_floor():
				if input_up:
					switch_state(State.UP_ATTACK)
				elif input_down:
					switch_state(State.DOWN_ATTACK)
				else:
					switch_state(State.AIR_ATTACK)
			elif input_up:
				switch_state(State.UP_ATTACK)
			elif input_down:
				switch_state(State.DOWN_ATTACK)
			else:
				switch_state(State.ATTACK)
		
		jump(delta)
		
		'''
		if not is_on_wall() or is_on_floor():
			if current_state == State.WALL_CLIMB:
				switch_state(State.IDLE)
		'''
		if input_horizontal:
			if input_horizontal < 0:
				$Sprite2D.scale.x = -1
			if input_horizontal > 0:
				$Sprite2D.scale.x = 1

			if current_state not in [State.ATTACK, State.AIR_ATTACK, State.UP_ATTACK, State.DOWN_ATTACK]:
				velocity.x = move_toward(velocity.x, input_horizontal * speed, speed * delta * 10)
				if is_on_floor():
					switch_state(State.RUN)

		else:
			if is_on_floor() and current_state not in [State.ATTACK, State.AIR_ATTACK, State.UP_ATTACK, State.DOWN_ATTACK]:
				velocity.x = move_toward(velocity.x, 0, speed * delta * 20)
				switch_state(State.IDLE)

		move_and_slide()
		for i in get_slide_collision_count():
					var c = get_slide_collision(i)
					if c.get_collider() is RigidBody2D:
						c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	else:
		velocity.x = 0
		switch_state(State.IDLE)


func switch_state(new_state: State):
	if current_state != new_state:
		current_state = new_state
		match current_state:
			State.IDLE:
				anim_state_machine.travel("idle")
				sfx_run.stop() # Detén el sonido de correr al estar quieto

			State.RUN:
				anim_state_machine.travel("correr")
				if not sfx_run.playing:
					sfx_run.play()

			State.JUMP:
				sfx_attack.stop()
				anim_state_machine.travel("saltar")
				velocity.y = JUMP_SPEED
				sfx_jump.play()

			State.ATTACK:
				anim_state_machine.travel("ataque1")
				sfx_attack.play()
				attack()
			State.AIR_ATTACK:
				anim_state_machine.travel("ataqueAereo")
				sfx_attack.play()
				air_attack()
			State.UP_ATTACK:
				anim_state_machine.travel("ataqueAlto")
				sfx_attack.play()
				up_attack()
			State.DOWN_ATTACK:
				anim_state_machine.travel("ataqueBajo")
				sfx_attack.play()
				down_attack()
			State.FALL:
				sfx_run.stop()
				sfx_attack.stop()
				anim_state_machine.travel("caer")
			State.DAMAGE:
				anim_state_machine.travel("daño")
			State.WALL_CLIMB:
				if velocity.y <0:
					anim_state_machine.travel("wall")
				else:
					anim_state_machine.travel("wall_fall")
					print("hola")
				



func _on_animation_finished(_anim_name):
	if Globales.current_character != 2:
		if current_state in [State.ATTACK, State.AIR_ATTACK, State.UP_ATTACK, State.DOWN_ATTACK]:
			#sfx_attack.stop()
			var current_animation = ""
			match current_state:
				State.ATTACK:
					if _anim_name == "ataque1":
						print("attack")
						#switch_state(State.ATTACK)
					print("attack finished")
					switch_state(State.IDLE)
				State.AIR_ATTACK:
					current_animation = "ataqueAereo"
				State.UP_ATTACK:
					current_animation = "ataqueAlto"
				State.DOWN_ATTACK:
					current_animation = "ataqueBajo"

			if _anim_name == current_animation:
				switch_state(State.IDLE)

func jump(delta):
	# Dentro de _physics_process(delta), solo lógica de salto
	var jump_attempt = Input.is_action_just_pressed("salto")
	if controls_inverted:
		jump_attempt = Input.is_action_just_pressed("ataque")

	if jump_attempt or input_buffer.time_left > 0:
		if coyote_jump_available:
			switch_state(State.JUMP)
			coyote_jump_available = false
		elif jump_attempt:
			input_buffer.start()

	var jump_released = Input.is_action_just_released("salto")
	if controls_inverted:
		jump_released = Input.is_action_just_released("ataque")

	if jump_released and velocity.y < 0:
		velocity.y = JUMP_SPEED / 2

	if not is_on_floor() and current_state not in [State.AIR_ATTACK, State.DOWN_ATTACK, State.UP_ATTACK,State.WALL_CLIMB]:
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


func coyote_timeout():
	coyote_jump_available = false
func combo_timeout():
	combo_count = 0


func change_speed(velocity_multiplier):
		speed *= velocity_multiplier

func reset_velocity():
	speed = initial_speed

func attack():
	print("ataque normal")
	#Esto es para romper la piedra
	
func air_attack():
	print("ataque aereo")
	
	# Aquí puedes añadir lógica específica para el ataque aéreo
func down_attack():
	print("ataque bajo")
	
	# Aquí puedes añadir lógica específica para el ataque hacia abajo
func up_attack():
	print("ataque alto")
	
	# Aquí puedes añadir lógica específica para el ataque hacia arriba

func getMaxHealth() -> int:
	return max_health
func getCurrentHealth():
	return current_health
func setCurrentHealth(health:int):
	current_health = health

func take_damage(damage_received: int):
	setCurrentHealth(getCurrentHealth() - damage_received)
	sfx_damaged.play()

	if getCurrentHealth() <= 0 && !in_death:
		in_death = true
		life_count -= 1
		add_child(death_menu.instantiate())
		get_tree().paused = true
		in_death = false
		return

	if is_taking_damage:
		return

	is_taking_damage = true

	if animPlayer and animPlayer.has_animation("daño"):
		var previous_anim = anim_state_machine.get_current_node()
		anim_state_machine.travel("daño")

		await get_tree().create_timer(0.15).timeout

		if current_health > 0:
			anim_state_machine.travel(previous_anim)

	
	can_move = true
	is_taking_damage = false
	if current_health > 0:
		switch_state(State.IDLE)

	

func return_to_safe_position():
	can_move = false
	position = last_safe_position

	var efecto = anim_appearing.instantiate()
	add_child(efecto)
	efecto.global_position = global_position

	await get_tree().create_timer(0.5).timeout
	can_move = true

func set_checkpoint_position():
	checkpoint_position = position
	has_checkpoint = true

func return_to_checkpoint():
	position = checkpoint_position
	current_health = max_health
	var efecto = anim_appearing.instantiate()
	add_child(efecto)
	efecto.global_position = global_position
	await get_tree().create_timer(0.5).timeout


func _input(event: InputEvent) -> void:
	var input_down = Input.is_action_pressed("abajo")
	if controls_inverted:
		input_down = Input.is_action_pressed("arriba")
	if input_down and is_on_floor():
		set_collision_mask_value(11, false)
	else:
		set_collision_mask_value(11, true)

func set_controls_inverted(state: bool) -> void:
	controls_inverted = state
