extends Node2D


# Referencias
var personaje
@onready var barra_vida = $BarraVida/CanvasLayer

func _ready():
	# Instanciar y añadir al personaje
	var escena_personaje = preload("res://Personajes/vikingo.tscn")
	personaje = escena_personaje.instantiate()
	add_child(personaje)
	
	# Configurar la barra de vida
	barra_vida.set_personaje(personaje)

	# Simulación de daño después de 2 segundos
	await get_tree().create_timer(2.0).timeout
	aplicar_daño(20)

# Simula daño al personaje
func aplicar_daño(cantidad):
	if personaje:
		personaje.vida -= cantidad
		barra_vida.actualizar_barra()
