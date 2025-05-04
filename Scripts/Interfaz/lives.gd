extends HBoxContainer

var character
var live_img = preload("res://Sprites/sprites_para_borradores/cora.png")

func _ready():
	character = Globales.get_player()

func _process(delta: float) -> void:
	$TextureRect.texture = live_img if character.life_count >= 1 else null
	$TextureRect2.texture = live_img if character.life_count >= 2 else null
	$TextureRect3.texture = live_img if character.life_count >= 3 else null
