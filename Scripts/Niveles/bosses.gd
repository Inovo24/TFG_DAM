extends Node2D

class_name Bosses

var camera
var initialPosition
var player

var healthBar
@onready var healthBarScene = preload("res://Scenes/UI/Barravida.tscn")
@onready var colorblindnessScene = preload("res://Scenes/ajustes/Colorblindness.tscn")
#@onready var endMenu = preload("res://Scenes/Niveles/menu_fin_nivel.tscn")
var colorblindness

 # Variable to store the instance
# Variable to store the menu instance
var menu_instance: Node = null
var timer_running := false
var elapsed_time := 0.0
var level_name
var level_scene

func _ready():
	player = Globales.get_player()  # Get the player from the global variable
	add_child(player)  # Add the player to the current scene
	player.position = initialPosition.position  # Set the initial position of the player
	player.checkpoint_position = initialPosition.position
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
	healthBar.default = int(Guardado.level_temporal_progress[level_name]["time"])
	colorblindness = colorblindnessScene.instantiate()
	colorblindness.Type = Globales.colorblindness_type
	add_child(colorblindness)
	Globales.colorblindness = colorblindness
	#Teporizador
	timer_running = true
	elapsed_time = 0.0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("salir"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)
			get_tree().paused = true
	#Teporizador
	if timer_running:
		elapsed_time += _delta
		healthBar.updateTimeLabel(elapsed_time)


func end_level():
	timer_running = false
	print(elapsed_time)
	Guardado.mark_completed_from_temporal_data(level_name,elapsed_time,level_scene)
	match level_name:
		"nivel1":
			pass
		"nivel3":
			pass
		"nivel5":
			pass
	#add_child(endMenu.instantiate())

func return_to_level():
	get_tree().change_scene_to_file(level_scene)
