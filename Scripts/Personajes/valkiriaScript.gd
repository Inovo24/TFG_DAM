extends Personajes

class_name valkiria


func _ready() -> void:
	super._ready()
	vida_maxima = 150
	vida_actual = vida_maxima  # Asegúrate de que esto se actualice también.
	velocidad = 150
	
	daño=35
	#vida_maxima = 150
	#velocidad = 150
	print(vida_maxima)

func atacar():
	anim_state_machine.travel("ataque1")
	#pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hola?")
	if body.is_in_group("Enemigos"):
		body.recibir_daño(daño)
