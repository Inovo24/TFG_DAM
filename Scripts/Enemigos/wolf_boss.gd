extends CharacterBody2D

const GRAVITY = 30000
var speed = 100
var chargeSpeed = 200


var maxHealth = 200
@onready var currentHealth = maxHealth

enum  Phase{ONE,TWO,THREE}
enum State {JUMP_PREPARATION, JUMP, CHARGE_PREPARATION, CHARGING, STUNNED}
@onready var currentPhase = Phase.ONE
@onready var currentState = State.JUMP_PREPARATION
var player
@onready var animation_player = $AnimationPlayer
#@onready var player = get_tree().get_first_node_in_group("player")
@onready var stun_cooldown = $stunCooldown
@onready var charge_cooldown = $chargeCooldown
@onready var jump_cooldown = $jumpCooldown

func _ready():
	add_to_group("Enemies")
	switch_state(State.JUMP_PREPARATION)
	switch_phase(Phase.ONE)

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y = GRAVITY * delta
	
	match currentPhase:
			Phase.ONE:
				phase_one()
			Phase.TWO:
				pass
			Phase.THREE:
				pass
	#print(charge_cooldown.time_left)
	move_and_slide()

func switch_phase(newPhase):
	if currentPhase !=newPhase:
		currentPhase = newPhase
		match currentPhase:
			Phase.ONE:
				phase_one()
			Phase.TWO:
				phase_two()
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
	switch_state(State.CHARGE_PREPARATION)

func jump_preparation():
	if not jump_cooldown.is_stopped():
		return
	#print("aa")
	#animation_player.play("jump_preparation")
	jump_cooldown.start()
	#print(jump_cooldown.time_left)
func jump():
	player = get_tree().get_first_node_in_group("player")
	if player:
		#animation_player.play("jump")
		#position.y = player.position.y + 100
		position.x = player.global_position.x
		position.y -= 200
		receive_damage(20)
		#print("salto")

func charge_preparation():
	print("preparando carga")
	if not charge_cooldown.is_stopped():
		return
	charge_cooldown.start()
func charge():
	print("cargando")
func stun():
	print("quieto parao")
	velocity.x = 0
	stun_cooldown.start()


func receive_damage(damage_received: int):
	if currentState != State.CHARGING:
		currentHealth = currentHealth - damage_received
		print(currentHealth)
		print(currentPhase)
		if currentHealth <= 0:
			print("muero")
			queue_free()
		elif  currentHealth <= (maxHealth * 2/3) and currentPhase != Phase.TWO:
			print("fase 2")
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
