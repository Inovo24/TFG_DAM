extends Node

var characters = [preload("res://Personajes/vikingo.tscn"), preload("res://Personajes/valkiria.tscn"), preload("res://Personajes/arquero.tscn")]
var current_character = 0 #El 0 es el vikingo, el 1 la valkiria, y el 2 el arquero
var volumes = [1, 1, 1]
var character: CharacterBody2D

var player_instance = null  # Will store the player instance

var colorblindness = preload("res://Scenes/ajustes/Colorblindness.tscn")

var data_current_level = {
	"level_name": "",
	"scence_to_return": "",
	"num_gems": "",
	"time": ""
}

const TYPE = {
	"None": 0,
	"Protanopia": 1,
	"Deuteranopia": 2,
	"Tritanopia": 3,
	"Achromatopsia": 4
}
var colorblindness_type = TYPE.None

func start() -> void:
	setGeneralVolume(volumes[0])
	setMusicVolume(volumes[1])
	setEnemyVolume(volumes[2])

# Method to instantiate the player if not already instantiated
func get_player():
	if player_instance == null: # If the player has not been instantiated yet
		player_instance = characters[current_character].instantiate()  # Instantiate the player
	return player_instance

# Music volumes
func setGeneralVolume(value: float):
	volumes[0] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func setMusicVolume(value: float):
	volumes[1] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func setEnemyVolume(value: float):
	volumes[2] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func getGeneralVolume() -> float:
	return volumes[0]

func getMusicVolume() -> float:
	return volumes[1]

func getEnemyVolume() -> float:
	return volumes[2]
