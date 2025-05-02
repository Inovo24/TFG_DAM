extends Node2D

@onready var camara = $Camera2D
#var barra_vida
var player 
var barraVida
var hudmonedas
@onready var barraVidaEscena = preload("res://Scenes/UI/Barravida.tscn")
@onready var daltonismoEscena = preload("res://Scenes/ajustes/Colorblindness.tscn")
var daltonismo

# Variable para almacenar la instancia del menú
var menu_instance: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Guardado.primera_carga:
		Guardado.load_game()
		Guardado.primera_carga = false
	Globales.start()
	
	player = Globales.get_player()  # Obtén el jugador desde la variable global
	add_child(player)  # Añade el jugador a la escena actual
	player.position = Vector2(525, 450) # Ajusta la posición inicial del jugador
	
	camara.position = player.position
	
	barraVida = barraVidaEscena.instantiate()
	add_child(barraVida)
	
	daltonismo = daltonismoEscena.instantiate()
	daltonismo.Type = Globales.colorblindness_type
	add_child(daltonismo)
	Globales.colorblindness = daltonismo
	
	#Iniciar textos
	reset_textos()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camara.position = player.position
	ajustar_texture_rect_al_label()
	
	if Input.is_action_just_pressed("salir"):
		if menu_instance == null:
			menu_instance = preload("res://Scenes/ajustes/menu_inicio.tscn").instantiate()
			add_child(menu_instance)

func reset_textos():
	var aceptar_tecla = InputMap.action_get_events("aceptar_entrar")[0].as_text().replace(" (Physical)", "")
	$AreaNiveles/TextoNiveles/Label.text = tr("ini_lab_niveles").replace("{tecla}",aceptar_tecla)
	$TextoSelector/Label.text = tr("ini_lab_selector").replace("{tecla}",aceptar_tecla)
	$TextoSalir/Label.text = tr("ini_lab_salir").replace("{tecla}",aceptar_tecla)
	$TextoAjustes/Label.text = tr("ini_lab_ajustes").replace("{tecla}",aceptar_tecla)


func ajustar_texture_rect_al_label():
	#var padding = Vector2(20, 10) 
	$AreaNiveles/TextoNiveles.size = $AreaNiveles/TextoNiveles/Label.size 
	$TextoSelector.size = $TextoSelector/Label.size
	$TextoSalir.size = $TextoSalir/Label.size
	$TextoAjustes.size = $TextoAjustes/Label.size
