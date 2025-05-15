extends Node2D

@export var interval := 2.0
@export var active_by_default := false
@export var damage := 50
@export var random := false  # Botón exportado

var active := false

@onready var sprite := $AnimatedSprite2D
@onready var timer := $Timer
@onready var random_timer := $RandomTimer
@onready var area := $Area2D

func _ready():
	active = active_by_default
	_update_state()

	if random:
		_randomize_next_activation()
	else:
		timer.wait_time = interval
		timer.start()

func _on_Timer_timeout():
	if not random:
		active = !active
		_update_state()

func _on_RandomTimer_timeout():
	if random:
		active = !active
		_update_state()
		_randomize_next_activation()

func _randomize_next_activation():
	var random_interval = randf_range(1.0, 4.0)  # puedes modificar el rango
	random_timer.wait_time = random_interval
	random_timer.start()

func _update_state():
	if active:
		sprite.play("on")
		area.monitoring = true
	else:
		sprite.play("off")
		area.monitoring = false

func _on_Area2D_body_entered(body: Node2D) -> void:
	if not active:
		return
	if body.is_in_group("player"):
		body.take_damage(damage)
		'''
		body.can_move = false
		await get_tree().create_timer(0.5).timeout
		body.can_move = true
		'''
