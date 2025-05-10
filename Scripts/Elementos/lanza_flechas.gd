extends Node2D

@onready var arrow_scene = preload("res://Scenes/flecha.tscn")
@onready var shoot_point = $Marker2D
@onready var fire_timer = $TimerLanzador

var arrow_speed = 100

func _ready():
	randomize()
	start_random_timer()

func _on_fire_timer_timeout():
	shoot_arrow()
	start_random_timer()

func shoot_arrow():
	var arrow = arrow_scene.instantiate()
	get_tree().root.add_child(arrow)
	arrow.global_position = shoot_point.global_position
	
	var charge_multiplier = 2.0 
	
	arrow.atack_player = true
	arrow.speed = arrow_speed * charge_multiplier
	arrow.charge_multiplier = charge_multiplier
	
	var direction = Vector2($".".scale.x, 0)
	arrow.direction = direction
	arrow.scale.x = abs(arrow.scale.x) * direction.x

func start_random_timer():
	var random_time = randf_range(1.0, 3.0)  # Tiempo aleatorio entre 0.5 y 2 segundos
	fire_timer.wait_time = random_time
	fire_timer.start()
