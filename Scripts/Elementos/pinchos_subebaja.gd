extends StaticBody2D

@onready var spike_timer = $SpikeTimer
var start_position: Vector2
var up_offset: float = -10.0  #Tamaño de los pinchos, primero baja esto para estar oculto, y luego sube
var damage = 20

func _ready():
	position.y -= up_offset
	start_position = position
	randomize()
	start_random_timer()

func _on_spike_timer_timeout():
	move_spikes_up()

func move_spikes_up():
	position = start_position + Vector2(0, up_offset)
	await get_tree().create_timer(0.5).timeout
	move_spikes_down()
	start_random_timer()

func move_spikes_down():
	position = start_position

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		#body.return_to_safe_position()
		body.can_move = false
		await get_tree().create_timer(0.5).timeout
		body.can_move = true
	elif body.is_in_group("Enemies"):
		body.queue_free()

func start_random_timer():
	var random_time = randf_range(2.0, 5.0)  # Tiempo aleatorio entre 0.5 y 2 segundos
	spike_timer.wait_time = random_time
	spike_timer.start()
