extends Node2D
@onready var dialogue_label = $Label
@onready var area = $Area2D

func _ready() -> void:
	dialogue_label.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		dialogue_label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		dialogue_label.visible = false
