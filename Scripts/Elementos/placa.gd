extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var activate_on_body: bool = true  # También puede ser solo jugador

var bodies_inside := 0
var is_pressed := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	animated_sprite_2d.play("idle")

func _on_body_entered(body):
	if activate_on_body and body.is_in_group("Player"):  # o cualquier otro grupo
		bodies_inside += 1
		_check_press()

func _on_body_exited(body):
	if activate_on_body and body.is_in_group("Player"):
		bodies_inside -= 1
		_check_press()

func _check_press():
	if bodies_inside > 0 and not is_pressed:
		is_pressed = true
		animated_sprite_2d.play("press")
		emit_signal("pressed")  # puedes conectar esto a puertas, trampas, etc.
	elif bodies_inside == 0 and is_pressed:
		is_pressed = false
		animated_sprite_2d.play("release")
		emit_signal("released")
