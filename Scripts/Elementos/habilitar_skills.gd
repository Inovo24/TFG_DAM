extends Node2D

@export var turn_phrases : PackedStringArray
@export var active_phrase : String
@onready var dialogue_label = $Label
@onready var label_skill = $Label_Skill_activa
@onready var audio_stream_player = $AudioStreamPlayer

func _ready() -> void:
	randomize()
	label_skill.text = active_phrase

func show_random_phrase() -> void:
	var index = randi() % turn_phrases.size()
	dialogue_label.text = turn_phrases[index]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		show_random_phrase() 
		dialogue_label.visible = true
		if !body.skill_active:
			audio_stream_player.play()
			body.skill_active = true
			label_skill.visible = true
			await get_tree().create_timer(3).timeout
			label_skill.visible = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		dialogue_label.visible = false
