extends Node2D

@onready var camara = $Camera2D
#var barra_vida
var player 
var barraVida
@onready var barraVidaEscena = preload("res://Scenes/Barravida.tscn")
@onready var daltonismoEscena = preload("res://Scenes/ajustes/Colorblindness.tscn")
var daltonismo

# Variable para almacenar la instancia del menú
var menu_instance: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player = Globales.get_player()  # Obtén el jugador desde la variable global
	add_child(player)  # Añade el jugador a la escena actual
	player.position = Vector2(0, 0) # Ajusta la posición inicial del jugador
	
	camara.position = player.position
	
	barraVida = barraVidaEscena.instantiate()
	add_child(barraVida)
	
	daltonismo = daltonismoEscena.instantiate()
	daltonismo.Type = Globales.daltonismo_type
	add_child(daltonismo)
	Globales.daltonismo = daltonismo
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camara.position = player.position
	
	if Input.is_action_just_pressed("salir"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)
