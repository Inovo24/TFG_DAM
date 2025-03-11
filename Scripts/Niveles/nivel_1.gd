extends Node2D

@onready var camara = $Camera2D
@onready var posicion = $Camera2D/Marker2D
var player

var barraVida
@onready var barraVidaEscena = preload("res://Scenes/Barravida.tscn")
@onready var daltonismoEscena = preload("res://Scenes/ajustes/Colorblindness.tscn")
var daltonismo

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
	
