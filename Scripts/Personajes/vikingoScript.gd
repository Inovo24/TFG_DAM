extends Characters
class_name Viking

@onready var area_ataque: Area2D = $Sprite2D/Area2D

var wall_jump_speed = Vector2(250, -400)
var is_on_wall := false
var wall_normal := Vector2.ZERO
const WALL_SLIDE_SPEED:float = 80  # Velocidad máxima de deslizamiento por pared
func _ready() -> void:
	add_to_group("player")
	#skill_active = true
	super._ready()

func _physics_process(delta: float) -> void:
	super(delta)
	
	if skill_active:
		is_on_wall = false
		wall_normal = Vector2.ZERO

		# Recorremos todas las colisiones para detectar si estamos tocando una pared
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if abs(c.get_normal().x) > 0.9:
				is_on_wall = true
				wall_normal = c.get_normal()
				break
		if is_on_wall:
			# Wall slide: desacelera la caída si va presionando hacia la pared
			var pressing_towards_wall = (
				(Input.is_action_pressed("mover_izq") and wall_normal.x > 0) or
				(Input.is_action_pressed("mover_der") and wall_normal.x < 0)
			)

			if velocity.y > 0 and pressing_towards_wall:
				# Aplica una velocidad de caída más lenta progresiva
				velocity.y = lerp(velocity.y, WALL_SLIDE_SPEED, 0.1)

			# Wall jump
			if Input.is_action_just_pressed("salto"):
				velocity.x = wall_jump_speed.x * -wall_normal.x
				velocity.y = wall_jump_speed.y
				switch_state(State.JUMP)

func attack():
	if combo_count == 0:
		anim_state_machine.travel("ataque1")
		combo_count += 1
		combo_timer.start()
		damage = 30
	elif combo_count == 1 and combo_timer.time_left > 0:
		print("combo 2")
		anim_state_machine.travel("ataque2")
		combo_count += 1
		combo_timer.start()
		damage = 32
	elif combo_count == 2 and combo_timer.time_left > 0:
		print("combo 3")
		anim_state_machine.travel("ataque3")
		combo_count = 0
		damage = 34
	else:
		combo_count = 0 

func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.receive_damage(damage)
		print("Se detecto body")
	elif body.has_method("take_damage"):
		body.take_damage(damage)
