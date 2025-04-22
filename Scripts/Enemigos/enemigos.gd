extends CharacterBody2D
class_name Enemigos

var daño = 10
var vida_maxima = 0
var vida_actual

var retro_make_damage = 0.5
var retro_get_damage = 1

var player
var slow_mode = false
var slow_timer: Timer
var pause_timer: Timer
var retroceso_tween: Tween


func _ready():
	vida_actual = vida_maxima
	#add_to_group("Enemigos")
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


func recibir_daño(_dañorecibido:int):
	vida_actual = vida_actual - _dañorecibido
	print(vida_actual)
	
	if vida_actual <= 0:
		queue_free()
	
	_retroceso(retro_get_damage)

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
	
	# Verificar colisión antes de hacer el tween
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, destino)
	query.exclude = [self]  # Excluir al enemigo mismo
	var result = space_state.intersect_ray(query)

	if result:
		# Hay una colisión, ajusta el destino al punto de colisión
		destino = result.position

	# Hacer el tween hacia el destino válido
	retroceso_tween = create_tween()
	retroceso_tween.tween_property(self, "position", destino, retroceso).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Se queda quieto un momento y luego se mueve más lento
	_iniciar_pausa_y_lentitud()
