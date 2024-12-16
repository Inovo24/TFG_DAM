extends Control
class_name LevelSelector

@onready var current_level: LevelIcon = $"1"

func _ready():
	$PlayerIcon.global_position = current_level.global_position

func _input(event):
	if event.is_action_pressed("ui_left") and current_level.next_level_left:
		current_level = current_level.next_level_left
		$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_right") and current_level.next_level_right:
		current_level = current_level.next_level_right
		$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_up") and current_level.next_level_up:
		current_level = current_level.next_level_up
		$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_down") and current_level.next_level_down:
		current_level = current_level.next_level_down
		$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_accept"):
		if current_level.next_scene_path:
			get_tree().change_scene_to_file(current_level.next_scene_path)
