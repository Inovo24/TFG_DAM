extends StaticBody2D

@onready var sprite := $Sprite2D  
@onready var tween := create_tween()

var original_position := Vector2.ZERO
var press_signal = "placa_press"
var release_signal = "placa_release"

func _ready():
	original_position = position
	
	var parent = get_parent()

	if parent.has_signal(press_signal):
		print(press_signal)
		parent.connect(press_signal, Callable(self, "_on_press"))
	
	if parent.has_signal(release_signal):
		parent.connect(release_signal, Callable(self, "_on_release"))
	

func _on_press():
	if tween and tween.is_valid():
		tween.kill()  # Cancelar tween anterior si está en curso
	var height = sprite.texture.get_height()
	tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0, height), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_release():
	if tween and tween.is_valid():
		tween.kill()  # Cancelar tween anterior si está en curso
	tween = create_tween()
	tween.tween_property(self, "position", original_position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Characters:
		_on_release()
