extends Node2D

@export var tiempo_minimo_reaparicion = 2.0
@export var tiempo_maximo_reaparicion = 5.0
@export var tiempo_movimiento_total = 5.0 # Tiempo total para recorrer el path

var tiempo_reaparicion = 0.0
var desaparecido = false

@export var path_follow_2d: PathFollow2D
@export var ease_type: Tween.EaseType = Tween.EASE_IN
@export var transition_type: Tween.TransitionType = Tween.TRANS_QUART
@export var looping = false

@onready var colision: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@export var colision_activa: bool = true

var tween: Tween

func _ready() -> void:
	colision.disabled = not colision_activa
	reaparecer()

func iniciar_movimiento():
	# Cancelar cualquier tween existente
	
	if tween and tween.is_valid():
		tween.kill()
	
	# Resetear la posición inicial
	path_follow_2d.progress_ratio = 0.0
	
	# Crear nuevo tween
	tween = get_tree().create_tween()
	
	# EASE_IN hace que comience rápido y termine lento
	tween.tween_property(path_follow_2d, "progress_ratio", 2.0, tiempo_movimiento_total).set_ease(ease_type).set_trans(transition_type)
	
	if looping:
		tween.set_loops()
	else:
		# Conectar señal para detectar cuando termina el movimiento
		tween.finished.connect(func(): desaparecer())

func _process(delta):
	if desaparecido:
		tiempo_reaparicion -= delta
		#print(tiempo_reaparicion)

	if tiempo_reaparicion <= 0 and desaparecido:
		reaparecer()

func desaparecer():
	visible = false
	desaparecido = true
	colision.disabled = true
	# Usar el método más moderno de Godot 4
	#set_process_mode(PROCESS_MODE_DISABLED)
	set_deferred("disable_mode", true)
	tiempo_reaparicion = randf_range(tiempo_minimo_reaparicion, tiempo_maximo_reaparicion)
	
	# Desconectar la señal del tween para evitar llamadas múltiples
	if tween and tween.is_valid():
		if tween.finished.is_connected(desaparecer):
			tween.finished.disconnect(desaparecer)

func reaparecer():
	visible = true
	desaparecido = false
	if colision_activa:
		colision.disabled = false
	#set_process_mode(PROCESS_MODE_INHERIT)
	set_deferred("disable_mode", false)
	if is_instance_valid(path_follow_2d):
		iniciar_movimiento()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move":
		desaparecer()
