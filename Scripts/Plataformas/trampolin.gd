extends Node2D
@onready var timer: Timer = $Animaciones_Trampolin/Timer
@onready var trampoline_animations: AnimatedSprite2D = $Animaciones_Trampolin
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# When a body enters the area, it will activate the trampoline
func _on_activation_area_body_entered(body: Node2D) -> void:
	# This sets the Timer to wait for the animation duration
	timer.wait_time = trampoline_animations.animation.length()
	audio_stream_player_2d.play()
	trampoline_animations.play("launch")
	# Height the trampoline launches the body
	body.velocity.y = -650
	timer.start()

# This method is executed when the timer finishes
func _on_timer_timeout() -> void:
	pass
	# Play the "idle" animation when the launch animation has finished
	#trampoline_animations.play("idle")

func _on_trampoline_animations_animation_finished():
	trampoline_animations.play("idle")
