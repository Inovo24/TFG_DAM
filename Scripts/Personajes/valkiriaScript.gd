extends Characters

class_name Valkyrie

var dash_cooldown = 0.25  # Tiempo para detectar doble tap
var dash_duration = 0.2
var dash_speed = 800      # Velocidad del dash
var is_dashing = false
var is_taking_damage := false
var last_dash_direction = ""
var dash_timer := Timer.new()


func _ready() -> void:
	add_to_group("player")
	super._ready()
	max_health = 150
	current_health = max_health  # Ensure this is updated as well.
	speed = 150
	damage = 35
	print(max_health)
	
	dash_timer.wait_time = dash_cooldown
	dash_timer.one_shot = true
	add_child(dash_timer)

func _physics_process(delta):
	# 🔁 Ejecuta primero la lógica base del personaje
	super._physics_process(delta)

	# Añade solo el comportamiento especial de Valkyrie
	if not skill_active or not can_move or is_dashing:
		return

	if Input.is_action_just_pressed("mover_der"):
		if last_dash_direction == "right" and dash_timer.time_left > 0:
			start_dash(Vector2.RIGHT)
		else:
			last_dash_direction = "right"
			dash_timer.start()
	elif Input.is_action_just_pressed("mover_izq"):
		if last_dash_direction == "left" and dash_timer.time_left > 0:
			start_dash(Vector2.LEFT)
		else:
			last_dash_direction = "left"
			dash_timer.start()

func start_dash(direction: Vector2):
	is_dashing = true
	#can_move = false
	velocity.x = direction.x * dash_speed
	#anim_state_machine.travel("dash") # si tienes una animación
	await get_tree().create_timer(dash_duration).timeout
	
	velocity.x = 0
	is_dashing = false
	#can_move = true


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
#Llamada función padre y solo agrega la animación de daño
func take_damage(damage_received: int):
	if is_taking_damage:
		return

	is_taking_damage = true
	super.take_damage(damage_received)

	if animPlayer and animPlayer.has_animation("daño"):
		var previous_anim = anim_state_machine.get_current_node()
		anim_state_machine.travel("daño")

		await get_tree().create_timer(0.15).timeout

		if current_health > 0:
			anim_state_machine.travel(previous_anim)

	is_taking_damage = false
