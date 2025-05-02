extends Node2D

@onready var viking: AnimationPlayer = $Vikingo/Vikingo
@onready var valkyrie: AnimationPlayer = $Valkiria/Valkiria
@onready var archer: AnimationPlayer = $Arquero/Arquero

var characters
var infos  

func _ready() -> void:
	# Set exit message
	var exit_key = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$TextoSalir/Label.text = tr("gen_salir").replace("{tecla}", exit_key)
	
	characters = [viking, valkyrie, archer]
	infos = [$VikingoInfo, $ValkiriaInfo, $ArqueroInfo]

	# Set all to the "selector" animation from the beginning
	for character in characters:
		character.play("selector")
	characters[Globales.current_character].play("seleccionado")
	# Get the information of the selected character
	infos[Globales.current_character].visible = true
	

func _process(_delta: float) -> void:
	move_right()
	move_left()
	
	if Input.is_action_just_pressed("salir"):
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")

func move_right():
	if Input.is_action_just_pressed("mover_der"):
		change_character(1)

func move_left():
	if Input.is_action_just_pressed("mover_izq"):
		change_character(-1)


func change_character(direction):
	
	infos[Globales.current_character].visible = false
	characters[Globales.current_character].play("selector")
	
	
	Globales.current_character = (Globales.current_character + direction) % Globales.characters.size()
	
	
	characters[Globales.current_character].play("transicion")
	characters[Globales.current_character].queue("seleccionado")
	infos[Globales.current_character].visible = true
