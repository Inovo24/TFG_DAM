extends Control
class_name LevelIcon

@export var level_name:= "1"

@export_file("*.tscn") var next_scene_path: String

@export var next_level_up: LevelIcon
@export var next_level_down: LevelIcon
@export var next_level_left: LevelIcon
@export var next_level_right: LevelIcon

func _ready():
	$Label.text =  str(level_name)

func _process(_delta):
	if Engine.is_editor_hint():
		$Label.text = str(level_name)
