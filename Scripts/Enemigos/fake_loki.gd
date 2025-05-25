extends CharacterBody2D

@onready var fireball_scene: PackedScene = preload("res://Scenes/Elementos/fireball.tscn")
var vulnerable = true

func _ready():
	add_to_group("Enemies")

func _process(delta: float) -> void:
	if vulnerable:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(0,0,0,0.5)

func shoot_fireball():
	print("shoot fake")
	var fireball = fireball_scene.instantiate()
	
	fireball.position = $ShootPoint.position
	fireball.initialize(get_parent().player,true)
	add_child(fireball)

func receive_damage(damage):
	if vulnerable:
		get_parent().player.take_damage(damage)
