extends Node2D

@export var speed: float = 200.0  
@export var damage: int = 15  
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var direction: Vector2 = Vector2.RIGHT 
var charge_multiplier: float = 1.0
var atack_player: bool = false

func _process(delta: float):
	position += direction * speed * delta

func _on_body_entered(_body: Node) -> void:
	audio_stream_player_2d.play()
	# Impacta contra el suelo (TileMap u otros)
	if _body is TileMap or _body is TileMapLayer:
		print("Arrow hit the ground")
		queue_free()

	# Daño a enemigos
	elif _body.is_in_group("Enemies"):
		damage *=charge_multiplier
		print(damage)
		_body.receive_damage(damage)
		queue_free()

	# Daño a jugadores si es una flecha enemiga
	elif _body.is_in_group("player") and atack_player:
		_body.take_damage(damage)
		queue_free()

	# Daño solo a bloques
	elif _body.has_method("take_damage") and _body.is_in_group("Blocks"):
		print("Flecha impacta bloque")
		_body.take_damage(damage)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Arrow exited screen")
	
	queue_free()
