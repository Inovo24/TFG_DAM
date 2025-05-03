extends Node2D

@onready var sprite: AnimatedSprite2D = $Animación

func _ready():
	# Comienza invisible
	sprite.modulate.a = 0.0
	
	# Reproduce la animación
	sprite.play("reaparecer")
	
	# Fade in suave
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Conecta el final de la animación a la función
	sprite.connect("animation_finished", Callable(self, "_on_appear_finished"))

func _on_appear_finished():

	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	await tween.finished
	queue_free()
