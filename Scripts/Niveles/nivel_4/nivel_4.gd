extends Levels

@onready var level4_camera = $Camera2D
@onready var level4_position = $Marker2D

@onready var startarted = false
@onready var doorclose = false

func _ready() -> void:
	camera = level4_camera
	initialPosition = level4_position
	level_name = "nivel4"
	super._ready()
	


func _on_cambio_a_arquero_body_entered(body: Node2D) -> void:
	if Globales.current_character !=2 and !startarted:
		call_deferred("_cambiar_a_arquero")
	startarted = true

func _cambiar_a_arquero() -> void:
	print("ejecuto")
	var playerPosition = player.global_position
	Globales.current_character = 2
	Globales.player_instance = null

	var playerInstancate = Globales.get_player()
	add_child(playerInstancate)

	player.queue_free()
	player = playerInstancate
	player.global_position = playerPosition

	reload_health_bar()


func reload_health_bar():
	healthBar.queue_free()
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)


func _on_cerrar_parte_vikingo_body_entered(body: Node2D) -> void:
	if !doorclose:
		doorclose = true 
		var position = $CerraduraVikingo.position - Vector2(50,0)
		$CerraduraVikingo.position = position
		'''
		$CerraduraVikingo.visible = true
		$CerraduraVikingo/CollisionShape2D.disabled = false
		'''
