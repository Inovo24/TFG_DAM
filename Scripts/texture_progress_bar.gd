extends TextureProgressBar

@onready var personaje = Globales.get_player()


@onready var barra_vida = $TextureProgressBar


func _ready():
	barra_vida.max_value = personaje


func set_personaje(p_instancia):
	personaje = p_instancia
	barra_vida.max_value = personaje.vida
	actualizar_barra()


func actualizar_barra():
	if personaje:
		barra_vida.value = personaje.vida
