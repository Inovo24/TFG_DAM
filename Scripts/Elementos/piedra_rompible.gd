extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var area = $Area2D
@export var max_health: int = 30
@export var drop_coin = false
@export var interruptor: bool = false
@onready var audio_stream_player = $AudioStreamPlayer

var current_health: int
var is_breaking := false

func _ready():
	current_health = max_health
	anim.play("idle")
	#area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if interruptor and body.is_in_group("player"):
		break_apart()

func take_damage(amount: int):
	if is_breaking:
		return
	current_health -= amount
	if current_health <= 0:
		break_apart()

func break_apart():
	if is_breaking:
		return
	is_breaking = true
	anim.play("break")
	audio_stream_player.play()
	await anim.animation_finished
	
	if not drop_coin:
		var moneda = preload("res://Scenes/Elementos/gema_drop.tscn").instantiate()
		get_parent().add_child(moneda)
		moneda.global_position = global_position + Vector2(0, -10)
	queue_free()
