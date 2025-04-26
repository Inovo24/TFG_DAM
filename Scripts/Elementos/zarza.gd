extends StaticBody2D

var damage: int = 2
var player

@onready var timer: Timer = $damage

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player = body
		if player.zarzas_touching == 0:
			player.change_speed(0.5)
			timer.start()

		player.zarzas_touching += 1
		

func _on_timer_timeout():
	if player and player.zarzas_touching >0:
		player.recibirDaño(damage)

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player.zarzas_touching -=1
		if player.zarzas_touching == 0:
			player.reset_velocity()
			timer.stop()
		
		
