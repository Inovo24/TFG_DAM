extends RigidBody2D

@onready var recolector = $recolector

@export var float_force := 30.0
@export var float_frequency := 4.5
@export var float_damping := 0.95

var float_timer := 0.0

func _ready():
	gravity_scale = 0.2
	recolector.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	float_timer += delta
	var vertical_force = sin(float_timer * float_frequency) * float_force * delta
	apply_central_force(Vector2(0, -vertical_force))
	linear_velocity.x *= float_damping

func _on_body_entered(body: Node2D) -> void:
	if body is Characters:
		var level = get_tree().current_scene
		if level.has_method("collect_gem"):
			level.collect_gem()
			
		queue_free()
