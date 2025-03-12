extends CharacterBody2D

const VEL_NOR = 70
const VEL_RUN = 220
var velocidad = VEL_NOR
var direccion = -1
const gravedad = 98
const daño = 20
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
