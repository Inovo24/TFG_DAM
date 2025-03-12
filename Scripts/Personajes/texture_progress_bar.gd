extends TextureProgressBar

var personaje

func _ready():
	
	personaje = Globales.get_player()
	max_value = personaje.getVidaMaxima()
	actualizar_barra()
	print(value)
	print(max_value)

func _process(delta: float) -> void:
	actualizar_barra()

func actualizar_barra():
	value = personaje.getVidaActual()
	$"../Label".text = str(value) +"/"+ str(max_value)
