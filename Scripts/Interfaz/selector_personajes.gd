extends Node2D

@onready var vikingo: AnimationPlayer = $Vikingo/Vikingo
@onready var valkiria: AnimationPlayer = $Valkiria/Valkiria
@onready var arquero: AnimationPlayer = $Arquero/Arquero

var pjs 
var infos  

func _ready() -> void:
	#Poner mensaje de salir
	var salir_tecla = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$TextoSalir/Label.text =  tr("gen_salir").replace("{tecla}",salir_tecla)
	
	pjs = [vikingo, valkiria, arquero]
	infos = [$VikingoInfo, $ValkiriaInfo, $ArqueroInfo]

	# Poner a todos con la anim selector desde el principio
	for personaje in pjs:
		personaje.play("selector")
	pjs[Globales.personaje_actual].play("seleccionado")
	#Cogemos la informacion del personaje selecionado
	infos[Globales.personaje_actual].visible = true
	

func _process(_delta: float) -> void:
	mover_derecha()
	mover_izquierda()
	
	if Input.is_action_just_pressed("salir"):
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")

func mover_derecha():
	if Input.is_action_just_pressed("mover_der"):
		cambiar_personaje(1)

func mover_izquierda():
	if Input.is_action_just_pressed("mover_izq"):
		cambiar_personaje(-1)


func cambiar_personaje(direccion):
	
	infos[Globales.personaje_actual].visible = false
	pjs[Globales.personaje_actual].play("selector")
	
	
	Globales.personaje_actual = (Globales.personaje_actual + direccion) % Globales.personajes.size()
	
	
	pjs[Globales.personaje_actual].play("transicion")
	pjs[Globales.personaje_actual].queue("seleccionado")
	infos[Globales.personaje_actual].visible = true
	
