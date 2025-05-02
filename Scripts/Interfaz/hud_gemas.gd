extends CanvasLayer
class_name HUD
@export var gema_label : Label
@export var portal_label : Label

func updateGemLabel(numero:int):
	gema_label.text ="x " + str(numero)
