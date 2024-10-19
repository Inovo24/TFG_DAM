extends Node

var personajes = [preload("res://Personajes/pj_prueba.tscn"),preload("res://Personajes/pj_prueba2.tscn"),preload("res://Personajes/pj_prueba3.tscn")]
var personaje_actual = 0

var player_instance = null  # Guardará la instancia del jugador

# Método para instanciar el jugador si no está ya instanciado
func get_player():
	if player_instance == null:  # Si el jugador no ha sido instanciado aún
		player_instance = personajes[personaje_actual].instantiate()  # Instancia el jugador
	return player_instance
