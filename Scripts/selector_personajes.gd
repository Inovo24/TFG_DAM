"""extends Node2D

#@onready var vikingo: Sprite2D = $Vikingo
#@onready var valkiria: Sprite2D = $Valkiria
#@onready var arquero: Sprite2D = $Arquero

@onready var vikingo: AnimationPlayer= $Vikingo/Vikingo
@onready var valkiria: AnimationPlayer = $Valkiria/Valkiria
@onready var arquero: AnimationPlayer = $Arquero/Arquero
var  pjs
#var texturas_selec 
var infos

#const  texturas_normales = [preload("res://Sprites/Vikingo/fall_viking.png"),preload("res://Sprites/barco.png"),preload("res://Sprites/fogata.png")]

#const vikingoSelected  = preload("res://Sprites/tocon.png")
#const valkiriaSelected  = preload("res://Sprites/tocon.png")
#const arqueroSelected = preload("res://Sprites/tocon.png")





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pjs = [vikingo,valkiria,arquero]
	#texturas_selec =[vikingoSelected,valkiriaSelected,arqueroSelected]
	
	infos = [$VikingoInfo,$ValkiriaInfo,$ArqueroInfo]
	#pjs[Globales.personaje_actual].texture =texturas_selec[Globales.personaje_actual]
	pjs[Globales.personaje_actual].play("selector")
	infos[Globales.personaje_actual].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mover_derecha()
	mover_izquierda()
	
	#Ponemos la textura selecionada al personaje selecionado
	#pjs[Globales.personaje_actual].texture =texturas_selec[Globales.personaje_actual] 
	
	
	infos[Globales.personaje_actual].visible = true
	
	#A cambiar era pra probar
	if Input.is_action_just_pressed("abajo"):
		get_tree().change_scene_to_file("res://inicio.tscn")

func mover_derecha():
	#Si se pulsa la tecla para la derecha, cambiamos el personaje selecionado en Globales, y cambiamos la textura del
	#anterior a su textura normal y la del selecionado a selecionado
	if Input.is_action_just_pressed("mover_der"):
		infos[Globales.personaje_actual].visible = false
		#pjs[Globales.personaje_actual].texture =texturas_normales[Globales.personaje_actual]
		pjs[Globales.personaje_actual].play("transicion")
		pjs[Globales.personaje_actual].queue("seleccionado")
		if(Globales.personaje_actual >= Globales.personajes.size()-1):
			Globales.personaje_actual=0
		else:
			Globales.personaje_actual+=1

func mover_izquierda():
	#Lo mismo que el anterior pero hacia la izquierda
	if Input.is_action_just_pressed("mover_izq"):
		infos[Globales.personaje_actual].visible = false
		#pjs[Globales.personaje_actual].texture =texturas_normales[Globales.personaje_actual]
		pjs[Globales.personaje_actual].play("transicion")
		pjs[Globales.personaje_actual].queue("seleccionado")
		if(Globales.personaje_actual <= 0):
			Globales.personaje_actual=Globales.personajes.size()-1
		else:
			Globales.personaje_actual-=1
			
"""
extends Node2D

@onready var vikingo: AnimationPlayer = $Vikingo/Vikingo
@onready var valkiria: AnimationPlayer = $Valkiria/Valkiria
@onready var arquero: AnimationPlayer = $Arquero/Arquero

var pjs 
var infos  

func _ready() -> void:
	
	pjs = [vikingo, valkiria, arquero]
	infos = [$VikingoInfo, $ValkiriaInfo, $ArqueroInfo]

	# Poner a todos con la anim selector desde el principio
	for personaje in pjs:
		personaje.play("selector")
	pjs[Globales.personaje_actual].play("seleccionado")
	

func _process(delta: float) -> void:
	mover_derecha()
	mover_izquierda()
	
	if Input.is_action_just_pressed("abajo"):
		get_tree().change_scene_to_file("res://inicio.tscn")

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
	
