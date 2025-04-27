extends Control
class_name LevelSelector

@onready var current_level: LevelIcon = $"1"
@export var offset_y: float = -50
@export var offset_x: float = -10

func _ready():
	$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
	
	var salir_tecla = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$TextoSalir.text = tr("gen_salir").replace("{tecla}",salir_tecla)

func _input(event):
	if event.is_action_pressed("mover_izq") and current_level.next_level_left:
		current_level = current_level.next_level_left
		$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
	if event.is_action_pressed("mover_der") and current_level.next_level_right:
		current_level = current_level.next_level_right
		$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
	if event.is_action_pressed("arriba") and current_level.next_level_up:
		current_level = current_level.next_level_up
		$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
	if event.is_action_pressed("abajo") and current_level.next_level_down:
		current_level = current_level.next_level_down
		$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
	if event.is_action_pressed("aceptar_entrar"):
		if current_level.next_scene_path:
			get_tree().change_scene_to_file(current_level.next_scene_path)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("salir"):
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
