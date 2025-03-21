extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $Area2D  # Área de detección general
@onready var attack_area: Area2D = $AttackArea  # Área de ataque

var SPEED = 60
var dir: Vector2 = Vector2.ZERO
var is_chasing: bool = false
var is_attacking: bool = false
var player: Personajes = null  # Ahora el jugador se reconoce como "Personajes"

var daño = 100 # Daño que inflige el enemigo
var attack_timer: Timer  # Temporizador para ataques repetidos

func _ready() -> void:
	# Conectar eventos de detección
	detection_area.body_entered.connect(_on_area_2d_body_entered)
	detection_area.body_exited.connect(_on_area_2d_body_exited)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)

	# Temporizador para hacer daño repetidamente
	attack_timer = Timer.new()
	attack_timer.wait_time = 0.5  # Ataca cada 0.5 segundos
	attack_timer.one_shot = false  # Repite el ataque
	attack_timer.timeout.connect(_realizar_ataque)  # Conecta la función que aplica el daño
	add_child(attack_timer)

func _process(delta: float) -> void:
	move()
	handle_animation()

func handle_animation():
	if is_attacking:
		animated_sprite_2d.play("attack")
	elif velocity.length() > 0:
		animated_sprite_2d.play("flying")

	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false

func move():
	if is_chasing and player != null:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
	else:
		velocity = dir * SPEED

	move_and_slide()

# --- DETECCIÓN DEL JUGADOR ---
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Personajes:
		SPEED *= 2
		player = body
		is_chasing = true
		print("Cuerpo detectado, comenzando persecución")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Personajes:
		SPEED /= 2
		is_chasing = false
		player = null
		print("Cuerpo salió del área, dejando de perseguir")

# --- DETECCIÓN EN ÁREA DE ATAQUE ---
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Personajes:
		SPEED += 10
		is_attacking = true  # Comienza a atacar
		if player:  # Aplica daño inmediato
			player.recibirDaño(daño)  # Aplica el daño de inmediato
			print("Atacando al jugador, vida restante:", player.getVidaActual())
		attack_timer.start()  # Comienza el temporizador para ataques consecutivos
		print("Jugador en área de ataque:", body.name)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Personajes:
		SPEED -= 10
		print("Jugador salió del área de ataque:", body.name)
		is_attacking = false  # Deja de atacar
		attack_timer.stop()  # Detener el temporizador para ataques

# --- Función de ataque repetido ---
func _realizar_ataque():
	if player:
		player.recibirDaño(daño)  # Aplica el daño repetidamente
		print("Atacando al jugador, vida restante:", player.getVidaActual())
