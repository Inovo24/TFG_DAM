extends TextureRect

@onready var character = Globales.current_character
@onready var player_icon = $"."

var viking_texture = preload("res://Sprites/Elementos/niveles/seleccionadoVikingo.png") 
var valkyrie_texture = preload("res://Sprites/Elementos/niveles/seleccionadoValkiria.png")
var archer_texture = preload("res://Sprites/Elementos/niveles/seleccionadoArquero.png")

func _ready():
	match character:
		0:
			player_icon.texture = viking_texture
		1:
			player_icon.texture = valkyrie_texture
		2:
			player_icon.texture = archer_texture
