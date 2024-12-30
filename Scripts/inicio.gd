extends Node2D

@onready var camara = $Camera2D
var barra_vida
var player 
var barraVida
@onready var barraVidaEscena = preload("res://Barravida.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Globales.get_player()  # Obtén el jugador desde la variable global
	add_child(player)  # Añade el jugador a la escena actual
	player.position = Vector2(525, 450) # Ajusta la posición inicial del jugador
	camara.position = player.position
	barraVida = barraVidaEscena.instantiate()
	add_child(barraVida)
	
	#Iniciar textos
	var aceptar_tecla = InputMap.action_get_events("aceptar_entrar")[0].as_text().replace(" (Physical)", "")
	$TextoAjustes/Label.text = "Pulsa " + aceptar_tecla + " para \nentrar a los ajustes"
	$TextoSalir/Label.text = "Pulsa " + aceptar_tecla +" para \nsalir del juego"
	$TextoSelector/Label.text = "Pulsa " + aceptar_tecla + " para entrar"
	$AreaNiveles/TextoNiveles/Label.text = "Pulsa " + aceptar_tecla + " para entrar"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camara.position = player.position
