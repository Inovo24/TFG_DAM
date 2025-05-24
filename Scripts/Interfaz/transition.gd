extends CanvasLayer

@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer
@onready var color_rect = $ColorRect

var next_scene_path: String

signal transition_finished()

func fade_in(duration: float = 0.5):
	color_rect.color.a = 1.0
	animation_player.play_backwards("fade")
	await animation_player.animation_finished

func fade_out(duration: float = 0.5):
	color_rect.color.a = 0.0
	animation_player.play("fade")
	await animation_player.animation_finished

func change_scene(path: String):
	next_scene_path = path
	await fade_out()
	get_tree().change_scene_to_file(next_scene_path)
	await fade_in()
	emit_signal("transition_finished")

func _ready():
	color_rect.color.a = 0.0 # Iniciar transparente
