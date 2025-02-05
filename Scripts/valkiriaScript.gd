extends Personajes

class_name valkiria


	

func _ready() -> void:
	vida_maxima = 150
	vida_actual = vida_maxima  # Asegúrate de que esto se actualice también.
	velocidad = 150
	super._ready()
	#vida_maxima = 150
	#velocidad = 150
	print(vida_maxima)

func atacar():
	anim_state_machine.travel("ataque1")
	#pass
