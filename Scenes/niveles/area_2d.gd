extends Area2D

@export var playerCamera: Camera2D
@export var staticCamera: Camera2D

func _on_body_entered(body):
	staticCamera.make_current()


func _on_body_exited(body):
	playerCamera.make_current()
