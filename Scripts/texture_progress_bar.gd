extends TextureProgressBar

var personaje:Personajes




func _ready():
	
	personaje = Globales.get_player()
	#max_value = personaje.getVidaMaxima()
	print(personaje.getVidaMaxima())
	actualizar_barra()


func actualizar_barra():
	value = personaje.getVidaActual() * 100/ personaje.getVidaMaxima()
