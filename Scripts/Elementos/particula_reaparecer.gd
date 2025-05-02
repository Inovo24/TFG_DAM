extends AnimatedSprite2D

func _ready():
	play("reaparecer")
	await animation_finished
	queue_free()
