extends CharacterBody2D
class_name Personajes


const VELOCIDAD_SALTO = -500.0
const GRAVEDAD = 2000


const COYOTE_TIME = 0.08
const INPUT_BUFFER_PATIENCE = 0.1

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true


@export var vida_maxima = 125
@onready var vida_actual = vida_maxima
var daño = 10
var velocidad = 200


@onready var animPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var anim_state_machine = animation_tree.get("parameters/playback")

# Declaracion de la maquina de estados, para gestionar los estados de una mejor manera
enum State { IDLE, RUN, JUMP, ATTACK }
var current_state : State = State.IDLE
var previous_state : State = State.IDLE


func _ready():
	# Inicializar AnimationTree para que funcionen las animaciones
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
		#previous_state = current_state
		switch_state(State.ATTACK)
		
	# Lógica de salto con coyote y gravedad
	if intento_salto or input_buffer.time_left > 0:
		if coyote_jump_available:
			
			switch_state(State.JUMP)
			coyote_jump_available = false
		elif intento_salto:
			input_buffer.start()
	#Dependiendo de lo que presiones salta más o menos
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
				
			State.RUN:
				anim_state_machine.travel("correr")
				
			State.JUMP:
				anim_state_machine.travel("saltar")
				velocity.y = VELOCIDAD_SALTO
				
			State.ATTACK:
				anim_state_machine.travel("ataque1")
				atacar()
				
				

func _on_animation_finished(_anim_name):
	if current_state == State.ATTACK:
		print("ataque finalizado")
		switch_state(State.IDLE)

func coyote_timeout():
	coyote_jump_available = false


func atacar():
	switch_state(State.ATTACK)
func getVidaMaxima()-> int:
	return vida_maxima
func getVidaActual():
	return vida_actual
func setVidaActuak(vidaActual:int):
	vida_actual = vidaActual
