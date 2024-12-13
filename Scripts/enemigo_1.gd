extends Node2D

class_name Enemigo

# Variables del enemigo
var vida = 50
var daño = 10
var velocidad = 100

# Función que detecta la colisión con el personaje
func _on_Enemigo_body_entered(body):
	if body.is_in_group("jugador"):  # Asegúrate de que el personaje está en el grupo "jugador"
		body.recibir_dano(daño)  # Llamar a la función recibir_dano del personaje
		reducir_vida(daño)  # El enemigo recibe daño

# Función para reducir la vida del enemigo
func reducir_vida(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		morir()

# Función para eliminar al enemigo cuando muere
func morir():
	queue_free()  # Eliminar el enemigo
