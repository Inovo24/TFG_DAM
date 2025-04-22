extends Enemigos

const VEL_NOR = 70
const VEL_RUN = 220
var velocidad = VEL_NOR
var direccion = -1
const gravedad = 98
var vida = 100

var giro = false
var can_atack = true
var player_in_distance = false # El jugador está en el área en la que el lobo ataca?
var en_retroceso := false
var tiempo_retroceso := 0.1  # Duración del retroceso en segundos
var puede_girar_por_trasero := true

@onready var animationTree = $AnimationTree
@onready var timer_atack = $SpriteLobo/Atack/TimerAtack
@onready var giro_timer = $GiroTimer

@onready var rayDelantero = $SpriteLobo/Node2D/RayoDelante
@onready var rayTrasero = $SpriteLobo/Node2D/RayoDetras

func _ready() -> void:
	velocity.x = -velocidad
	animationTree.active = true
	
	daño = 20
	vida_maxima = 70
	super._ready()

func _physics_process(_delta: float) -> void:
	if rayDelantero.is_colliding() and rayDelantero.get_collider().is_in_group("player"):
		velocidad = VEL_RUN
	elif rayTrasero.is_colliding() and puede_girar_por_trasero:
		iniciar_giro_retrasado()
	else:
		velocidad = VEL_NOR
		if is_on_wall():
			if $SpriteLobo.scale.x == 1:
				direccion = 1
			else:
				direccion = -1
			giro = true
	
	velocity.y += gravedad

	if not en_retroceso:
		velocity.x = velocidad * direccion

	if giro:
		girar_lobo()
		giro = false

	move_and_slide()

	if can_atack and player_in_distance:
		atacar()

func _on_atack_body_entered(body: Personajes) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_distance = true

func _on_atack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_distance = false

func girar_lobo():
	if velocity.x < 0:
		$SpriteLobo.scale.x = 1
	elif velocity.x > 0:
		$SpriteLobo.scale.x = -1

func atacar():
	can_atack = false
	timer_atack.start()
	player.recibirDaño(daño)

	# Retroceso hacia atrás al atacar
	en_retroceso = true
	velocity.x = -direccion * 100  # Ajusta la fuerza del retroceso si quieres
	await get_tree().create_timer(tiempo_retroceso).timeout
	en_retroceso = false
	
	_retroceso(retro_make_damage)

func _on_timer_atack_timeout() -> void:
	can_atack = true

func _on_giro_timer_timeout() -> void:
	direccion = -1 * direccion
	giro = true

func iniciar_giro_retrasado() -> void:
	puede_girar_por_trasero = false
	await get_tree().create_timer(0.5).timeout  # Espera antes de girar
	direccion *= -1
	giro = true
	await get_tree().create_timer(2.0).timeout  # Cooldown para volver a girar
	puede_girar_por_trasero = true
'''
#Opcion sin retroceso (Por si acaso)
extends Enemigos

const VEL_NOR = 70
const VEL_RUN = 220
var velocidad = VEL_NOR
var direccion = -1
const gravedad = 98
var vida = 100
var player
var giro = false
var can_atack = true
var player_in_distance = false #El jugador esta en el area en la que el lobo ataca?
@onready var animationTree = $AnimationTree
@onready var timer_atack = $SpriteLobo/Atack/TimerAtack

@onready var rayDelantero = $SpriteLobo/Node2D/RayoDelante
@onready var rayTrasero = $SpriteLobo/Node2D/RayoDetras


func _ready() -> void:
	velocity.x = -velocidad
	animationTree.active = true
	
	daño = 20
	vida_maxima = 70
	super._ready()

func _physics_process(_delta: float) -> void:
	
	if rayDelantero.is_colliding() && rayDelantero.get_collider().is_in_group("player"):
		velocidad = VEL_RUN
	elif rayTrasero.is_colliding() && rayTrasero.get_collider().is_in_group("player"):
		velocidad = VEL_RUN
		direccion = direccion*-1;
		giro= true
	else:
		velocidad = VEL_NOR
		if is_on_wall():
			if $SpriteLobo.scale.x == 1:
				direccion = 1
			else:
				direccion = -1
			
			giro= true
	
	velocity.y += gravedad
	
	velocity.x = velocidad * direccion
	if(giro):
		girar_lobo()
		giro= false
	
	move_and_slide()
	
	if can_atack && player_in_distance:
		atacar()

func _on_atack_body_entered(body: Personajes) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_distance = true

func _on_atack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_distance = false

func girar_lobo():
		if velocity.x < 0:
			$SpriteLobo.scale.x = 1
		elif velocity.x > 0:
			$SpriteLobo.scale.x = -1

func atacar():
	can_atack = false
	timer_atack.start()
	player.recibirDaño(daño)

func _on_timer_atack_timeout() -> void:
	can_atack = true

'''
