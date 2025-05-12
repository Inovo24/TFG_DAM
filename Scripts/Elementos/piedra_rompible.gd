extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@export var max_health: int = 30
var current_health: int
var is_breaking := false

func _ready():
	current_health = max_health
	anim.play("idle")

func take_damage(amount: int):
	if is_breaking:
		return
	current_health -= amount
	if current_health <= 0:
		break_apart()

func break_apart():
	is_breaking = true
	anim.play("break")
	await anim.animation_finished
	# Instanciar moneda antes de destruir la piedra
	var moneda = preload("res://Scenes/Elementos/gema_drop.tscn").instantiate()
	get_parent().add_child(moneda)
	moneda.global_position = global_position + Vector2(0, -10)
	
	
	queue_free()
