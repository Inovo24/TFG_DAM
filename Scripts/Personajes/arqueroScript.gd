extends Characters

class_name Archer

@onready var arrow = preload("res://Scenes/flecha.tscn")
@onready var marker = $Sprite2D/Marker2D

#const ATTACK_COOLDOWN = 0.3

var can_attack : bool = true
#var cooldown_timer: Timer

var arrow_speed = 100
var charge_time : float = 0.0
var max_charge_time : float = 2.0
var is_charging : bool = false

func _ready() -> void:
	max_health = 75
	speed = 250
	current_health = max_health
	
	#cooldown_timer = Timer.new()
	#cooldown_timer.wait_time = ATTACK_COOLDOWN
	#cooldown_timer.one_shot = true
	
	super._ready()
	print(max_health)

func _process(delta):
	add_to_group("player")
	if is_charging:
		charge_time = min(charge_time + delta, max_charge_time)

func attack():
	if can_attack:
		is_charging = true
		charge_time = 0.0
		
		#can_attack = false
		#cooldown_timer.start()
		
		anim_state_machine.travel("ataque1")
	else:
		print("You cannot spam the bow")
	
func down_attack():
	print("ataque bajo")
	anim_state_machine.travel("ataqueBajo")
func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_just_released("ataque"):
		shoot_arrow()
		is_charging = false

func shoot_arrow():
	if arrow:
		var a = arrow.instantiate()
		get_parent().add_child(a)
		a.global_position = marker.global_position
		
		var charge_multiplier = 1.0 + (charge_time / max_charge_time)
		
		a.speed = arrow_speed * charge_multiplier
		a.charge_multiplier = charge_multiplier
		
		var direction = Vector2($Sprite2D.scale.x, 0)
		a.direction = direction
		a.scale.x = abs(a.scale.x) * direction.x
		print("Arrow shot with multiplier: ", charge_multiplier)
	else:
		print("Error: arrow.tscn not found!")
	switch_state(State.IDLE)
