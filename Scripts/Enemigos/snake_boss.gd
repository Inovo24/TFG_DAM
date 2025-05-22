extends CharacterBody2D
class_name SnakeBoss

@export var velocidad: float = 100.0
@export var velocidad_embestida: float = 200.0
@export var daño_embestida: int = 10
@export var daño_aparicion: int = 15
@export var vida_maxima: int = 300
@export var gravedad: float = 800.0
@export var fuerza_knockback: float = 450.0

var vida_actual: int = 300

const FASE_1 = 1
const FASE_2 = 2
const FASE_3 = 3
var fase_actual: int = FASE_1

enum Estado { INACTIVO, MOVIENDO, ATACANDO, BUCEANDO, APARECIENDO, MUERTO }
var estado: Estado = Estado.INACTIVO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_detec: Area2D = $detection_player
@onready var area_ataque: Area2D = $ataque_normal
@onready var colision_derecha: CollisionShape2D = $ataque_normal/derecha
@onready var colision_izquierda: CollisionShape2D = $ataque_normal/izquierda
@onready var ataque_aparicion: Area2D = $Ataque_aparicion
@onready var area_recibir_daño: Area2D = $area_recibir_daño
@onready var spawnpoints: Node2D = $SpawnPoints
@onready var point1: Node2D = $SpawnPoints/Point1
@onready var point2: Node2D = $SpawnPoints/Point2
@onready var point3: Node2D = $SpawnPoints/Point3
@onready var timer_ataque: Timer = $attack_timer

var embestida_timer := 0.0
var embestida_interval := 4.0

var direccion_horizontal: int = 1
var objetivo: Node2D = null

func _ready() -> void:
	vida_actual = vida_maxima

	colision_derecha.disabled = true
	colision_izquierda.disabled = true
	ataque_aparicion.monitoring = false

	area_recibir_daño.add_to_group("enemigos")

	area_detec.body_entered.connect(_on_detection_player_body_entered)
	area_detec.body_exited.connect(_on_detection_player_body_exited)
	area_ataque.body_entered.connect(_on_ataque_normal_body_entered)
	ataque_aparicion.body_entered.connect(_on_ataque_aparicion_body_entered)
	area_recibir_daño.area_entered.connect(_on_area_recibir_daño_area_entered)

	timer_ataque.timeout.connect(_on_attack_timer_timeout)

	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if estado == Estado.MUERTO:
		return

	velocity.y += gravedad * delta

	if estado == Estado.MOVIENDO:
		velocity.x = velocidad * float(direccion_horizontal)
		move_and_slide()
		if is_on_wall():
			direccion_horizontal *= -1
			sprite.flip_h = direccion_horizontal < 0

		if fase_actual == FASE_1:
			embestida_timer += delta
			if embestida_timer >= embestida_interval:
				embestida_timer = 0
				await iniciar_embestida()
	elif estado == Estado.ATACANDO:
		move_and_slide()
		if is_on_wall():
			velocity.x = 0
	else:
		move_and_slide()

func _on_detection_player_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		objetivo = body
		if estado == Estado.INACTIVO:
			await _activar_movimiento_inicial()

func _activar_movimiento_inicial() -> void:
	sprite.play("inicio_movimiento")
	await sprite.animation_finished
	estado = Estado.MOVIENDO
	sprite.play("movimiento")
	sprite.flip_h = direccion_horizontal < 0

func _on_detection_player_body_exited(body: Node) -> void:
	if body == objetivo:
		objetivo = null

func _on_attack_timer_timeout() -> void:
	if fase_actual == FASE_2 and estado == Estado.MOVIENDO:
		await iniciar_embestida()
	elif fase_actual == FASE_3 and estado == Estado.MOVIENDO:
		await iniciar_teleport()

func iniciar_embestida() -> void:
	if estado != Estado.MOVIENDO:
		return

	estado = Estado.ATACANDO

	if objetivo:
		direccion_horizontal = -1 if objetivo.global_position.x < global_position.x else 1
		sprite.flip_h = direccion_horizontal < 0

	colision_derecha.disabled = direccion_horizontal < 0
	colision_izquierda.disabled = direccion_horizontal > 0

	velocity.x = velocidad_embestida * direccion_horizontal
	sprite.play("ataque")
	await sprite.animation_finished

	velocity.x = 0
	colision_derecha.disabled = true
	colision_izquierda.disabled = true

	sprite.play("fin_movimiento")
	await sprite.animation_finished

	sprite.play("idle")
	await get_tree().create_timer(0.5).timeout

	sprite.play("inicio_movimiento")
	await sprite.animation_finished

	estado = Estado.MOVIENDO
	sprite.play("movimiento")

	if fase_actual == FASE_2:
		timer_ataque.start(randf_range(2.0, 4.0))

func iniciar_teleport() -> void:
	estado = Estado.BUCEANDO
	velocity.x = 0
	if sprite.animation != "fin_movimiento":
		sprite.play("fin_movimiento")
		await sprite.animation_finished

	sprite.play("divear")
	await sprite.animation_finished
	_calcular_puntos_reaparicion()
	var posibles = [point1, point2, point3]
	var punto = posibles[randi() % posibles.size()]
	global_position = punto.global_position
	estado = Estado.APARECIENDO
	ataque_aparicion.monitoring = true
	sprite.play("aparicion")
	await sprite.animation_finished
	ataque_aparicion.monitoring = false
	sprite.play("idle")
	await get_tree().create_timer(0.5).timeout
	sprite.play("inicio_movimiento")
	await sprite.animation_finished
	estado = Estado.MOVIENDO
	sprite.play("movimiento")
	timer_ataque.start(randf_range(3.0, 6.0))

func _calcular_puntos_reaparicion() -> void:
	var dist_cerca: float = 150.0
	var dist_lejos: float = 400.0
	var lado_lejano: float = -1.0 if randf() < 0.5 else 1.0
	point1.position = Vector2(-dist_cerca, 0)
	point2.position = Vector2(dist_cerca, 0)
	point3.position = Vector2(lado_lejano * dist_lejos, 0)

func receive_damage(cantidad: int) -> void:
	if estado == Estado.MUERTO:
		return
	vida_actual -= cantidad
	if vida_actual > 0:
		sprite.play("daño")
		await sprite.animation_finished
		if estado == Estado.MOVIENDO:
			sprite.play("movimiento")
		elif estado == Estado.ATACANDO:
			sprite.play("ataque")
		else:
			sprite.play("idle")
	else:
		vida_actual = 0
		estado = Estado.MUERTO
		timer_ataque.stop()
		colision_derecha.disabled = true
		colision_izquierda.disabled = true
		ataque_aparicion.monitoring = false
		area_detec.monitoring = false
		sprite.play("muerte")
		await sprite.animation_finished
		queue_free()
	actualizar_fase()

func actualizar_fase() -> void:
	var porcentaje = float(vida_actual) / float(vida_maxima)
	if fase_actual == FASE_1 and porcentaje <= 0.66:
		fase_actual = FASE_2
		timer_ataque.start(randf_range(2.0, 4.0))
	elif fase_actual == FASE_2 and porcentaje <= 0.33:
		fase_actual = FASE_3
		timer_ataque.stop()
		timer_ataque.start(randf_range(3.0, 5.0))

func _on_ataque_normal_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(daño_embestida)

		if body is CharacterBody2D:
			var dir = sign(body.global_position.x - global_position.x)
			body.velocity.x = dir * fuerza_knockback

func _on_ataque_aparicion_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(daño_aparicion)

func _on_area_recibir_daño_area_entered(area: Area2D) -> void:
	if area.has_method("get_damage"):
		receive_damage(area.get_damage())
	else:
		receive_damage(10)
