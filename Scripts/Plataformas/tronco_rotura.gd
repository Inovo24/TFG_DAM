extends StaticBody2D

@onready var temporizador = $Timer
var jugador_encima = false



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		jugador_encima= true
		temporizador.start()
		print("me rompo")


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		jugador_encima = false
		temporizador.stop()
		temporizador.wait_time=2
		temporizador.one_shot = true
		print("me rompi")
