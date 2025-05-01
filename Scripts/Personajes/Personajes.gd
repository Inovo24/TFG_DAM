extends CharacterBody2D
class_name Personajes


const VELOCIDAD_SALTO = -400.0
const GRAVEDAD = 1500


const COYOTE_TIME = 0.08
const INPUT_BUFFER_PATIENCE = 0.2
const COMMBO_TIME = 0.8


var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true
var combo_timer : Timer
#var combo_avaible : bool = false




var vida_maxima = 125
var vida_actual 
var numero_vidas = 3
var vidas_restantes
var daño = 10
var velocidad = 200
var initialVelocity

var zarzas_touching = 0

var combo_count =0
var next_attack : bool = false

@onready var animPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var anim_state_machine = animation_tree.get("parameters/playback")

# Declaracion de la maquina de estados, para gestionar los estados de una mejor manera
enum State { IDLE, RUN, JUMP,FALL, ATTACK }
var current_state : State = State.IDLE
var previous_state : State = State.IDLE

var ultima_posicion_segura: Vector2
var posicion_checkpoint: Vector2
var tiene_checkpoint = false

var puede_moverse = true

@onready var menu_muerte = preload("res://Scenes/Niveles/menu_muerte.tscn")

func _ready():
	vidas_restantes = numero_vidas
	vida_actual = vida_maxima
	# Inicializar AnimationTree para que funcionen las animaciones
	animation_tree.active = true
	switch_state(State.IDLE)
	
	initialVelocity = velocidad
	
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
	
	combo_timer = Timer.new()
	combo_timer.wait_time = COMMBO_TIME
	combo_timer.one_shot = true
	add_child(combo_timer)
	combo_timer.timeout.connect(combo_timeout)
	
	
	
	Globales.personaje = self

func _physics_process(delta):
	if puede_moverse:
		if combo_timer.time_left > 0:
			pass
			#print(combo_timer.time_left)
		var input_horizontal = Input.get_axis("mover_izq", "mover_der")
		var intento_salto = Input.is_action_just_pressed("salto")
		
		# Actualizar animación en función de la entrada de usuario
		#update_state(input_horizontal, intento_salto)
		
		if current_state == State.ATTACK:
			#velocity = Vector2.ZERO
			velocity.x = 0
		
		if Input.is_action_just_pressed("ataque"):
			#previous_state = current_state
			#if current_state == State.ATTACK
			switch_state(State.ATTACK)
			#atacar()
			
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
			
		if not is_on_floor():
			if velocity.y <0:
				anim_state_machine.travel("saltar")
				#print("subo")
			else:
				switch_state(State.FALL)
				#print("bajo")
				
		#elif is_on_floor() and velocity.x ==0:
			#anim_state_machine.travel("idle")
			#print("suelo")

		if is_on_floor():
			coyote_jump_available = true
			coyote_timer.stop()
			ultima_posicion_segura = position
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
				velocity.x =move_toward(velocity.x, input_horizontal * velocidad, velocidad * delta *5)  # input_horizontal * velocidad
				switch_state(State.RUN)
		
		else:
			
			if is_on_floor() and current_state != State.ATTACK:
				velocity.x = move_toward(velocity.x, 0, velocidad * delta*5) #0
				switch_state(State.IDLE)
				
	
		move_and_slide()
	else:
		velocity.x = 0
		switch_state(State.IDLE)
	


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
				#anim_state_machine.travel("ataque1")
				#combo_avaible = true
				#combo_timer.start()
				atacar()
				
			State.FALL:
				anim_state_machine.travel("caer")
				

func _on_animation_finished(_anim_name):
	if current_state == State.ATTACK:
		if _anim_name == "ataque1":
			print("ataque")
			#switch_state(State.ATTACK)
		print("ataque finalizado")
		switch_state(State.IDLE)

func coyote_timeout():
	coyote_jump_available = false
func combo_timeout():
	#combo_avaible = false
	combo_count = 0
	
	
func change_speed(velocity):
		velocidad *= velocity

func reset_velocity():
	
	velocidad = initialVelocity

func atacar():
	pass
	

func getVidaMaxima()-> int:
	return vida_maxima
func getVidaActual():
	return vida_actual
func setVidaActual(vidaActual:int):
	vida_actual = vidaActual

func recibirDaño(_dañorecibido:int):
	setVidaActual(getVidaActual()-_dañorecibido)
	
	if getVidaActual() <= 0:
		add_child(menu_muerte.instantiate())
		
		get_tree().paused = true
		#queue_free()
	

func volver_a_posicion_segura():
	position = ultima_posicion_segura

func poner_posicion_checkpoint():
	posicion_checkpoint = position
	tiene_checkpoint = true

func volver_a_checkpoint():
	position = posicion_checkpoint
	vida_actual = vida_maxima


#Hace que cuando presiones "abajo" y si estas en una plataforma bajes
#Ahora la plataforma está en la capa 11 y cuando presionas 'abajo' desactiva la colisón con esa plataforma
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("abajo") and is_on_floor():
		set_collision_mask_value(11,false)
	else:
		set_collision_mask_value(11,true)
