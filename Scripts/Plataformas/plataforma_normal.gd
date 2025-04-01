extends Path2D
class_name MovingPLatform

@export var path_follow_2d:PathFollow2D
@export var path_time = 1.0
@export var ease: Tween.EaseType
@export var transition : Tween.TransitionType
@export var looping = false

func _ready() -> void:
	move_tween()
	

func move_tween():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(path_follow_2d, "progress_ratio", 1.0, path_time).set_ease(ease).set_trans(transition)
	if !looping:
		tween.tween_property(path_follow_2d, "progress_ratio", 0.0, path_time).set_ease(ease).set_trans(transition)
	else: 
		tween.tween_property(path_follow_2d, "progress_ratio", 0.0, 0.0).set_ease(ease).set_trans(transition)
