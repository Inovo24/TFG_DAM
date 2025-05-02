extends Node2D

@onready var camera = $Camera2D
#var health_bar
var player
var healthBar
@onready var healthBarScene = preload("res://Scenes/UI/Barravida.tscn")
@onready var colorblindnessScene = preload("res://Scenes/ajustes/Colorblindness.tscn")
var colorblindness

# Variable to store the menu instance
var menu_instance: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player = Globals.get_player()  # Get the player from the global variable
	add_child(player)  # Add the player to the current scene
	player.position = Vector2(0, 0)  # Set the initial position of the player
	
	camera.position = player.position
	
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)
	
	colorblindness = colorblindnessScene.instantiate()
	colorblindness.Type = Globals.colorblindness_type
	add_child(colorblindness)
	Globals.colorblindness = colorblindness
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camera.position = player.position
	
	if Input.is_action_just_pressed("exit"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)
