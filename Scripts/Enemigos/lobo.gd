extends CharacterBody2D

var velocidad = 70
const gravedad = 98
const daño = 20
@onready var animationTree = $AnimationTree

func _ready() -> void:
	velocity.x = -velocidad
	animationTree.active = true
	

func _physics_process(delta: float) -> void:
	velocity.y += gravedad
	
	if is_on_wall():
		if $SpriteLobo.scale.x == 1:
			velocity.x = velocidad
		else:
			velocity.x = -velocidad
		
		if velocity.x < 0:
			$SpriteLobo.scale.x = 1
		elif velocity.x > 0:
			$SpriteLobo.scale.x = -1
	
	move_and_slide()

func _on_atack_body_entered(body: Personajes) -> void:
	if body.is_in_group("player"):
		body.recibirDaño(daño)
