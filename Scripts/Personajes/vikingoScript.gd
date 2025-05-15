extends Characters
class_name Viking

@onready var frontal: CollisionShape2D = $Sprite2D/Area2D/frontal
@onready var aereo: CollisionShape2D = $Sprite2D/Area2D/aereo
@onready var bajo: CollisionShape2D = $Sprite2D/Area2D/bajo
@onready var area_ataque: Area2D = $Sprite2D/Area2D

func _ready() -> void:
	add_to_group("player")
	super._ready()
	set_hitbox(false, false, false)

func attack():
	activate_hitbox()  #  Activamos el hitbox correcto

	
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

func activate_hitbox():
	if not is_on_floor():
		if Input.is_action_pressed("arriba"):
			set_hitbox(false, true, false)
		elif Input.is_action_pressed("abajo"):
			set_hitbox(true, false, false)
		else:
			set_hitbox(false, true, false)
	else:
		if Input.is_action_pressed("arriba"):
			set_hitbox(false, true, false)
		elif Input.is_action_pressed("abajo"):
			set_hitbox(true, false, false)
		else:
			set_hitbox(false, false, true)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	set_hitbox(false, false, false)

func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.receive_damage(damage)
	elif body.has_method("take_damage"):
		body.take_damage(damage)

func set_hitbox(act_bajo: bool, act_aereo: bool, act_frontal: bool):
	bajo.disabled = not act_bajo
	aereo.disabled = not act_aereo
	frontal.disabled = not act_frontal
