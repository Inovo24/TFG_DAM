extends CharacterBody2D

var damage = 15
var maxHealth = 200
var currentHealth
enum Phase {ONE, TWO, THREE}
var currentPhase
enum States1 {PREPARATION, ATTACK, JUMP}
enum States2 {CHARGE_PREPARATION, CHARGE, STUNNED}
enum States3 {RUN}
var currentState

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var preparation_timer = $preparation
@onready var cooldown_timer = $cooldown

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	animation_tree.active = true
	currentHealth = maxHealth
	currentPhase = Phase.ONE
	currentState = States1.PREPARATION  # Inicializamos el estado
	switch_state(currentState)  # Aplicamos el estado inicial

func _physics_process(delta):
	
	
	match currentPhase:
		Phase.ONE:
			phase_one()
		Phase.TWO:
			phase_two()
		Phase.THREE:
			phase_three()
	
	velocity.y += 1500 * delta  # Gravedad
	move_and_slide()

func phase_one():
	if not player:
		return
	match currentState:
		States1.PREPARATION:
			preparation()
		States1.JUMP:
			# Aquí solo controlamos el movimiento continuo durante el salto
			var target_x = player.global_position.x
			velocity.x = (target_x - global_position.x) * 2.0  # Ajustamos velocidad para seguir al jugador
		States1.ATTACK:
			# La lógica principal está en la función attack()
			pass

func phase_two():
	if not player:
		return
		
	match currentState:
		States2.CHARGE_PREPARATION:
			# Implementar la preparación de la carga
			animation_player.play("charge_preparation")
			# Mirar hacia el jugador
			if player.global_position.x < global_position.x:
				scale.x = -abs(scale.x)  # Mirar a la izquierda
			else:
				scale.x = abs(scale.x)  # Mirar a la derecha
		
		States2.CHARGE:
			# Implementar la carga
			animation_player.play("charge")
			var direction = 1 if scale.x > 0 else -1
			velocity.x = direction * 400  # Velocidad de carga
		
		States2.STUNNED:
			# Implementar el aturdimiento
			animation_player.play("stunned")
			velocity.x = 0

func phase_three():
	if not player:
		return
		
	# Implementar la fase tres cuando la necesites
	pass

func receive_damage(damage_received: int):
	currentHealth -= damage_received
	print("Boss health: ", currentHealth)
	
	# Verificar cambio de fase
	if currentHealth <= 0:
		queue_free()
	elif currentHealth <= (maxHealth / 3) and currentPhase != Phase.THREE:
		switch_phase(Phase.THREE)
	elif currentHealth <= (maxHealth * 2 / 3) and currentPhase != Phase.TWO:
		switch_phase(Phase.TWO)

func switch_phase(new_phase: Phase):
	if currentPhase != new_phase:
		currentPhase = new_phase
		
		match currentPhase:
			Phase.ONE:
				currentState = States1.PREPARATION
			Phase.TWO:
				currentState = States2.CHARGE_PREPARATION
				cooldown_timer.stop()  # Asegurarse de parar los timers anteriores
				preparation_timer.stop()
			Phase.THREE:
				currentState = States3.RUN
				cooldown_timer.stop()
				preparation_timer.stop()
		
		# Aplicar el nuevo estado
		switch_state(currentState)

func switch_state(new_state):
	var old_state = currentState
	currentState = new_state
	
	print("Changing from state ", old_state, " to ", new_state)
	
	# Resetear velocidad al cambiar estado
	velocity.x = 0
	
	match currentPhase:
		Phase.ONE:
			match currentState:
				States1.PREPARATION:
					preparation()
				States1.JUMP:
					jump()
				States1.ATTACK:
					attack()
		Phase.TWO:
			match currentState:
				States2.CHARGE_PREPARATION:
					# Iniciar temporizador para la preparación de carga
					preparation_timer.start()
				States2.CHARGE:
					# La lógica está en phase_two()
					pass
				States2.STUNNED:
					# Iniciar temporizador para la duración del aturdimiento
					cooldown_timer.start()
		Phase.THREE:
			# Implementar en el futuro
			pass

func preparation():
	print("Starting preparation")
	animation_player.play("jump_preparation")
	if preparation_timer.is_stopped():
		preparation_timer.start()

func jump():
	print("Jumping")
	animation_player.play("jump")
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var target_x = player.global_position.x
		velocity.x = (target_x - global_position.x) * 2.0  # Ajusta para saltar hacia el jugador
		velocity.y = -500  # Velocidad de salto

func attack():
	print("Attacking")
	animation_player.play("attack")
	velocity.x = 0  # Detener movimiento horizontal durante ataque

# Conectar estas señales en el editor o usar _on_animation_player_animation_finished
func _on_animation_player_animation_finished(anim_name):
	print("Animation finished: ", anim_name)
	
	match anim_name:
		"jump_preparation":
			switch_state(States1.JUMP)
		"jump":
			switch_state(States1.ATTACK)
		"attack":
			cooldown_timer.start()
		"charge":
			switch_state(States2.STUNNED)
		"stunned":
			switch_state(States2.CHARGE_PREPARATION)

func _on_preparation_timeout():
	print("Preparation timer timeout")
	
	match currentPhase:
		Phase.ONE:
			switch_state(States1.JUMP)
		Phase.TWO:
			switch_state(States2.CHARGE)

func _on_cooldown_timeout():
	print("Cooldown timer timeout")
	
	match currentPhase:
		Phase.ONE:
			switch_state(States1.PREPARATION)
		Phase.TWO:
			switch_state(States2.CHARGE_PREPARATION)

# Añade esta función para manejar golpes durante la fase 2
func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_attack") and currentPhase == Phase.TWO and currentState == States2.CHARGE:
		switch_state(States2.STUNNED)
		receive_damage(10)  # O el daño que quieras aplicar
