extends CharacterBody2D
class_name SnakeBoss

@export var velocidad_base: float = 100.0
@export var velocidad_dash: float = 600.0
@export var fuerza_knockback: float = 30.0
@export var dano_normal: int = 10
@export var dano_embestida: int = 20
@export var dano_aparicion: int = 15
@export var vida_maxima: int = 300
@export var gravedad: float = 800.0
@export var limites_arena: Rect2 = Rect2(Vector2(0, 0), Vector2(1024, 768))

@onready var dash_1: AudioStreamPlayer2D = $Dash1
@onready var dash_2: AudioStreamPlayer2D = $Dash2
@onready var emerging: AudioStreamPlayer2D = $Emerging
@onready var hissing: AudioStreamPlayer2D = $Hissing
@onready var bite: AudioStreamPlayer2D = $Bite
@onready var player = Globales.get_player()
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_detec: Area2D = $detection_player
@onready var shape_embestida: CollisionShape2D = $area_embestida/CollisionShape2D
@onready var area_ataque: Area2D = $ataque_normal
@onready var shape_ataque_izq: CollisionShape2D = $ataque_normal/izquierda
@onready var shape_ataque_der: CollisionShape2D = $ataque_normal/derecha
@onready var ataque_aparicion: Area2D = $Ataque_aparicion
@onready var area_recibir_dano: Area2D = $area_recibir_daño
@onready var timer_ataque: Timer = $attack_timer
@onready var salida: AnimatedSprite2D = $salida
@onready var sprite_dano_efecto: AnimatedSprite2D = $SpriteDañoSuperpuesto

var vida_actual: int = vida_maxima
var fase: int = 1
var esta_teletransportando: bool = false
var dashing: bool = false
var direccion_horizontal: int = 1
var objetivo: Node2D = null
var esta_atacando: bool = false
var proximo_ataque_normal: bool = true
var primera_aparicion := true

func _ready():
	player.has_checkpoint = true
	player.checkpoint_position = player.global_position

	_disable_all_attacks()
	sprite.play("aparicion")
	sprite_dano_efecto.visible = false
	salida.visible = false

	if not area_recibir_dano.is_connected("area_entered", Callable(self, "_on_area_recibir_dano_area_entered")):
		area_recibir_dano.connect("area_entered", Callable(self, "_on_area_recibir_dano_area_entered"))

	await sprite.animation_finished
	sprite.play("idle")
	# DEBUG temporal
	if ataque_aparicion.monitoring:
		print("⚠️ ATAQUE_APARICION MONITORING ACTIVO")

func _physics_process(delta: float) -> void:
	if vida_actual <= 0:
		return

	velocity.y += gravedad * delta

	if not esta_atacando and not dashing:
		velocity.x = velocidad_base * direccion_horizontal
	elif not dashing:
		velocity.x = 0

	move_and_slide()

	if is_on_wall():
		direccion_horizontal *= -1
		sprite.flip_h = direccion_horizontal < 0

	global_position.x = clamp(global_position.x, limites_arena.position.x, limites_arena.end.x)
	global_position.y = clamp(global_position.y, limites_arena.position.y, limites_arena.end.y)
	sprite.flip_h = direccion_horizontal < 0

func _on_detection_player_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		objetivo = body
		timer_ataque.stop()
		timer_ataque.wait_time = 2.0
		timer_ataque.start()

func _on_detection_player_body_exited(body: Node) -> void:
	if body == objetivo:
		objetivo = null

func _on_attack_timer_timeout() -> void:
	if esta_atacando or objetivo == null or not is_instance_valid(objetivo): return

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

func ataque_normal() -> void:
	esta_atacando = true

	if is_instance_valid(objetivo):
		direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	sprite.flip_h = direccion_horizontal < 0

	# Reproducir animación y sonido desde el inicio
	sprite.play("ataque")
	bite.play()
	await get_tree().create_timer(0.2).timeout
	# Ahora sí: activamos hitbox según dirección
	area_ataque.monitoring = true
	shape_ataque_izq.disabled = direccion_horizontal >= 0
	shape_ataque_der.disabled = direccion_horizontal < 0

	# Desactivar el hitbox tras un tiempo breve
	await get_tree().create_timer(0.18).timeout
	_disable_all_attacks()

	# Esperar a que acabe la animación
	await sprite.animation_finished
	sprite.play("idle")
	esta_atacando = false

	await get_tree().create_timer(1.0).timeout



func dash_basico() -> void:
	esta_atacando = true
	sprite.play("inicio_movimiento")
	hissing.play()
	await sprite.animation_finished

	if not is_instance_valid(objetivo):
		sprite.play("idle")
		esta_atacando = false
		return

	direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	sprite.flip_h = direccion_horizontal < 0

	dashing = true
	_disable_all_attacks()
	shape_embestida.set_deferred("disabled", false)

	velocity.x = direccion_horizontal * velocidad_dash
	dash_1.play()
	sprite.play("movimiento")

	await get_tree().create_timer(0.3).timeout

	dashing = false
	velocity.x = 0
	sprite.play("idle")
	_disable_all_attacks()
	esta_atacando = false
	await get_tree().create_timer(1.2).timeout

func dash_ida_vuelta() -> void:
	if not is_instance_valid(objetivo):
		esta_atacando = false
		return
	esta_atacando = true
	sprite.play("inicio_movimiento")
	hissing.play()
	await sprite.animation_finished
	direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	sprite.flip_h = direccion_horizontal < 0
	_disable_all_attacks()
	shape_embestida.set_deferred("disabled", false)
	velocity.x = direccion_horizontal * velocidad_dash * 1.3
	dashing = true
	dash_1.play()
	sprite.play("movimiento")
	await get_tree().create_timer(0.25).timeout
	direccion_horizontal *= -1
	sprite.flip_h = direccion_horizontal < 0
	velocity.x = direccion_horizontal * velocidad_dash * 1.3
	dash_2.play()
	await get_tree().create_timer(0.25).timeout
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

	_disable_all_attacks()
	sprite.stop()
	sprite.play("divear")
	await sprite.animation_finished

	if not is_instance_valid(objetivo):
		_reset_estado_post_teleport()
		return

	# Posición de destino
	var offset := 96
	var lado = sign(global_position.x - objetivo.global_position.x)
	if lado == 0:
		lado = 1

	var destino := objetivo.global_position + Vector2(offset * lado, 0)
	destino.x = clamp(destino.x, limites_arena.position.x, limites_arena.end.x)
	destino.y = clamp(destino.y, limites_arena.position.y, limites_arena.end.y)
	global_position = destino

	direccion_horizontal = sign(objetivo.global_position.x - global_position.x)
	sprite.flip_h = direccion_horizontal < 0

	await get_tree().create_timer(0.2).timeout

	# Inicio de aparición y ataque breve
	sprite.play("aparicion")
	salida.visible = true
	salida.play()
	emerging.play()

	# Activamos el ataque y lo desactivamos tras 0.3s
	ataque_aparicion.monitoring = true
	await get_tree().create_timer(0.4).timeout
	ataque_aparicion.monitoring = false

	# Esperamos a que termine animación o timeout breve
	await _esperar_animacion_o_timeout(sprite, 0.7)

	if sprite.animation == "aparicion":
		sprite.play("idle")

	salida.stop()
	salida.visible = false
	primera_aparicion = false
	_reset_estado_post_teleport()


func receive_damage(cantidad: int) -> void:
	if vida_actual <= 0:
		return

	if sprite.animation in ["divear", "aparicion"] and primera_aparicion:
		return

	vida_actual -= cantidad

	if vida_actual <= 0:
		await muerte()
		return

	actualizar_fase()

	if esta_atacando or dashing or sprite.animation in ["divear", "aparicion"]:
		await mostrar_animacion_suspensiva()
	else:
		_disable_all_attacks()
		esta_atacando = false
		sprite.stop()
		sprite.play("daño")
		await sprite.animation_finished
		if sprite.animation != "idle":
			sprite.play("idle")

func actualizar_fase() -> void:
	var p := float(vida_actual) / float(vida_maxima)
	if p <= 0.33 and fase < 3:
		fase = 3
		timer_ataque.wait_time = 3.5
	elif p <= 0.66 and fase < 2:
		fase = 2
		timer_ataque.wait_time = 4.0

func muerte() -> void:
	timer_ataque.stop()
	velocity = Vector2.ZERO
	sprite.play("muerte")
	await sprite.animation_finished
	get_parent().end_level()
	queue_free()

func _on_area_embestida_body_entered(body: Node) -> void:
	if dashing and body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(dano_embestida)
		apply_knockback_to_player(body, fuerza_knockback)

func _on_ataque_normal_body_entered(body: Node) -> void:
	if not dashing and body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(dano_normal)
		apply_knockback_to_player(body, fuerza_knockback * 0.6)

func _on_ataque_aparicion_body_entered(body: Node) -> void:
	if fase == 3 and body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(dano_aparicion)
		apply_knockback_to_player(body, fuerza_knockback)

func _on_area_recibir_dano_area_entered(area: Area2D) -> void:
	if area.has_method("attack"):
		receive_damage(area.attack())
	else:
		receive_damage(10)

func _disable_all_attacks() -> void:
	shape_embestida.set_deferred("disabled", true)
	shape_ataque_izq.set_deferred("disabled", true)
	shape_ataque_der.set_deferred("disabled", true)
	area_ataque.set_deferred("monitoring", false)
	ataque_aparicion.set_deferred("monitoring", false)

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

func apply_knockback_to_player(body: Node, fuerza: float) -> void:
	if not is_instance_valid(body): return
	var dir = (body.global_position - global_position).normalized()
	var destino = body.global_position + Vector2(dir.x * fuerza * 0.25, -abs(fuerza * 0.1))
	var query := PhysicsRayQueryParameters2D.create(body.global_position, destino)
	query.exclude = [body]
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if result:
		destino = result.position
	var tween := create_tween()
	tween.tween_property(body, "global_position", destino, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func mostrar_animacion_suspensiva() -> void:
	sprite_dano_efecto.visible = true
	sprite_dano_efecto.flip_h = sprite.flip_h
	sprite_dano_efecto.frame = 0
	sprite_dano_efecto.play("daño")
	await sprite_dano_efecto.animation_finished
	sprite_dano_efecto.visible = false

func change_player(playerNum: int):
	if Globales.current_character != playerNum or playerNum == 1:
		var player = Globales.get_player()
		var playerPosition = player.global_position
		var player_checkpoint = player.checkpoint_position
		Globales.current_character = playerNum
		Globales.player_instance = null
		var playerInstanciate = Globales.get_player()
		get_parent().add_child(playerInstanciate)
		player.queue_free()
		player = playerInstanciate
		player.global_position = playerPosition
		player.has_checkpoint = true
		player.checkpoint_position = player_checkpoint

		if playerNum != 1 and get_parent().has_method("reload_health_bar"):
			get_parent().reload_health_bar()
