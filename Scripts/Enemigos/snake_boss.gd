extends CharacterBody2D
class_name SnakeBoss

# === CONFIGURACIÓN ===
@export var velocidad_base: float = 100.0
@export var velocidad_dash: float = 600.0
@export var fuerza_knockback: float = 450.0
@export var daño_normal: int = 10
@export var daño_embestida: int = 20
@export var daño_aparicion: int = 15
@export var vida_maxima: int = 100
@export var gravedad: float = 800.0
@export var limites_arena: Rect2 = Rect2(Vector2(0, 0), Vector2(1024, 768))
@onready var dash_1: AudioStreamPlayer2D = $Dash1
@onready var dash_2: AudioStreamPlayer2D = $Dash2
@onready var emerging: AudioStreamPlayer2D = $Emerging
@onready var hissing: AudioStreamPlayer2D = $Hissing
@onready var bite: AudioStreamPlayer2D = $Bite

# === ESTADO INTERNO ===
var vida_actual: int = vida_maxima
var fase: int = 1
var enfurecido: bool = false
var esta_teletransportando: bool = false
var dashing: bool = false
var direccion_horizontal: int = 1
var objetivo: Node2D = null
var esta_atacando: bool = false
var proximo_ataque_normal: bool = true

# === REFERENCIAS ===
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_detec: Area2D = $detection_player
@onready var shape_embestida: CollisionShape2D = $area_embestida/CollisionShape2D
@onready var area_ataque: Area2D = $ataque_normal
@onready var shape_ataque_izq: CollisionShape2D = $ataque_normal/izquierda
@onready var shape_ataque_der: CollisionShape2D = $ataque_normal/derecha
@onready var ataque_aparicion: Area2D = $Ataque_aparicion
@onready var area_recibir_daño: Area2D = $area_recibir_daño
@onready var timer_ataque: Timer = $attack_timer
@onready var salida: AnimatedSprite2D = $salida

func _ready():
	_disable_all_attacks()

	sprite.play("aparicion")
	await sprite.animation_finished
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if vida_actual <= 0:
		return

	velocity.y += gravedad * delta

	if not esta_atacando:
		velocity.x = velocidad_base * direccion_horizontal
	else:
		if not dashing:
			velocity.x = 0

	move_and_slide()

	if is_on_wall():
		direccion_horizontal *= -1
		sprite.flip_h = direccion_horizontal < 0

	global_position.x = clamp(global_position.x, limites_arena.position.x, limites_arena.position.x + limites_arena.size.x)
	global_position.y = clamp(global_position.y, limites_arena.position.y, limites_arena.position.y + limites_arena.size.y)
	sprite.flip_h = direccion_horizontal < 0

func _on_detection_player_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		objetivo = body
		if not timer_ataque.is_stopped():
			timer_ataque.stop()
		timer_ataque.wait_time = 2.0  # o más si lo quieres más lento
		timer_ataque.start()

func _on_detection_player_body_exited(body: Node) -> void:
	if body == objetivo:
		objetivo = null
		

func _on_attack_timer_timeout() -> void:
	if esta_atacando or objetivo == null or not is_instance_valid(objetivo):
		return

	match fase:
		1:
			if proximo_ataque_normal:
				ataque_normal()
			else:
				dash_basico()
			proximo_ataque_normal = not proximo_ataque_normal
		2:
			dash_ida_vuelta()
		3:
			teleport_y_ataque()

func _on_ataque_normal_body_entered(body: Node) -> void:
	if not dashing and body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(daño_normal)
		if body.has_method("apply_knockback"):
			var dir: float = sign(body.global_position.x - global_position.x)
			body.apply_knockback(dir * (fuerza_knockback * 0.6))


func ataque_normal() -> void:
	esta_atacando = true

	if objetivo != null and is_instance_valid(objetivo):
		direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	sprite.flip_h = direccion_horizontal < 0

	_disable_all_attacks()

	# Activamos animación y sonido
	sprite.play("ataque")
	bite.play()

	# Esperamos justo antes del impacto 
	await get_tree().create_timer(0.25).timeout

	# Activar área de daño solo durante el momento del impacto
	area_ataque.monitoring = true
	if direccion_horizontal < 0:
		shape_ataque_izq.disabled = false
	else:
		shape_ataque_der.disabled = false

	# Tiempo durante el cual se mantiene activa la colisión (ajustable)
	await get_tree().create_timer(0.2).timeout

	_disable_all_attacks()

	# Esperamos a que termine la animación para pasar a idle
	await sprite.animation_finished

	sprite.play("idle")
	esta_atacando = false

	# Espera antes del siguiente ataque
	await get_tree().create_timer(1.2).timeout


func dash_basico() -> void:
	esta_atacando = true
	sprite.play("inicio_movimiento")
	hissing.play()
	await sprite.animation_finished

	if objetivo == null or not is_instance_valid(objetivo):
		sprite.play("idle")
		esta_atacando = false
		return

	direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	sprite.flip_h = direccion_horizontal < 0
	velocity.x = direccion_horizontal * velocidad_dash
	dashing = true
	
	dash_1.play()

	_disable_all_attacks()
	shape_embestida.disabled = false

	sprite.play("movimiento")
	await get_tree().create_timer(0.4).timeout

	dashing = false
	velocity.x = 0
	sprite.play("idle")
	_disable_all_attacks()
	esta_atacando = false
	await get_tree().create_timer(1.2).timeout 

func dash_ida_vuelta() -> void:
	if objetivo == null or not is_instance_valid(objetivo):
		esta_atacando = false
		return

	esta_atacando = true
	sprite.play("inicio_movimiento")
	hissing.play()
	await sprite.animation_finished

	if objetivo != null and is_instance_valid(objetivo):
		direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	else:
		if randf() < 0.5:
			direccion_horizontal = -1
		else:
			direccion_horizontal = 1


	sprite.flip_h = direccion_horizontal < 0
	_disable_all_attacks()
	shape_embestida.disabled = false

	velocity.x = direccion_horizontal * velocidad_dash * 1.3
	dashing = true
	dash_1.play()
	sprite.play("moving")
	await get_tree().create_timer(0.35).timeout

	direccion_horizontal *= -1
	sprite.flip_h = direccion_horizontal < 0
	velocity.x = direccion_horizontal * velocidad_dash * 1.3
	dash_2.play()
	await get_tree().create_timer(0.35).timeout

	dashing = false
	velocity = Vector2.ZERO
	_disable_all_attacks()
	sprite.play("idle")
	esta_atacando = false
	await get_tree().create_timer(1.2).timeout 

func teleport_y_ataque() -> void:
	if esta_teletransportando:
		return

	esta_teletransportando = true
	esta_atacando = true

	sprite.play("divear")
	await sprite.animation_finished

	if objetivo == null or not is_instance_valid(objetivo):
		_reset_estado_post_teleport()
		return

	# Teletransporte
	var offset := 96
	var lado: int = sign(global_position.x - objetivo.global_position.x)
	if lado == 0:
		lado = 1
	var destino := objetivo.global_position + Vector2(offset * lado, 0)
	destino.x = clamp(destino.x, limites_arena.position.x, limites_arena.position.x + limites_arena.size.x)
	destino.y = clamp(destino.y, limites_arena.position.y, limites_arena.position.y + limites_arena.size.y)
	global_position = destino

	direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	sprite.flip_h = direccion_horizontal < 0

	await get_tree().create_timer(0.4).timeout

	sprite.play("aparicion")

	# Animación de humo/efecto de salida
	salida.visible = true
	salida.play("idle")
	emerging.play()
	
	ataque_aparicion.monitoring = true
	await sprite.animation_finished  # Activación exacta al acabar la animación

	
	await get_tree().create_timer(0.2).timeout
	ataque_aparicion.monitoring = false

	salida.stop()
	salida.visible = false


	_reset_estado_post_teleport()


func receive_damage(cantidad: int) -> void:
	if esta_teletransportando or sprite.animation == "divear" or sprite.animation == "aparicion":
		return

	# Prevenir daño si ya está en ataque
	if esta_atacando:
		return

	vida_actual -= cantidad
	if vida_actual <= 0:
		await muerte()
		return

	# ⚠️ Solo después de confirmar que no ha muerto
	actualizar_fase()
	_disable_all_attacks()
	esta_atacando = false

	sprite.stop()
	sprite.play("daño")
	await sprite.animation_finished

	if sprite.animation != "idle":
		sprite.play("idle")


func actualizar_fase() -> void:
	var p: float = float(vida_actual) / float(vida_maxima)

	if p <= 0.33 and fase < 3:
		fase = 3
		timer_ataque.wait_time = 3.5
	elif p <= 0.66 and fase < 2:
		fase = 2
		timer_ataque.wait_time = 4.0
	print("Nueva fase:", fase)


func muerte() -> void:
	timer_ataque.stop()
	velocity = Vector2.ZERO
	sprite.play("muerte")
	await sprite.animation_finished
	queue_free()

func _on_area_embestida_body_entered(body: Node) -> void:
	if dashing and body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(daño_embestida)
		if body.has_method("apply_knockback"):
			var dir:float = sign(body.global_position.x - global_position.x)
			body.apply_knockback(dir * fuerza_knockback)

func _on_ataque_aparicion_body_entered(body: Node) -> void:
	if fase == 3 and body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(daño_aparicion)

func _on_area_recibir_daño_area_entered(area: Area2D) -> void:
	if area.has_method("attack"):
		receive_damage(area.attack())
	else:
		receive_damage(10)

func _disable_all_attacks() -> void:
	shape_embestida.set_deferred("disabled", true)
	shape_ataque_izq.set_deferred("disabled", true)
	shape_ataque_der.set_deferred("disabled", true)
	area_ataque.set_deferred("monitoring", false)


func _on_salida_animation_finished() -> void:
	salida.visible = false
func _reset_estado_post_teleport() -> void:
	if sprite.animation != "idle":
		sprite.play("idle")
	esta_atacando = false
	esta_teletransportando = false

func _esperar_animacion_o_timeout(anim: AnimatedSprite2D, max_tiempo: float) -> bool:
	var tiempo := 0.0
	while tiempo < max_tiempo:
		await get_tree().process_frame
		tiempo += get_process_delta_time()
		if not anim.is_playing():
			return true
	return false
