extends StaticBody2D

var damage: int = 2
var playerInside=false
var player

@onready var timer:Timer=$damage
@onready var timer2 = $Timer


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		playerInside = true
		player = body
		player.change_speed(150)
		timer.start()


func _on_timer_timeout():
	if playerInside:
		player.recibirDaño(damage)

func _on_2_timer_timeout():
	player.reset_velocity()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		playerInside = false
		timer2.start()
		timer.stop()
