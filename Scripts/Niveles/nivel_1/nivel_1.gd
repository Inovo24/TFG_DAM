extends Niveles

@onready var camara_level1 = $Camera2D
@onready var posicion_level1 = $Camera2D/Marker2D
@onready var hud_gemas_escena = preload("res://Scenes/UI/hud_gemas.tscn")

var monedas_recogidas: int = 0
var hud_gemas  # Variable para guardar la instancia

func _ready():	
	camara = camara_level1
	posicion = posicion_level1
	super._ready()
	
	hud_gemas = hud_gemas_escena.instantiate()
	add_child(hud_gemas)
	hud_gemas.actualizar_gema_label(monedas_recogidas)


func recoger_moneda():
	monedas_recogidas += 1
	hud_gemas.actualizar_gema_label(monedas_recogidas)
	
	if monedas_recogidas >= 10:
		hud_gemas.portal_abierto()
