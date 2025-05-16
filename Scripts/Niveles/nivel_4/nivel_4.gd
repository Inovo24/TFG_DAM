extends Levels

@onready var level4_camera = $Camera2D
@onready var level4_position = $Camera2D/Marker2D

@onready var startarted = false

func _ready() -> void:
	camera = level4_camera
	initialPosition = level4_position
	super._ready()
	


func _on_cambio_a_arquero_body_entered(body: Node2D) -> void:
	if Globales.current_character !=2 and !startarted:
		print("ejecuto")
		var playerPosition = player.global_position
		Globales.current_character = 2
		Globales.player_instance = null
		#print(playerPosition)
		var playerInstancate = Globales.get_player()
		add_child(playerInstancate)
		player.queue_free()
		player = playerInstancate
		player.global_position = playerPosition
		
		startarted = true
	
