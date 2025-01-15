extends Node2D

@onready var camara = $Camera2D
@onready var posicion = $Camera2D/Marker2D
var player

func _ready():
	
	player = Globales.get_player()  # Obtén el jugador desde la variable global
	add_child(player)  # Añade el jugador a la escena actual
	player.position = posicion.position # Ajusta la posición inicial del jugador
	
	camara.position = player.position
	

func _process(_delta: float) -> void:
	camara.position = player.position
	
