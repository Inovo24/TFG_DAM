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
#var combo_available : bool = false

var max_health = 125
var current_health 
var life_count = 3
var remaining_lives
var damage = 10
var speed = 200
var initial_speed

var thorns_touching = 0

var combo_count = 0
var next_attack : bool = false

@onready var animPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var anim_state_machine = animation_tree.get("parameters/playback")
@onready var anim_appearing = preload("res://Scenes/Efectos/EfectoAparecer.tscn")

# State machine declaration for better state management
enum State { IDLE, RUN, JUMP, FALL, ATTACK }
var current_state : State = State.IDLE
var previous_state : State = State.IDLE

var last_safe_position: Vector2
var checkpoint_position: Vector2
var has_checkpoint = false

var can_move = true

@onready var death_menu = preload("res://Scenes/Niveles/menu_muerte.tscn")

func _ready():
	add_to_group("player")
	remaining_lives = life_count
	current_health = max_health
	# Initialize AnimationTree to enable animations
	animation_tree.active = true
	switch_state(State.IDLE)
	
	initial_speed = speed
	
	# Timer configuration
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

func _physics_process(delta):
	if can_move:
		if combo_timer.time_left > 0:
			pass
			#print(combo_timer.time_left)
		var input_horizontal = Input.get_axis("mover_izq", "mover_der")
		var jump_attempt = Input.is_action_just_pressed("salto")
		
		# Update animation based on user input
		#update_state(input_horizontal, jump_attempt)
		
		if current_state == State.ATTACK:
			#velocity = Vector2.ZERO
			velocity.x = 0
		
		if Input.is_action_just_pressed("ataque"):
			#previous_state = current_state
			#if current_state == State.ATTACK
			switch_state(State.ATTACK)
			#attack()
			
		# Jump logic with coyote time and gravity
		if jump_attempt or input_buffer.time_left > 0:
			if coyote_jump_available:
				
				switch_state(State.JUMP)
				coyote_jump_available = false
			elif jump_attempt:
				input_buffer.start()
		# Depending on how long you press, jump higher or lower
		if Input.is_action_just_released("salto") and velocity.y < 0:
			velocity.y = JUMP_SPEED / 2
			
		if not is_on_floor():
			if velocity.y < 0:
				anim_state_machine.travel("saltar")
				#print("going up")
			else:
				switch_state(State.FALL)
				#print("falling")
				
		#elif is_on_floor() and velocity.x == 0:
			#anim_state_machine.travel("idle")
			#print("grounded")

		if is_on_floor():
			coyote_jump_available = true
			coyote_timer.stop()
			last_safe_position = position
		else:
			if coyote_jump_available and coyote_timer.is_stopped():
				coyote_timer.start()
			velocity.y += GRAVITY * delta
		
		if input_horizontal:
			if input_horizontal < 0:
				$Sprite2D.scale.x = -1
			if input_horizontal > 0:
				$Sprite2D.scale.x = 1
			
		
			if current_state != State.ATTACK:
				velocity.x = move_toward(velocity.x, input_horizontal * speed, speed * delta * 5)  # input_horizontal * speed
				switch_state(State.RUN)
		
		else:
			
			if is_on_floor() and current_state != State.ATTACK:
				velocity.x = move_toward(velocity.x, 0, speed * delta * 5) #0
				switch_state(State.IDLE)
				
	
		move_and_slide()
	else:
		velocity.x = 0
		switch_state(State.IDLE)
	


func switch_state(new_state: State):
	# Change the character's state and adjust the animation in the AnimationTree
	if current_state != new_state:
		current_state = new_state
		match current_state:
			State.IDLE:
				anim_state_machine.travel("idle")
				
			State.RUN:
				anim_state_machine.travel("correr")
				
			State.JUMP:
				anim_state_machine.travel("saltar")
				velocity.y = JUMP_SPEED
				
			State.ATTACK:
				#anim_state_machine.travel("attack1")
				#combo_available = true
				#combo_timer.start()
				attack()
				
			State.FALL:
				anim_state_machine.travel("caer")
				

func _on_animation_finished(_anim_name):
	if current_state == State.ATTACK:
		if _anim_name == "ataque1":
			print("attack")
			#switch_state(State.ATTACK)
		print("attack finished")
		switch_state(State.IDLE)

func coyote_timeout():
	coyote_jump_available = false
func combo_timeout():
	#combo_available = false
	combo_count = 0
	
	
func change_speed(velocity):
		speed *= velocity

func reset_velocity():
	
	speed = initial_speed

func attack():
	pass
	

func getMaxHealth() -> int:
	return max_health
func getCurrentHealth():
	return current_health
func setCurrentHealth(health:int):
	current_health = health

func take_damage(damage_received:int):
	setCurrentHealth(getCurrentHealth() - damage_received)
	
	if getCurrentHealth() <= 0:
		add_child(death_menu.instantiate())
		
		get_tree().paused = true
		#queue_free()
	

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


# Makes it so when you press "abajo" and are on a platform, you go abajo
# Currently, the platform is on layer 11, and when you press 'abajo', it disables collision with that platform
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("abajo") and is_on_floor():
		set_collision_mask_value(11, false)
	else:
		set_collision_mask_value(11, true)
