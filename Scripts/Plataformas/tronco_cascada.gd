extends Node2D


@export var tiempo_minimo_reaparicion = 2.0
@export var tiempo_maximo_reaparicion = 5.0


var tiempo_reaparicion = 0.0
var desaparecido = false
var anim: AnimationPlayer

func _ready():
# Guarda la posición inicial en el eje Y
	anim = $AnimationPlayer
	anim.play("move")
	reaparecer()

func _process(delta):
	print(position)
	if desaparecido:
		tiempo_reaparicion -= delta
	
	if tiempo_reaparicion <=0:
		reaparecer()
		
func desaparecer():
	# Oculta la plataforma
	visible = false
	desaparecido = true
	set_deferred("disable_mode",true)
	
	# Calcula un tiempo de reaparición aleatorio
	tiempo_reaparicion = randf_range(tiempo_minimo_reaparicion, tiempo_maximo_reaparicion)

func reaparecer():
# Restablece la posición Y a la posición inicial
	
# Muestra la plataforma
	visible = true
	desaparecido = false
	set_deferred("disable_mode", false)
	anim.play("move")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move":
		desaparecer()
