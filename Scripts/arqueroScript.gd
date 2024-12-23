extends Personajes

class_name arquero

@onready var flecha = preload("res://Scenes/flecha.tscn")
@onready var marker = $Sprite2D/Marker2D



func _ready() -> void:
	vida_maxima = 75
	velocidad  = 250
	vida_actual = vida_maxima
	super._ready()
	print(vida_maxima)

	

func atacar():
	super.atacar()
	
	if flecha:
		var f = flecha.instantiate()  # Instantiate the arrow
		get_tree().root.add_child(f)  # Add it to the scene
		
		# Set its position at the marker
		f.global_position = marker.global_position
		
		# Determine direction (e.g., left or right based on player scale)
		var direction = Vector2($Sprite2D.scale.x, 0)
		f.direction = direction
		f.scale.x = abs(f.scale.x) * direction.x
		print("Arrow instantiated at:", f.global_position)
		print("Marker position:", marker.global_position)
	else:
		print("Error: flecha.tscn not found!")
