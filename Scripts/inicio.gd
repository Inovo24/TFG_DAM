extends Node2D

@onready var pj_prueba: Vikingo = $PjPrueba

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = Globales.get_player()  # Obtén el jugador desde la variable global
	add_child(player)  # Añade el jugador a la escena actual
	player.position = Vector2(525, 450) # Ajusta la posición inicial del jugador


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
