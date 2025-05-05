extends Characters

class_name Valkyrie

func _ready() -> void:
	add_to_group("player")
	super._ready()
	max_health = 150
	current_health = max_health  # Ensure this is updated as well.
	speed = 150
	damage = 35
	print(max_health)

func attack():
	anim_state_machine.travel("ataque1")
func down_attack():
	print("ataque bajo")
	anim_state_machine.travel("ataqueBajo")
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hello?")
	if body.is_in_group("Enemies"):
		body.receive_damage(damage)
