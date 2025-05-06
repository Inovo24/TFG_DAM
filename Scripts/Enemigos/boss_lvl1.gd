extends CharacterBody2D

var damage = 15
var maxHealth = 200
var currentHealth

enum Phase {ONE, TWO, THREE}
var currentPhase

enum States1 {PREPARATION, ATTACK, JUMP}
enum States2 {PREPARATION, CHARGE, STUNNED}
enum States3 {RUN}
var currentState

func _ready():
	currentPhase = Phase.ONE

func _physics_process(delta):
	match Phase:
		Phase.ONE:
			phase_one()
		Phase.TWO:
			phase_two()
		Phase.THREE:
			phase_three()


func phase_one():
	pass
func phase_two():
	pass
func phase_three():
	pass

func receive_damage(damage_received: int):
	currentHealth = currentHealth - damage_received
	if (currentHealth <=(maxHealth * 2 / 3)):
		switch_phase(Phase.TWO)
	elif (currentHealth<=(maxHealth / 3)):
		switch_phase(Phase.THREE)
	elif currentHealth <= 0:
		queue_free()

func switch_phase(new_phase: Phase):
	if currentPhase != new_phase:
		currentPhase = new_phase
		match currentPhase:
			Phase.TWO:
				phase_two()
			Phase.THREE:
				phase_three()
