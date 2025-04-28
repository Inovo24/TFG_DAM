extends CanvasLayer
class_name HUD
@export var gema_label : Label
@export var portal_label : Label

func actualizar_gema_label(numero:int):
	gema_label.text ="x " + str(numero)
	
func portal_abierto():
	portal_label.text = "Portal abierto!"
func portal_cerrado():
	portal_label.text = "Portal cerrado"
