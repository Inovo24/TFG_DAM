extends TextureRect

@onready var  personaje = Globales.personaje_actual
@onready var player_icon = $"."

var textura_vikingo = preload("res://Sprites/Elementos/niveles/seleccionadoVikingo.png") 
var textura_valkiria = preload("res://Sprites/Elementos/niveles/seleccionadoValkiria.png")
var textura_arquero = preload("res://Sprites/Elementos/niveles/seleccionadoArquero.png")

func _ready():
	match personaje:
		0:
			player_icon.texture = textura_vikingo
		1:
			player_icon.texture = textura_valkiria
		2:
			player_icon.texture = textura_arquero
