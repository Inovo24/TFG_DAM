extends CharacterBody2D

const GRAVITY = 2500
var speed = 100
var chargeSpeed = 200


var maxHealth = 200
@onready var currentHealth = maxHealth

enum  Phase{ONE,TWO,THREE}
enum State {JUMP_PREPARATION, JUMP, CHARGE_PREPARATION, CHARGING, STUNNED}
@onready var currentPhase = Phase.ONE
@onready var currentState = State.JUMP_PREPARATION

@onready var animation_player = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var stun_cooldown = $stunCooldown
@onready var charge_cooldown = $chargeCooldown
@onready var jump_cooldown = $jumpCooldown

func _ready():
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
	#print(jump_cooldown.time_left)
	move_and_slide()

func switch_phase(newPhase):
	if currentPhase !=newPhase:
		currentPhase = newPhase
		match currentPhase:
			Phase.ONE:
				phase_one()
			Phase.TWO:
				pass
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

func phase_one():
	if currentState == State.JUMP_PREPARATION:
		#print("preparando salto")
		jump_preparation()
	elif currentState == State.JUMP:
		if is_on_floor():
			switch_state(State.JUMP_PREPARATION)

func jump_preparation():
	if not jump_cooldown.is_stopped():
		return
	#print("aa")
	#animation_player.play("jump_preparation")
	jump_cooldown.start()
	print(jump_cooldown.time_left)
func jump():
	player = get_tree().get_first_node_in_group("player")
	if player:
		#animation_player.play("jump")
		#position.y = player.position.y + 100
		position.x = player.global_position.x
		position.y -= 200
		#print("salto")
	

func _on_jump_cooldown_timeout():
	if is_on_floor():
		switch_state(State.JUMP)
