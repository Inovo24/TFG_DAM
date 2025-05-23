extends CharacterBody2D

const GRAVITY = 30000
var speed = 100
var chargeSpeed = 200
var direction
var damage =20
var maxHealth = 200
var initialPosition
var hasAttacked=false
@onready var currentHealth = maxHealth
var playerInstancate
var playerPosition
enum  Phase{ONE,TWO,THREE}
enum State {JUMP_PREPARATION, JUMP, CHARGE_PREPARATION, CHARGING, STUNNED, ATTACK_PREPARATION, ATTACK}
@onready var currentPhase = Phase.ONE
@onready var currentState = State.JUMP_PREPARATION
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var player = Globales.get_player()
@onready var stun_cooldown = $stunCooldown
@onready var charge_cooldown = $chargeCooldown
@onready var jump_cooldown = $jumpCooldown
@onready var attack_cooldown = $attackCooldown
@onready var attack_marker = $Sprite2D/Area2D/attackMarker
@onready var proyectile = preload("res://Scenes/flecha.tscn")

func _ready():
	add_to_group("Enemies")
	initialPosition = position.x
	change_player(1)

func _physics_process(delta):
	if direction ==1:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	if not is_on_floor():
		velocity.y = GRAVITY * delta
	#if currentPhase == Phase.THREE:
	#print(currentState)
	#print(velocity.x)
	match currentPhase:
			Phase.ONE:
				phase_one()
			Phase.TWO:
				phase_two()
			Phase.THREE:
				phase_three()
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
				switch_state(State.ATTACK_PREPARATION)

func switch_state(newState):
	if currentState != newState:
		currentState = newState
		match currentPhase:
			Phase.ONE:
				match currentState:
					State.JUMP_PREPARATION:
						jump_preparation()
					State.JUMP:
						jump()
			Phase.TWO:
				match currentState:
					State.CHARGE_PREPARATION:
						charge_preparation()
					State.CHARGING:
						charge()
					State.STUNNED:
						stun()
			Phase.THREE:
				match currentState:
					State.ATTACK_PREPARATION:
						attack_preparation()
					State.ATTACK:
						attack()

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
func phase_three():
	#print(currentPhase)
	#print(currentState)
	if position.x != initialPosition:
		position.x = initialPosition
		direction = -1
		#sprite.scale.x = -1
	if currentState == State.ATTACK_PREPARATION:
		#print(2)
		attack_preparation()
	if currentState == State.ATTACK:
		#print(3)
		attack()

func jump_preparation():
	if not jump_cooldown.is_stopped():
		return
	#animation_player.play("jump_preparation")
	sprite.play("idle")
	jump_cooldown.start()
func jump():
	print(currentState)
	if player:
		#animation_player.play("jump")
		sprite.play("jump")
		position.x = player.global_position.x
		position.y -= 200
		receive_damage(20)
		#print("salto")

func charge_preparation():
	sprite.play("idle")
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
		#print("estoy en pared")
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
	sprite.play("run")
	#print("cargando")
	#print (direction)
	if player:
		#print("se mueve")
		velocity.x = direction * chargeSpeed
	if is_on_wall():
		#print("CAMBIO POR PARED")
		switch_state(State.CHARGE_PREPARATION)
func stun():
	sprite.play("stunned")
	#print("quieto parao")
	velocity.x = 0
	stun_cooldown.start()

func attack_preparation():
	sprite.play("idle")
	if not attack_cooldown.is_stopped():
		return
	attack_cooldown.start()
func attack():
	sprite.play("attack")
	if proyectile:
		if hasAttacked==false:
			#print("paso por aqui")
			var a = proyectile.instantiate()
			a.atack_player = true
			get_tree().root.add_child(a)
			if attack_marker:
				#print("marker")
				a.global_position = attack_marker.global_position
			
			
			a.direction = Vector2.LEFT
			#a.scale.x = abs(a.scale.x) * direction.x
			hasAttacked = true
			attack_cooldown.start()
func receive_damage(damage_received: int):
	if currentState != State.CHARGING:
		sprite.play("take_damage")
		currentHealth = currentHealth - damage_received
		#print(currentHealth)
		#print(currentPhase)
		if currentHealth <= 0:
			#print("muero")
			#Guarda el nivel 1 como completo
			get_parent().end_level()
			queue_free()
		elif  currentHealth <= (maxHealth * 2/3) and currentPhase == Phase.ONE:
			#print("fase 2")
			change_player(0)
			switch_phase(Phase.TWO)
		elif  currentHealth <= (maxHealth/ 3) and currentPhase == Phase.TWO:
			#print("fase 3")
			change_player(2)
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
			body.global_position.y = 430
		else:
			body.global_position.x -= 80
			body.global_position.y = 430


func _on_attack_cooldown_timeout():
	if currentState == State.ATTACK_PREPARATION:
		switch_state(State.ATTACK)
	else:
		hasAttacked = false
		switch_state(State.ATTACK_PREPARATION)

func change_player(playerNum: int):
	if Globales.current_character !=playerNum:
			playerPosition = player.global_position
			var player_checkpoint = player.checkpoint_position
			Globales.current_character = playerNum
			Globales.player_instance = null
			playerInstancate = Globales.get_player()
			get_parent().add_child(playerInstancate)
			player.queue_free()
			player = playerInstancate
			player.global_position = playerPosition
			player.has_checkpoint = true
			player.checkpoint_position = player_checkpoint
			#get_parent().get_.update_player()
