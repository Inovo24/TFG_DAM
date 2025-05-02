extends Node2D  # O el tipo de nodo raíz de tu efecto

@onready var sprite: AnimatedSprite2D = $Animación


func _ready():
	sprite.play("reaparecer")  # Asegúrate de que la animación se llama así
	sprite.connect("animation_finished", Callable(self, "_on_appear_finished"))

func _on_appear_finished():
	queue_free()
