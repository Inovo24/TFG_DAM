extends Node2D

@export var speed: float = 200.0  
@export var damage: int = 20  
var direction: Vector2 = Vector2.RIGHT  

func _process(delta: float):
	
	position += direction * speed * delta
	

func _on_body_entered(_body):
	if _body is TileMapLayer:
		queue_free()
		print("he tocado tierra")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	print("Me desaparezco")
	 


	
