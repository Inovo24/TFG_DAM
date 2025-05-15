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
	#deal_damage_valkyrie()
func down_attack():
	print("ataque bajo")
	anim_state_machine.travel("ataqueBajo")
	#deal_damage_valkyrie()
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hello?")
	if body.is_in_group("Enemies"):
		body.receive_damage(damage)
	elif body.has_method("take_damage"):
		body.take_damage(damage)
	#deal_damage_valkyrie()

'''
#Para romper bloques
func deal_damage_valkyrie():
	var space_state = get_world_2d().direct_space_state
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(2, 2)

	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0, global_position + Vector2($Sprite2D.scale.x * 24, 0))
	params.collision_mask = 1 << 13
	params.collide_with_bodies = true

	var result = space_state.intersect_shape(params, 20)
	for hit in result:
		if hit.collider.has_method("take_damage"):
			hit.collider.take_damage(damage)
'''
