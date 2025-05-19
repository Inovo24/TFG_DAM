extends Node2D

@export var interval := 2.0
@export var active_by_default := false
@export var damage := 10
@export var random := false

var active := false
var body_in_area : Node2D = null

@onready var sprite := $AnimatedSprite2D
@onready var timer := $Timer
@onready var random_timer := $RandomTimer
@onready var area := $Area2D
@onready var damage_timer := $DamageTimer

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
	var random_interval = randf_range(1.0, 4.0)
	random_timer.wait_time = random_interval
	random_timer.start()

func _update_state():
	if active:
		sprite.play("on")
		area.monitoring = true
	else:
		sprite.play("off")
		area.monitoring = false
		body_in_area = null
		damage_timer.stop()

func _on_Area2D_body_entered(body: Node2D) -> void:
	if not active:
		return

	if body.is_in_group("player") and body.has_method("take_damage"):
		body_in_area = body
		body.take_damage(damage)
		damage_timer.start()

func _on_Area2D_body_exited(body: Node2D) -> void:
	if body == body_in_area:
		body_in_area = null
		damage_timer.stop()

func _on_DamageTimer_timeout():
	if body_in_area and body_in_area.is_inside_tree():
		if body_in_area.has_method("take_damage"):
			body_in_area.take_damage(damage)
