extends Area2D

@onready var checkpoint_active_sprite = preload("res://Sprites/Elementos/checkPoint/activado.png")
@onready var sprite = $Sprite2D
@onready var active = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !active:
		body.set_checkpoint_position()
		active = true
		sprite.texture = checkpoint_active_sprite
