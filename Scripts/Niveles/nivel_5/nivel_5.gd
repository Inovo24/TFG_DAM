extends Levels

@onready var level5_camera = $Camera2D
@onready var level5_position = $Inicio

@onready var puente_node = $puente # Referencia directa a tu StaticBody2D 'puente'
@onready var heimdall = $AnimatedSprite2D

var parts = 0

func _ready() -> void:
	camera = level5_camera
	initialPosition = level5_position
	level_name = "nivel5"
	

	# Asegúrate de que el puente esté invisible y su colisión deshabilitada al inicio
	# Esto es CRUCIAL para que la activación funcione como deseas.
	puente_node.visible = false # Oculta el StaticBody2D y sus hijos
	print(puente_node.visible)
	# Accede al CollisionShape2D hijo del StaticBody2D
	# Asegúrate de que el nombre del CollisionShape2D sea correcto.
	# Si solo tienes un CollisionShape2D hijo, puedes usar get_node("CollisionShape2D")
	# Si lo has nombrado diferente, usa ese nombre.
	var bridge_collision_shape = puente_node.get_node("CollisionShape2D") 
	if bridge_collision_shape: # Comprueba que existe antes de intentar deshabilitarlo
		bridge_collision_shape.disabled = true
		print("existe")
	super._ready()
func reload_health_bar():
	healthBar.queue_free()
	healthBar = healthBarScene.instantiate()
	add_child(healthBar)

func collect_sword():
	parts += 1
	print("Partes recogidas: ", parts) # Mensaje más descriptivo
	if parts == 3:
		print("¡Todas las partes recogidas! Activando puente.")
		activate_bridge() # Llama a la nueva función de activación

func activate_bridge():
	# 1. Hacer visible el StaticBody2D (y, por ende, su Sprite2D hijo)
	puente_node.visible = true 
	
	# 2. Activar la colisión del CollisionShape2D hijo
	# Necesitamos acceder al CollisionShape2D específico
	var bridge_collision_shape = puente_node.get_node("CollisionShape2D") 
	
	if bridge_collision_shape: # Siempre es buena práctica verificar si el nodo existe
		# Usa set_deferred() para evitar el error "Can't change this state while flushing queries"
		bridge_collision_shape.set_deferred("disabled", false)
		print("Colisión del puente activada.")
	else:
		print("ERROR: No se encontró el CollisionShape2D en el puente.")

	# 3. Reproducir animación de Heimdall
	heimdall.play("recuperado")
	print("Heimdall animado.")


func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/niveles/Nivel5/batalla_boss_5.tscn")
