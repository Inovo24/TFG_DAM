extends Node2D

@onready var vikingo_1: Sprite2D = $Vikingo1
@onready var vikingo_2: Sprite2D = $Vikingo2
@onready var vikingo_3: Sprite2D = $Vikingo3

var pjs
var texturas_selec
var texturas_normales = [preload("res://Sprites/Vikingo/fall_viking.png"),preload("res://Sprites/barco.png"),preload("res://Sprites/fogata.png")]

const pj1Selected  = preload("res://Sprites/tocon.png")
const pj2Selected  = preload("res://Sprites/tocon.png")
const pj3Selected = preload("res://Sprites/tocon.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pjs = [vikingo_1,vikingo_2,vikingo_3]
	texturas_selec =[pj1Selected,pj2Selected,pj3Selected]
	pjs[Globales.personaje_actual].texture =texturas_selec[Globales.personaje_actual]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mover_derecha()
	mover_izquierda()
	
	#Ponemos la textura selecionada al personaje selecionado
	pjs[Globales.personaje_actual].texture =texturas_selec[Globales.personaje_actual] 
	
	#A cambiar era pra probar
	print("Para salir pulsa S")
	if Input.is_action_just_pressed("abajo"):
		get_tree().change_scene_to_file("res://inicio.tscn")

func mover_derecha():
	#Si se pulsa la tecla para la derecha, cambiamos el personaje selecionado en Globales, y cambiamos la textura del
	#anterior a su textura normal y la del selecionado a selecionado
	if Input.is_action_just_pressed("mover_der"):
		pjs[Globales.personaje_actual].texture =texturas_normales[Globales.personaje_actual]
		if(Globales.personaje_actual >= Globales.personajes.size()-1):
			Globales.personaje_actual=0
		else:
			Globales.personaje_actual+=1

func mover_izquierda():
	#Lo mismo que el anterior pero hacia la izquierda
	if Input.is_action_just_pressed("mover_izq"):
		pjs[Globales.personaje_actual].texture =texturas_normales[Globales.personaje_actual]
		if(Globales.personaje_actual <= 0):
			Globales.personaje_actual=Globales.personajes.size()-1
		else:
			Globales.personaje_actual-=1
