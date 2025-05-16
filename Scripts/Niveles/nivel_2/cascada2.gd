extends Area2D

@onready var marker = $"../Marker2D"

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = marker.global_position
