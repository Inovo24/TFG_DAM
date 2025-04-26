extends Node2D
class_name Niveles

var camara 
var posicion 
var player

var barraVida
@onready var barraVidaEscena = preload("res://Scenes/Barravida.tscn")
@onready var daltonismoEscena = preload("res://Scenes/ajustes/Colorblindness.tscn")
var daltonismo

# Variable para almacenar la instancia del menú
var menu_instance: Node = null

func _ready():
	
	player = Globales.get_player()  # Obtén el jugador desde la variable global
	add_child(player)  # Añade el jugador a la escena actual
	player.position = posicion.position # Ajusta la posición inicial del jugador
	
	camara.position = player.position
	
	barraVida = barraVidaEscena.instantiate()
	add_child(barraVida)
	
	daltonismo = daltonismoEscena.instantiate()
	daltonismo.Type = Globales.daltonismo_type
	add_child(daltonismo)
	Globales.daltonismo = daltonismo
	

func _process(_delta: float) -> void:
	camara.position = player.position
	
	if Input.is_action_just_pressed("salir"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)
			get_tree().paused = true
