extends CharacterBody2D
class_name Enemigos

var daño = 10
var vida_maxima = 0
var vida_actual


func _ready():
	vida_actual = vida_maxima
	#add_to_group("Enemigos")


func recibir_daño(_dañorecibido:int):
	vida_actual = vida_actual - _dañorecibido
	print(vida_actual)
	
	if vida_actual <= 0:
		queue_free()
	
