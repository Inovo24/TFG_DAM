extends Enemigos

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $Area2D  # Área de detección general
@onready var attack_area: Area2D = $AttackArea  # Área de ataque

var retro_make_damage = 0.3
var retro_get_damage = 0.6

var SPEED = 60
var dir: Vector2 = Vector2.ZERO
var is_chasing: bool = false
var is_attacking: bool = false
var player: Personajes = null  # Ahora el jugador se reconoce como "Personajes"

var attack_timer: Timer  # Temporizador para ataques repetidos

var slow_mode = false
var slow_timer: Timer
var pause_timer: Timer
var retroceso_tween: Tween

func _ready() -> void:
	daño = 10
	vida_maxima = 50
	
	timer.start()  # Inicia el temporizador de patrullaje

	# Conectar eventos de detección
#	detection_area.body_entered.connect(_on_area_2d_body_entered)
#	detection_area.body_exited.connect(_on_area_2d_body_exited)
#	attack_area.body_entered.connect(_on_attack_area_body_entered)
#	attack_area.body_exited.connect(_on_attack_area_body_exited)

	# Temporizador para hacer daño repetidamente
	attack_timer = Timer.new()
	attack_timer.wait_time = 1  # Ataca cada 1 segundos
	attack_timer.one_shot = false  # Repite el ataque
	attack_timer.timeout.connect(_realizar_ataque)  # Conecta la función que aplica el daño
	add_child(attack_timer)
	
	# Temporizador para lentitud después de atacar o recibir daño
	slow_timer = Timer.new()
	slow_timer.wait_time = 2
	slow_timer.one_shot = true
	slow_timer.timeout.connect(_fin_efecto_lentitud)
	add_child(slow_timer)

	# Temporizador para pausar brevemente el movimiento
	pause_timer = Timer.new()
	pause_timer.wait_time = 0.3
	pause_timer.one_shot = true
	pause_timer.timeout.connect(Callable())
	add_child(pause_timer)
	
	retroceso_tween = create_tween()
	
	super._ready()

func _process(delta: float) -> void:
	move()
	handle_animation()

func handle_animation():
	if is_attacking:
		animated_sprite_2d.play("attack")
	elif velocity.length() > 0:
		animated_sprite_2d.play("flying")

	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false

func move():
	if pause_timer.is_stopped():
		if is_chasing and player != null:
			var direction = (player.position - position).normalized()
			var current_speed = SPEED if not slow_mode else SPEED / 2
			velocity = direction * current_speed
		elif not is_attacking:
			var current_speed = SPEED if not slow_mode else SPEED / 2
			velocity = dir * current_speed
	else:
		velocity = Vector2.ZERO  # No se mueve durante la pausa

	move_and_slide()

func _on_timer_timeout() -> void:
	if not is_chasing and not is_attacking:  # Solo cambiar dirección si no está en combate
		dir = choose([Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP])
		print("Nueva dirección:", dir)

	timer.wait_time = choose([1.0, 1.5, 2.0])
	timer.start()

func choose(array):
	array.shuffle()
	return array[0]

# --- DETECCIÓN DEL JUGADOR ---
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Personajes:
		SPEED *= 2
		player = body
		is_chasing = true
		#print("Cuerpo detectado, comenzando persecución")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Personajes:
		SPEED /= 2
		is_chasing = false
		player = null
		#print("Cuerpo salió del área, dejando de perseguir")
		_reanudar_patrullaje()  # Vuelve a patrullar cuando deja de perseguir

# --- DETECCIÓN EN ÁREA DE ATAQUE ---
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Personajes:
		SPEED += 10
		is_attacking = true  # Comienza a atacar
		
		body.recibirDaño(daño)  # Aplica el daño de inmediato
		
		attack_timer.start()  # Comienza el temporizador para ataques consecutivos
		_retroceso(retro_make_damage)
		#print("Jugador en área de ataque:", body.name)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Personajes:
		SPEED -= 10
		#print("Jugador salió del área de ataque:", body.name)
		is_attacking = false  # Deja de atacar
		attack_timer.stop()  # Detener el temporizador de ataque
		_reanudar_patrullaje()  # Vuelve a patrullar cuando deja de atacar

# --- Función de ataque repetido ---
func _realizar_ataque():
	if player:
		player.recibirDaño(daño)  # Aplica el daño repetidamente
		#print("Atacando al jugador, vida restante:", player.getVidaActual())
		
		_retroceso(retro_make_damage)

# --- Reanudar patrullaje si no hay jugadores cerca ---
func _reanudar_patrullaje():
	if not is_chasing and not is_attacking:  # Si no está atacando ni persiguiendo, patrulla
		timer.start()

func _iniciar_pausa_y_lentitud():
	pause_timer.start()
	slow_mode = true
	slow_timer.start()

func _fin_efecto_lentitud():
	slow_mode = false

func _retroceso(retroceso:float):
	var retroceso_dir = (position - player.position).normalized()
	var retroceso_distancia = 30
	var destino = position + retroceso_dir * retroceso_distancia
	
	# Crea una nueva interpolación
	retroceso_tween = create_tween()
	retroceso_tween.tween_property(self, "position", destino, retroceso).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Se queda quieto un momento y luego se mueve más lento
	_iniciar_pausa_y_lentitud()

func recibir_daño(_dañorecibido:int):
	super.recibir_daño(_dañorecibido)
	_retroceso(retro_get_damage)
