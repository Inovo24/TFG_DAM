extends TextureProgressBar

var character

func _ready():
	
	character = Globales.get_player()
	max_value = character.getMaxHealth()
	update_bar()
	print(value)
	print(max_value)

func _process(_delta: float) -> void:
	update_bar()

func update_bar():
	if character:
		value = character.getCurrentHealth()
		$"../Label".text = str(value) + "/" + str(max_value)
