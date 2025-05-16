extends Node2D

@export var spriteNewCharacter: Texture
@export var spriteOldCharacter: Texture
@export var playerNum: int

@onready var dialogue_label = $Label
@onready var area = $Area2D
@onready var limit = $StaticBody2D

var turn_phrases := [
	"chg_pers_1",
	"chg_pers_2",
	"chg_pers_3",
	"chg_pers_4",
	"chg_pers_5"
]

func _ready() -> void:
	randomize()
	$Vikingo.texture = spriteNewCharacter
	$Vikingo/Vikingo.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and limit != null:
		show_random_phrase() 
		dialogue_label.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and limit != null:
		dialogue_label.visible = false

func show_random_phrase() -> void:
	var index = randi() % turn_phrases.size()
	dialogue_label.text = turn_phrases[index]


func _on_area_2d_cambiar_body_entered(body: Node2D) -> void:
	if limit != null:
		$Vikingo.texture = spriteOldCharacter
		limit.queue_free()
		dialogue_label.visible = false
	
		if Globales.current_character !=playerNum:
				var playerPosition = Globales.get_player().global_position
				Globales.current_character = playerNum
				Globales.player_instance = null
				#print(playerPosition)
				var playerInstancate = Globales.get_player()
				get_parent().add_child(playerInstancate)
				get_parent().player.queue_free()
				get_parent().player = playerInstancate
				get_parent().player.global_position = playerPosition
			
			#get_parent().get_.update_player()
