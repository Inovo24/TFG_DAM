extends Characters
class_name Viking

@onready var area_ataque: Area2D = $Sprite2D/Area2D

func _ready() -> void:
	add_to_group("player")
	super._ready()

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
	elif body.has_method("take_damage"):
		body.take_damage(damage)
