extends Node2D

@onready var arrow_scene = preload("res://Scenes/Elementos/flecha_lanzaflechas.tscn")
@onready var shoot_point = $Marker2D
@onready var fire_timer = $TimerLanzador
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var arrow_speed = 200

func _ready():
	randomize()
	start_random_timer()
	animated_sprite_2d.play("idle")

func _on_fire_timer_timeout():
	animated_sprite_2d.play("activado")
	await get_tree().create_timer(1.0).timeout
	animated_sprite_2d.play("idle")
	shoot_arrow()
	start_random_timer()

func shoot_arrow():
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = shoot_point.global_position
	
	arrow.atack_player = true 
	arrow.speed = arrow_speed 
	
	var direction = Vector2($".".scale.x, 0) 
	arrow.direction = direction
	arrow.scale.x = abs(arrow.scale.x) * direction.x

func start_random_timer():
	var random_time = randf_range(0.0, 2.0)  # Tiempo aleatorio entre 0.0 y 2.0 segundos
	fire_timer.wait_time = random_time
	fire_timer.start()
 
