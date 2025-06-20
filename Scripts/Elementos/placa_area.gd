extends Area2D

@onready var anim_sprite = $AnimatedSprite2D
var bodies_inside := []
var press_signal = "placa_press"
var release_signal = "placa_release"

var is_pressed := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	anim_sprite.play("idle")

func _on_body_entered(body):
	if body is PhysicsBody2D and body not in bodies_inside:
		bodies_inside.append(body)
		_check_press()

func _on_body_exited(body):
	if body in bodies_inside:
		bodies_inside.erase(body)
		_check_press()

func _check_press():
	if bodies_inside.size() > 0 and not is_pressed:
		is_pressed = true
		anim_sprite.play("press")
		get_parent().emit_signal(press_signal)
		print("placa")
	elif bodies_inside.size() == 0 and is_pressed:
		is_pressed = false
		anim_sprite.play("release")
		get_parent().emit_signal(release_signal)
