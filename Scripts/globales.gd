extends Node

var personajes = [preload("res://Personajes/vikingo.tscn"),preload("res://Personajes/valkiria.tscn"),preload("res://Personajes/arquero.tscn")]
var personaje_actual = 0 #El 0 es el vikingo, el 1 la valkiria, y el 2 el arquero

var player_instance = null  # Guardará la instancia del jugador

# Método para instanciar el jugador si no está ya instanciado
func get_player():
	if player_instance == null: # Si el jugador no ha sido instanciado aún
		player_instance = personajes[personaje_actual].instantiate()  # Instancia el jugador
	return player_instance
