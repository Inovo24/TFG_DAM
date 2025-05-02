extends Node2D
class_name Niveles

var camara 
var posicion 
var player

var barraVida
@onready var barraVidaEscena = preload("res://Scenes/UI/Barravida.tscn")
@onready var daltonismoEscena = preload("res://Scenes/ajustes/Colorblindness.tscn")
var daltonismo

#Hud monedas
@onready var hud_gemas_escena = preload("res://Scenes/UI/hud_gemas.tscn")
var monedas_recogidas: int = 0
var hud_gemas  # Variable para guardar la instancia
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
	

	#Hud monedas
	hud_gemas = hud_gemas_escena.instantiate()
	add_child(hud_gemas)
	hud_gemas.actualizar_gema_label(monedas_recogidas)
	

func _process(_delta: float) -> void:
	camara.position = player.position
	hud_gemas.actualizar_gema_label(monedas_recogidas)
	if Input.is_action_just_pressed("salir"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)
			get_tree().paused = true

#Función para actulizar monedas 

func recoger_moneda():
	monedas_recogidas += 1
	hud_gemas.actualizar_gema_label(monedas_recogidas)
	
	if monedas_recogidas >= 10:
		hud_gemas.portal_abierto()
