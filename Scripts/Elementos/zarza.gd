extends StaticBody2D

var damage: int = 2
var playerInside=false
var player

@onready var timer:Timer=$damage


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player = body
		
		if not playerInside:
			playerInside = true
		if playerInside:
			player.change_speed(0.5)
			print(player.velocidad)
			timer.start()
		
		


func _on_timer_timeout():
	if playerInside:
		player.recibirDaño(damage)


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		playerInside = false
		timer.stop()
		body.reset_velocity()
		print(body.velocidad)
