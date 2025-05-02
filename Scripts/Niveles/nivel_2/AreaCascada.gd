extends Area2D

@export var playerCamera: Camera2D
@export var staticCamera: Camera2D
@export var transition_duration: float = 0.5  # Duración de la transición en segundos
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var transition_type: Tween.TransitionType = Tween.TRANS_SINE

var current_tween: Tween

func _ready():
	# Asegurarse de que la cámara del jugador esté activa al inicio
	playerCamera.make_current()
	# Hacemos invisible la cámara estática pero mantenemos su posición
	staticCamera.enabled = false


func _on_body_exited(_body):
	# Cancelar cualquier tween anterior
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	# Crear un nodo de cámara temporal para la transición
	var temp_camera = Camera2D.new()
	add_child(temp_camera)
	
	# Configurar la cámara temporal con las propiedades de la cámara estática
	temp_camera.global_position = staticCamera.global_position
	temp_camera.zoom = staticCamera.zoom
	temp_camera.rotation = staticCamera.rotation
	temp_camera.offset = staticCamera.offset
	# Activar la cámara temporal
	temp_camera.make_current()
	
	# Crear el tween para la transición suave
	current_tween = create_tween()
	current_tween.set_ease(ease_type)
	current_tween.set_trans(transition_type)
	
	# Interpolar la posición, zoom y rotación
	current_tween.tween_property(temp_camera, "global_position", playerCamera.global_position, transition_duration)
	current_tween.parallel().tween_property(temp_camera, "zoom", playerCamera.zoom, transition_duration)
	current_tween.parallel().tween_property(temp_camera, "rotation", playerCamera.rotation, transition_duration)
	current_tween.parallel().tween_property(temp_camera, "offset", playerCamera.offset, transition_duration)
	
	# Al finalizar la transición
	current_tween.finished.connect(func():
		# Activar la cámara del jugador
		playerCamera.make_current()
		# Desactivar la cámara estática para ahorrar recursos
		staticCamera.enabled = false
		# Eliminar la cámara temporal
		temp_camera.queue_free()
	)
