extends CharacterBody2D

@export var platforms_array:Node
var platforms

@onready var invert_timer := $InvertTimer
@onready var platform_timer := $PlatformsTimer
@onready var hallucination_overlay = preload("res://Scenes/Niveles/hallucination_overlay.tscn")
var hallucination_instance: Node = null
@onready var death_odin_escene = preload("res://Scenes/Elementos/odin_derrotado.tscn")
var death_odin_instance: Node = null

@onready var fireball_scene: PackedScene = preload("res://Scenes/Elementos/fireball.tscn")
var player
var vulnerable = false
var max_life = 300
var life = max_life

var fireball_delay := 1
var vulnerable_time := 2
var start_position

enum BossState { FASE1, FASE2, DERROTA }
var current_state: BossState = BossState.FASE1

func _ready():
	add_to_group("Enemies")
	player = Globales.get_player()
	enter_state(current_state)
	start_invert_timer()
	start_position = global_position

func _process(delta):
	match current_state:
		BossState.FASE1:
			state_fase1_process(delta)
		BossState.FASE2:
			state_fase2_process(delta)
		BossState.DERROTA:
			state_derrota_process(delta)

func change_state(new_state: BossState):
	exit_state(current_state)
	current_state = new_state
	enter_state(new_state)

func enter_state(state: BossState):
	match state:
		BossState.FASE1:
			enter_fase1()
		BossState.FASE2:
			enter_fase2()
		BossState.DERROTA:
			enter_derrota()

func exit_state(state: BossState):
	match state:
		BossState.FASE1:
			exit_fase1()
		BossState.FASE2:
			exit_fase2()
		BossState.DERROTA:
			exit_derrota()

#-------------GENERAL-----------
func start_invert_timer():
	var rand_time = randf_range(10.0, 20.0)
	invert_timer.start(rand_time)
	#shoot_fireball()

# Conecta este método al timeout del Timer (en el editor o con código)
func _on_invert_timer_timeout():
	print("🌀 Invirtiendo controles")
	player.set_controls_inverted(true)
	if hallucination_instance == null:
			hallucination_instance = hallucination_overlay.instantiate()
			get_tree().current_scene.add_child(hallucination_instance)
	await get_tree().create_timer(5.0).timeout
	player.set_controls_inverted(false)
	if hallucination_instance:
			hallucination_instance.queue_free()
			hallucination_instance = null
	print("✅ Controles restaurados")
	start_invert_timer()

func receive_damage(damage):
	if vulnerable and current_state == BossState.FASE1:
		life -= damage
		print(damage)
		print(life)
		if life < max_life/2:
			change_state(BossState.FASE2)
		elif life <0:
			get_parent().end_level()
			queue_free()

func await_until_unpaused():
	while get_tree().paused:
		await get_tree().process_frame

# ------------- FASE 1 -------------
func enter_fase1():
	print("Entrando en Fase 1")
	platforms = platforms_array.get_children()
	start_platform_timer()
	await get_tree().create_timer(1.0).timeout
	start_shooting_fire()

func exit_fase1():
	print("Saliendo de Fase 1")
	platform_timer.queue_free()
	reset_platforms()
	
	#Comentario loki
	if death_odin_instance == null:
			death_odin_instance = death_odin_escene.instantiate()
			get_tree().current_scene.add_child(death_odin_instance)

func state_fase1_process(delta):
	if vulnerable:
		self.modulate = Color(1, 1, 1, 1)
	else:
		self.modulate = Color(1, 1, 1, 0.7)

func shoot_fireball():
	print("shoot")
	var fireball = fireball_scene.instantiate()
	
	fireball.position = $ShootPoint.position
	fireball.initialize(player)
	
	add_child(fireball)

func start_platform_timer():
	var rand_time = randf_range(7.0, 15.0)
	platform_timer.start(rand_time)

func _on_platforms_timer_timeout() -> void:
	
	for platform in platforms:
		
		if not platform: continue
		var sprite = platform.get_node_or_null("Sprite2D")
		var collision = platform.get_node_or_null("StaticBody2D/CollisionShape2D")
		#print(collision)
		
		var mode = randi() % 10
		match mode:
			0,1,2,3,4: # visible sin colisión
				if sprite: 
					sprite.visible = true
					sprite.modulate = Color(1, 1, 1, 0.8)
				if collision: collision.disabled = true
			5: # invisible y sin colisión
				if sprite: sprite.visible = false
				if collision: collision.disabled = true
			6,7,8,9: # visible y con colisión
				if sprite: 
					sprite.visible = true
					sprite.modulate = Color(1, 1, 1, 1) 
				if collision: collision.disabled = false
	
	start_platform_timer()

func start_shooting_fire():
	await await_until_unpaused()
	move_boss_to_random_platform()
	var rand_num = randf_range(3, 5)
	for i in range(rand_num):
		await await_until_unpaused()  # Espera antes de disparar
		shoot_fireball()
		await await_until_unpaused()  # Espera antes de esperar
		await get_tree().create_timer(fireball_delay).timeout
	vulnerable = true
	await await_until_unpaused()
	await get_tree().create_timer(fireball_scene.instantiate().time_life).timeout
	await await_until_unpaused()  
	move_boss_to_start_position()
	await await_until_unpaused()  
	await get_tree().create_timer(vulnerable_time).timeout
	vulnerable = false
	
	if current_state == BossState.FASE1:
		start_shooting_fire()

func move_boss_to_start_position():
	global_position = start_position

func move_boss_to_random_platform():
	if platforms.size() == 0:
		return

	var random_platform = platforms[randi() % platforms.size()]
	if random_platform:  # Asegúrate de que no sea null
		global_position = random_platform.global_position #+ Vector2(0, -50)
		var sprite = random_platform.get_node_or_null("Sprite2D")
		if sprite:
			sprite.visible = true

func reset_platforms():
	await get_tree().create_timer(1).timeout
	for platform in platforms:
		if not platform: continue
		var sprite = platform.get_node_or_null("Sprite2D")
		var collision = platform.get_node_or_null("StaticBody2D/CollisionShape2D")
		if sprite: 
			sprite.visible = true
			sprite.modulate = Color(1, 1, 1, 1)
		if collision:
			#print("colision")
			collision.disabled = false

# ------------- FASE 2 -------------
func enter_fase2():
	await get_tree().create_timer(5.0).timeout
	if death_odin_instance:
			death_odin_instance.queue_free()
			death_odin_instance = null

func exit_fase2():
	print("Saliendo de Fase 2")

func state_fase2_process(delta):
	pass # Aquí irá la lógica de la Fase 2

# ------------- DERROTA -------------
func enter_derrota():
	print("Boss derrotado")

func exit_derrota():
	pass # Por si quieres añadir lógica de limpieza

func state_derrota_process(delta):
	pass # Lógica de animación de derrota si es necesaria
