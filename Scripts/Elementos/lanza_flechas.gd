extends Node2D

@onready var arrow_scene = preload("res://Scenes/flecha.tscn")
@onready var shoot_point = $Marker2D
@onready var fire_timer = $TimerLanzador
@onready var sprite_before = preload("res://Sprites/sprites_para_borradores/lanzador.png")
@onready var sprite_after = preload("res://Sprites/sprites_para_borradores/lanzador_disparo.png")
@onready var sprite = $Sprite2D

var arrow_speed = 200

func _ready():
	randomize()
	start_random_timer()

func _on_fire_timer_timeout():
	sprite.texture = sprite_after
	await get_tree().create_timer(1.0).timeout
	sprite.texture = sprite_before
	shoot_arrow()
	start_random_timer()

func shoot_arrow():
	var arrow = arrow_scene.instantiate()
	get_tree().root.add_child(arrow)
	arrow.global_position = shoot_point.global_position
	
	arrow.atack_player = true
	arrow.speed = arrow_speed 
	
	var direction = Vector2($".".scale.x, 0)
	arrow.direction = direction
	arrow.scale.x = abs(arrow.scale.x) * direction.x

func start_random_timer():
	var random_time = randf_range(0.0, 2.0)  # Tiempo aleatorio entre 0.5 y 2 segundos
	fire_timer.wait_time = random_time
	fire_timer.start()
