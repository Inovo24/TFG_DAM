extends StaticBody2D

@onready var timer = $Timer
var player_on_top = false
#@export var direccion = 

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_on_top = true
		timer.start()
		print("me rompo")

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_on_top = false
		timer.stop()
		timer.one_shot = true
		print("me rompi")
