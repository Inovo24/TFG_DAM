extends Node2D

@export var speed: float = 200.0  # Speed of the arrow
@export var damage: int = 20  # Damage dealt by the arrow
var direction: Vector2 = Vector2.RIGHT  # Default direction

func _process(delta: float):
	# Move the arrow
	position += direction * speed * delta
	
	
	# Remove arrow if it goes off-screen
	#if not get_viewport_rect().has_point(global_position):
		#queue_free()

func _on_body_entered(body):
	queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	 


func _on_area_entered(area):
	if area is TileMapLayer:
		queue_free()
	
