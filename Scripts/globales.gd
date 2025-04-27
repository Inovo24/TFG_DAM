extends Node

var personajes = [preload("res://Personajes/vikingo.tscn"),preload("res://Personajes/valkiria.tscn"),preload("res://Personajes/arquero.tscn")]
var personaje_actual = 0 #El 0 es el vikingo, el 1 la valkiria, y el 2 el arquero
var volumenes = [1,1,1]
var personaje: CharacterBody2D

var player_instance = null  # Guardará la instancia del jugador

var daltonismo = preload("res://Scenes/ajustes/Colorblindness.tscn")

const TYPE = {
	"None":0,
	"Protanopia":1,
	"Deuteranopia": 2,
	"Tritanopia": 3,
	"Achromatopsia": 4
}
var daltonismo_type = TYPE.None

func inicio() -> void:
	setVolumenGeneral(volumenes[0])
	setVolumenMusica(volumenes[1])
	setVolumenEnemigos(volumenes[2])

# Método para instanciar el jugador si no está ya instanciado
func get_player():
	if player_instance == null: # Si el jugador no ha sido instanciado aún
		player_instance = personajes[personaje_actual].instantiate()  # Instancia el jugador
	return player_instance

#Musica voumenes
func setVolumenGeneral(value: float):
	volumenes[0] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func setVolumenMusica(value: float):
	volumenes[1] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func setVolumenEnemigos(value: float):
	volumenes[2] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func getVolumenGeneral() -> float:
	return volumenes[0]

func getVolumenMusica() -> float:
	return volumenes[1]

func getVolumenEnemigos() -> float:
	return volumenes[2]
