extends "res://Scripts/Personajes.gd"

class_name Vikingo
"""
func _physics_process(delta):
	super._physics_process(delta)
	if Input.get_axis("mover_izq","mover_der"):
		if Input.get_axis("mover_izq","mover_der")<0:
			scale.x *= -1
			$Sprite2D.scale.x = -1
			
		velocity.x = move_toward(velocity.x, Input.get_axis("mover_izq","mover_der")*VELOCIDAD, VELOCIDAD*delta)
		animPlayer.play("correr")
"""
