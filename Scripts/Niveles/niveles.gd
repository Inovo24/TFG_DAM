extends Node2D
class_name Levels

var camera
var initialPosition
var player

var offsetX = 100
var offsetY = -25

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

func _process(_delta: float) -> void:
	var direction = player.sprite.scale.x
	if player.is_on_floor():
		offsetY = -80
	else:
		offsetY = 0
		#print(offsetY)
	if direction > 0:
		target_position = player.position + Vector2(offsetX, offsetY+25)
	else:
		target_position = player.position + Vector2(-offsetX, offsetY+25)
	camera.position = camera.position.lerp(target_position,_delta* 5)
	#print(offsetY)
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
	

func save_data(level_name: String):
	timer_running = false
	print(elapsed_time)
	if has_boss:
		Guardado.save_temporal_data(level_name,collected_gems,elapsed_time)
	else:
		Guardado.mark_level_completed(level_name,collected_gems,elapsed_time)
