extends Node2D
@onready var timer: Timer = $Animaciones_Trampolin/Timer
@onready var animaciones_trampolin: AnimatedSprite2D = $Animaciones_Trampolin



#Cuando un body toque el area activará el trampolín
func _on_activation_area_body_entered(body: Node2D) -> void:
	# Esto configura el Timer para esperar el tiempo de la animación
	timer.wait_time = animaciones_trampolin.animation.length()
	animaciones_trampolin.play("launch")
	#Altura a la lanza el trampolin
	body.velocity.y = -900
	timer.start()
	
	

# Este método se ejecuta cuando el timer termina
func _on_timer_timeout() -> void:
	# Reproducir la animación "idle" cuando la animación de lanzamiento haya terminado
	animaciones_trampolin.play("idle")
	
