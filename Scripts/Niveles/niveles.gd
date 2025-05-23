extends Node2D
class_name Levels

var camera
var initialPosition
var player

var offsetX = 100
var offsetY = -50

var healthBar
@onready var healthBarScene = preload("res://Scenes/UI/Barravida.tscn")
@onready var colorblindnessScene = preload("res://Scenes/ajustes/Colorblindness.tscn")
var colorblindness

# HUD gems
@onready var hud_gems_scene = preload("res://Scenes/UI/hud_gemas.tscn")
var collected_gems: int = 0
var hud_gems  # Variable to store the instance
# Variable to store the menu instance
var menu_instance: Node = null
#Para el guardado
var has_boss = false
#Teporizador
var timer_running := false
var elapsed_time := 0.0
var target_position: Vector2
var gem_sfx: AudioStreamPlayer

var down_pressed_time := 0.0
const DOWN_HOLD_TIME := 1.0 # segundos que hay que mantener
var camera_ground_y := 0.0
var level_name

func _ready():
	player = Globales.get_player()  # Get the player from the global variable
	add_child(player)  # Add the player to the current scene
	player.position = initialPosition.position  # Set the initial position of the player
	
	camera.position = player.position
	
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
	
	colorblindness = colorblindnessScene.instantiate()
	colorblindness.Type = Globales.colorblindness_type
	add_child(colorblindness)
	Globales.colorblindness = colorblindness
	
	gem_sfx = AudioStreamPlayer.new()
	var gem_sound = preload("res://Audio/elementos/collect_coin_01 (mp3cut.net).wav")
	gem_sfx.stream = gem_sound
	add_child(gem_sfx)

	# HUD gems
	hud_gems = hud_gems_scene.instantiate()
	add_child(hud_gems)
	hud_gems.updateGemLabel(collected_gems)
	
	#Teporizador
	timer_running = true
	elapsed_time = 0.0
	camera_ground_y = player.position.y + offsetY

func _process(_delta: float) -> void:
	var direction = player.sprite.scale.x
	var is_down_pressed = Input.is_action_pressed("abajo")

	# --- Lógica para bajar la cámara si mantiene abajo ---
	if player.is_on_floor():
		if is_down_pressed:
			down_pressed_time += _delta
			if down_pressed_time >= DOWN_HOLD_TIME:
				offsetY = +30  # La cámara baja un poco
			else:
				offsetY = -50  # Valor normal en el suelo
		else:
			down_pressed_time = 0.0
			offsetY = -50
		# Guardar la posición Y de la cámara cuando está en el suelo
		camera_ground_y = player.position.y + offsetY
	else:
		down_pressed_time = 0.0
		#offsetY = -50

	# --- Cálculo de target_position ---
	var target_y: float
	var high_jump_threshold = -400
	if player.is_on_floor():
		target_y = player.position.y + offsetY
	elif player.is_on_wall():
		target_y = player.position.y + offsetY
	else:
		if player.velocity.y < high_jump_threshold:
			target_y = player.position.y -100
		else:
			target_y = camera_ground_y  # Mantener la Y guardada durante el salto

	if direction > 0:
		target_position = Vector2(player.position.x + offsetX, target_y)
	else:
		target_position = Vector2(player.position.x - offsetX, target_y)

	camera.position = camera.position.lerp(target_position, _delta * 5)

	hud_gems.updateGemLabel(collected_gems)
	if Input.is_action_just_pressed("salir"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)
			get_tree().paused = true
	
	if timer_running:
		elapsed_time += _delta
		healthBar.updateTimeLabel(elapsed_time)

# Function to update gems

func collect_gem():
	collected_gems += 1
	hud_gems.updateGemLabel(collected_gems)
	gem_sfx.play()
	

func save_data():
	timer_running = false
	print(elapsed_time)
	if has_boss:
		Guardado.save_temporal_data(level_name,collected_gems,elapsed_time)
	else:
		Guardado.mark_level_completed(level_name,collected_gems,elapsed_time)
