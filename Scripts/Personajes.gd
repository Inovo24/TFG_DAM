extends CharacterBody2D
class_name Jugadores


const VIDA = 100
const DAÑO = 10

const VELOCIDAD = 200
const VELOCIDAD_SALTO = -500.0

const GRAVEDAD = 2000

const COYOTE_TIME = 0.08
const INPUT_BUFFER_PATIENCE = 0.1

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true

func _ready():
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
	var input_horizontal = Input.get_axis("mover_izq","mover_der")
	var intento_salto = Input.is_action_just_pressed("salto")
	
	if intento_salto or input_buffer.time_left >0:
		if coyote_jump_available:
			velocity.y = VELOCIDAD_SALTO
			coyote_jump_available = false
		elif intento_salto:
			input_buffer.start()
			
	if Input.is_action_just_released("salto") and velocity.y < 0:
		velocity.y = VELOCIDAD_SALTO/2
		
	#if not is_on_floor() and coyote_jump_available != true:
		#velocity += gravedad * delta
		#velocity += get_gravity() * delta
		
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += GRAVEDAD*delta
		
	if input_horizontal:
		velocity.x = move_toward(velocity.x, input_horizontal*VELOCIDAD, VELOCIDAD*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD*delta)
	
	move_and_slide()

func coyote_timeout():
	coyote_jump_available = false
