extends Node2D
class_name Bosses

var camera
var initialPosition
var player

var healthBar
@onready var healthBarScene = preload("res://Scenes/UI/Barravida.tscn")
@onready var colorblindnessScene = preload("res://Scenes/ajustes/Colorblindness.tscn")
@export var initial_position_node_path: NodePath
@export var camera_path: NodePath
var colorblindness

var menu_instance: Node = null
var timer_running := false
var elapsed_time: float = 0.0
var level_name

func _ready():
	call_deferred("_setup_boss_scene")

func _setup_boss_scene():
	# Obtener nodo de posición inicial desde el path exportado
	if initial_position_node_path != null:
		initialPosition = get_node(initial_position_node_path)
	else:
		push_error("initial_position_node_path no está asignado.")
		return

	if initialPosition == null:
		push_error("No se encontró el nodo de posición inicial.")
		return

	# Obtener la cámara si se ha asignado en el editor
	if camera_path != null:
		camera = get_node_or_null(camera_path)

	# Instanciar jugador
	player = Globales.get_player()
	add_child(player)
	player.global_position = initialPosition.global_position
	player.checkpoint_position = initialPosition.position

	# Instanciar barra de vida
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
	healthBar.default = int(Guardado.level_temporal_progress.get(level_name, {}).get("time", 0))

	# Filtro daltonismo
	colorblindness = colorblindnessScene.instantiate()
	colorblindness.Type = Globales.colorblindness_type
	add_child(colorblindness)
	Globales.colorblindness = colorblindness

	# Iniciar temporizador
	timer_running = true
	elapsed_time = 0.0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("salir"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)
			get_tree().paused = true

	if timer_running:
		elapsed_time += _delta
		healthBar.updateTimeLabel(elapsed_time)

func end_level():
	timer_running = false
	print(elapsed_time)
	Guardado.mark_completed_from_temporal_data(level_name, elapsed_time)

func return_to_level():
	pass
