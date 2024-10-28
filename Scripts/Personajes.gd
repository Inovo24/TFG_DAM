"""
extends CharacterBody2D
class_name Personajes



const VELOCIDAD_SALTO = -500.0

const GRAVEDAD = 2000

const COYOTE_TIME = 0.08
const INPUT_BUFFER_PATIENCE = 0.1


var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true

var vida = 100
var daño = 10
var velocidad = 200


@onready var animPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D



func _ready():
	#Inicio de input buffer timer, sirve para que si el jugador le da
	#a saltar un poco antes de estar en el suelo se quede guardado por un tiepo
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)
	
	#Inicio del coyote timer, sirve para que el jugador tenga un poco de tiempo
	#para saltar despues de dejar de pisar el suelo
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

func _physics_process(delta):
	var input_horizontal = Input.get_axis("mover_izq","mover_der")
	var intento_salto = Input.is_action_just_pressed("salto")
	
	
	
	if intento_salto or input_buffer.time_left >0:
		if coyote_jump_available:
			velocity.y = VELOCIDAD_SALTO
			#animPlayer.play("saltar")
			coyote_jump_available = false
		elif intento_salto:
			input_buffer.start()
	
	#Para que dependiendo lo que se apriete salte más o menos /x
	if Input.is_action_just_released("salto") and velocity.y < 0:
		velocity.y = VELOCIDAD_SALTO/2
		
	
	if Input.is_action_pressed("ataque"):
		atacar()
		return
	
	
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += GRAVEDAD*delta
		
	if input_horizontal:
		# Girar el sprite dependiendo de la dirección del movimiento
		if input_horizontal < 0:
			$Sprite2D.scale.x = -1  # Mirar a la izquierda
		elif input_horizontal > 0:
			$Sprite2D.scale.x = 1  # Mirar a la derecha
			
		   # Mover el personaje y reproducir animación de correr
		velocity.x = move_toward(velocity.x, input_horizontal * velocidad, velocidad * delta)
		animPlayer.play("correr")
	
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad*delta)
		animPlayer.play("idle")
		
	
	
	move_and_slide()

func coyote_timeout():
	coyote_jump_available = false
	

func atacar():
	animPlayer.play("ataque1")
	return
"""
extends CharacterBody2D
class_name Personajes

# Constantes y variables para el movimiento y salto
const VELOCIDAD_SALTO = -500.0
const GRAVEDAD = 2000
const COYOTE_TIME = 0.08
const INPUT_BUFFER_PATIENCE = 0.1

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true
var vida = 100
var daño = 10
var velocidad = 200

# Control de animación con AnimationTree y AnimationPlayer
@onready var animPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var anim_state_machine = animation_tree.get("parameters/playback")  # Acceso al estado del AnimationTree

# Variables para gestionar estados de animación
enum State { IDLE, RUN, JUMP, ATTACK }
var current_state : State = State.IDLE
var previous_state : State = State.IDLE


func _ready():
	# Inicializar AnimationTree
	animation_tree.active = true
	switch_state(State.IDLE)
	
	# Configuración de temporizadores
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)

	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

	

func _physics_process(delta):
	var input_horizontal = Input.get_axis("mover_izq", "mover_der")
	var intento_salto = Input.is_action_just_pressed("salto")
	
	# Actualizar animación en función de la entrada de usuario
	#update_state(input_horizontal, intento_salto)

	if Input.is_action_just_pressed("ataque"):
		previous_state = current_state
		switch_state(State.ATTACK)
		
	# Lógica de salto con coyote y gravedad
	if intento_salto or input_buffer.time_left > 0:
		if coyote_jump_available:
			
			switch_state(State.JUMP)
			coyote_jump_available = false
		elif intento_salto:
			input_buffer.start()

	if Input.is_action_just_released("salto") and velocity.y < 0:
		velocity.y = VELOCIDAD_SALTO / 2

	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available and coyote_timer.is_stopped():
			coyote_timer.start()
		velocity.y += GRAVEDAD * delta
	
	if input_horizontal:
		if input_horizontal <0:
			$Sprite2D.scale.x = -1
		if input_horizontal >0:
			$Sprite2D.scale.x = 1
		
		
		if current_state != State.ATTACK:
			velocity.x = move_toward(velocity.x, input_horizontal * velocidad, velocidad * delta)
			switch_state(State.RUN)
	
	else:
		
		if is_on_floor() and current_state != State.ATTACK:
			velocity.x = move_toward(velocity.x, 0, velocidad * delta)
			switch_state(State.IDLE)

	move_and_slide()


func switch_state(new_state: State):
	# Cambia el estado del personaje y ajusta la animación en el AnimationTree
	if current_state != new_state:
		current_state = new_state
		match current_state:
			State.IDLE:
				anim_state_machine.travel("idle")
				#animPlayer.play("idle")
			State.RUN:
				anim_state_machine.travel("correr")
				#animPlayer.play("correr")
			State.JUMP:
				anim_state_machine.travel("saltar")
				velocity.y = VELOCIDAD_SALTO
				#animPlayer.play("saltar")
			State.ATTACK:
				anim_state_machine.travel("ataque1")
				#animPlayer.play("ataque1")
				

func _on_animation_finished(anim_name):
	if current_state == State.ATTACK:
		print("ataque finalizado")
		switch_state(State.IDLE)

func coyote_timeout():
	coyote_jump_available = false


func atacar():
	switch_state(State.ATTACK)
