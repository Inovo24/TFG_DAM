extends CharacterBody2D

const GRAVITY = 30000
var speed = 100
var chargeSpeed = 200
var direction
var damage =20
var maxHealth = 200
@onready var currentHealth = maxHealth
var playerInstancate
enum  Phase{ONE,TWO,THREE}
enum State {JUMP_PREPARATION, JUMP, CHARGE_PREPARATION, CHARGING, STUNNED}
@onready var currentPhase = Phase.ONE
@onready var currentState = State.JUMP_PREPARATION
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var player = Globales.get_player()
@onready var stun_cooldown = $stunCooldown
@onready var charge_cooldown = $chargeCooldown
@onready var jump_cooldown = $jumpCooldown

func _ready():
	add_to_group("Enemies")
	#direction = 1

func _physics_process(delta):
	if direction ==1:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1
	if not is_on_floor():
		velocity.y = GRAVITY * delta
	#print(currentState)
	#print(velocity.x)
	match currentPhase:
			Phase.ONE:
				phase_one()
			Phase.TWO:
				phase_two()
			Phase.THREE:
				print("faaaaaseeeeeeee 3333")
	#print(charge_cooldown.time_left)
	move_and_slide()

func switch_phase(newPhase):
	if currentPhase !=newPhase:
		currentPhase = newPhase
		match currentPhase:
			Phase.ONE:
				switch_state(State.JUMP_PREPARATION)
			Phase.TWO:
				switch_state(State.CHARGE_PREPARATION)
			Phase.THREE:
				pass

func switch_state(newState):
	if currentState != newState:
		currentState = newState
		match currentState:
			State.JUMP_PREPARATION:
				jump_preparation()
			State.JUMP:
				jump()
			State.CHARGE_PREPARATION:
				charge_preparation()
			State.CHARGING:
				charge()
			State.STUNNED:
				stun()

func phase_one():
	if currentState == State.JUMP_PREPARATION:
		#print("preparando salto")
		jump_preparation()
	elif currentState == State.JUMP:
		if is_on_floor():
			switch_state(State.JUMP_PREPARATION)
func phase_two():
	if currentState == State.CHARGE_PREPARATION:
		charge_preparation()
	elif currentState == State.CHARGING:
		charge()

func jump_preparation():
	if not jump_cooldown.is_stopped():
		return
	#animation_player.play("jump_preparation")
	jump_cooldown.start()
func jump():
	print(currentState)
	if player:
		#animation_player.play("jump")
		position.x = player.global_position.x
		position.y -= 200
		receive_damage(20)
		#print("salto")

func charge_preparation():
	#print(charge_cooldown.time_left)
	#print("preparando carga")
	if not charge_cooldown.is_stopped():
		return
	#print("ey")
	if is_on_wall():
		if position.x < 300:
			position.x +=10
		else:
			position.x -=10
		print("estoy en pared")
	velocity.x =0
	charge_cooldown.start()
	#direction = player.global_position.x - position.x
	if player.global_position.x < position.x:
		direction = -1
	else:
		direction = 1
	#direction = Vector2((player.global_position.x - global_position.x), 0).normalized()
	#print(direction[0])
func charge():
	#print("cargando")
	print (direction)
	if player:
		print("se mueve")
		velocity.x = direction * chargeSpeed
	if is_on_wall():
		print("CAMBIO POR PARED")
		switch_state(State.CHARGE_PREPARATION)
func stun():
	print("quieto parao")
	velocity.x = 0
	stun_cooldown.start()


func receive_damage(damage_received: int):
	if currentState != State.CHARGING:
		currentHealth = currentHealth - damage_received
		#print(currentHealth)
		#print(currentPhase)
		if currentHealth <= 0:
			print("muero")
			queue_free()
		elif  currentHealth <= (maxHealth * 2/3) and currentPhase != Phase.TWO:
			print("fase 2")
			if Globales.current_character !=2:
				Globales.current_character = 2
				Globales.player_instance = null
				playerInstancate = Globales.get_player()
				get_parent().add_child(playerInstancate)
				player.queue_free()
				player = playerInstancate
				
			switch_phase(Phase.TWO)
		elif  currentHealth <= (maxHealth/ 3) and currentPhase != Phase.THREE:
			print("fase 3")
			
			switch_phase(Phase.THREE)
	elif currentState == State.CHARGING:
		switch_state(State.STUNNED)

func _on_jump_cooldown_timeout():
	if is_on_floor():
		switch_state(State.JUMP)


func _on_charge_cooldown_timeout():
	switch_state(State.CHARGING)


func _on_stun_cooldown_timeout():
	switch_state(State.CHARGE_PREPARATION)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		if body.global_position.x < 300:
			body.global_position.x += 80
		else:
			body.global_position.x -= 80
