extends Niveles

@onready var camara_level1 = $Camera2D
@onready var posicion_leve1 = $Camera2D/Marker2D
@onready var hud_gemas: HUD = $Camera2D/Camera2D/HUD_Gemas

var monedas_recogidas: int = 0

func _ready():	
	camara = camara_level1
	posicion = posicion_leve1
	super._ready()
	hud_gemas.actualizar_gema_label(monedas_recogidas)


func recoger_moneda():
	monedas_recogidas += 1
	hud_gemas.actualizar_gema_label(monedas_recogidas)
	#En caso de abrir un portal a otra escena
	if monedas_recogidas >= 10:
		hud_gemas.portal_abierto()
