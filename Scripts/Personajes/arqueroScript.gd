extends Personajes

class_name arquero

@onready var flecha = preload("res://Scenes/flecha.tscn")
@onready var marker = $Sprite2D/Marker2D

#const ATAQUE_COOLDOWN = 0.3

var puede_atacar : bool = true
#var cooldown_timer: Timer

var velocidadFlecha = 100
var tiempo_carga : float = 0.0
var tiempo_max_carga : float = 2.0
var esta_cargando : bool = false


func _ready() -> void:
	vida_maxima = 75
	velocidad  = 250
	vida_actual = vida_maxima
	
	#cooldown_timer = Timer.new()
	#cooldown_timer.wait_time = ATAQUE_COOLDOWN
	#cooldown_timer.one_shot = true
	
	super._ready()
	print(vida_maxima)


func _process(delta):
	if esta_cargando:
		tiempo_carga = min(tiempo_carga + delta, tiempo_max_carga)

func atacar():#
	if puede_atacar:
		#super.atacar()
		esta_cargando = true
		tiempo_carga = 0.0
		
		#puede_atacar=false
		#cooldown_timer.start()
		
		anim_state_machine.travel("ataque1")
	else:
		print("No puedes ametrallar con el arco")
	
func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_just_released("ataque"):
		disparar_flecha()
		esta_cargando=false


func _on_animation_finished(anim_name):
	#if anim_name == "ataque1":
		#pass
		#disparar_flecha()
		"""
		if flecha:
			var f = flecha.instantiate()  # Instantiate the arrow
			get_tree().root.add_child(f)  # Add it to the scene
			
			# Set its position at the marker
			f.global_position = marker.global_position
			
			# Determine direction (e.g., left or right based on player scale)
			var direction = Vector2($Sprite2D.scale.x, 0)
			f.direction = direction
			f.scale.x = abs(f.scale.x) * direction.x
			print("Arrow instantiated at:", f.global_position)
			print("Marker position:", marker.global_position)
			if Input.is_action_just_released("ataque"):
				f.speed = velocidadFlecha /4
		else:
			print("Error: flecha.tscn not found!")
		switch_state(State.IDLE)
		"""
func disparar_flecha():
	if flecha:
		var f = flecha.instantiate()
		get_tree().root.add_child(f)
		f.global_position = marker.global_position
		
		var multiplicador_carga = 1.0 + (tiempo_carga / tiempo_max_carga)
		
		f.speed = velocidadFlecha * multiplicador_carga
		f.multiplicador_carga = multiplicador_carga
		
		var direction = Vector2($Sprite2D.scale.x, 0)
		f.direction = direction
		f.scale.x = abs(f.scale.x) * direction.x
		print("Flecha disparada con multiplicador: ", multiplicador_carga)
	else:
		print("Error: flecha.tscn not found!")
	switch_state(State.IDLE)
