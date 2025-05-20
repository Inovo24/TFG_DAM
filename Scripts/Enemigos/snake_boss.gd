extends Bosses
# Script para el jefe serpiente con 3 fases de combate

# Constantes para identificar las fases (opcionalmente usar enum para legibilidad)
enum Phase { FASE1 = 1, FASE2 = 2, FASE3 = 3 }

# Propiedades del jefe
var current_phase: int = Phase.FASE1
var max_health: int = 100  # Vida máxima (ejemplo)
var health: int = max_health  # Vida actual del jefe
var speed: float = 100.0  # Velocidad base de movimiento
var direction: int = 1    # Dirección horizontal (1 derecha, -1 izquierda)

# Referencias a nodos hijos importantes (usamos onready para obtenerlos en _ready)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var phase_timer: Timer = $attack_timer

func _ready() -> void:
	# Configuración inicial del jefe
	sprite.play("idle")  # Comienza en animación idle
	current_phase = Phase.FASE1
	# Conectar señales de colisión y temporizador
	hitbox.body_entered.connect(_on_Hitbox_body_entered)  # Detectar cuerpos que entren (ej. balas o jugador)
	phase_timer.timeout.connect(_on_Timer_timeout)       # Temporizador para manejar ataques/fase
	phase_timer.wait_time = 2.0  # Intervalo inicial de ataque (ejemplo 2s)
	phase_timer.start()  # Iniciar el temporizador (repetitivo por defecto)

func _process(delta: float) -> void:
	# Comportamiento continuo frame a frame según la fase actual
	match current_phase:
		Phase.FASE1:
			_phase1_behavior(delta)
		Phase.FASE2:
			_phase2_behavior(delta)
		Phase.FASE3:
			_phase3_behavior(delta)

func _phase1_behavior(delta: float) -> void:
	# Fase 1: Movimiento básico y ataque sencillo
	# Ejemplo: mover de lado a lado lentamente y atacar esporádicamente (controlado por temporizador)
	sprite.play("movimiento")
	position.x += direction * (speed * 0.5) * delta  # en fase1 mueve al 50% de velocidad base
	_check_screen_bounds()  # cambia de dirección si llega a los límites horizontales

func _phase2_behavior(delta: float) -> void:
	# Fase 2: Movimiento más rápido/agresivo y ataques más frecuentes o múltiples
	sprite.play("movimiento")
	position.x += direction * (speed * 0.8) * delta  # fase2 un 80% de velocidad
	_check_screen_bounds()
	# Podría añadirse ligero movimiento vertical u otra pauta de movimiento si se desea

func _phase3_behavior(delta: float) -> void:
	# Fase 3: Fase final - el jefe usa 'divear' y 'aparicion' en lugar de patrullar continuamente
	# En esta fase, el movimiento normal puede reducirse o detenerse, enfocándose en teletransportarse y atacar
	# Si no está realizando dive/aparicion, podría mantenerse quieto o apuntando al jugador
	if not _is_diving:
		# Ejemplo: el jefe podría apuntar hacia el jugador (no movemos mucho en esta fase)
		sprite.play("idle")

# Bandera para saber si está en medio de desaparecer/aparecer
var _is_diving: bool = false

func _on_Timer_timeout() -> void:
	# Esta función se llama cada vez que el Timer llega a cero (timeout)
	if current_phase < Phase.FASE3:
		# En fase 1 y 2, el temporizador controla ataques regulares
		_execute_attack()
	else:
		# En fase 3, el temporizador controla el dive/aparición
		if not _is_diving:
			_start_dive_sequence()
		# Si ya estaba diveando, no hacemos nada aquí; la secuencia de dive controla su propio flujo

func _execute_attack() -> void:
	# Lógica de ataque general según la fase
	sprite.play("ataque")  # reproducir animación de ataque
	if current_phase == Phase.FASE1:
		# Ataque sencillo: p.ej., disparar un proyectil recto
		_shoot_projectile(1)
	elif current_phase == Phase.FASE2:
		# Ataque mejorado: p.ej., disparar varios proyectiles en abanico
		_shoot_projectile(3)
	elif current_phase == Phase.FASE3:
		# En fase3, los ataques podrían ser manejados tras aparecer (ver _finish_dive_sequence)
		_shoot_projectile(5)
	# *Nota:* _shoot_projectile sería una función que instancia balas (Node2D/Area2D) y las añade a la escena.
	# Aquí asumimos su existencia para ilustrar.

func _start_dive_sequence() -> void:
	# Inicia la secuencia de desaparición (divear)
	_is_diving = true
	sprite.play("divear")    # reproducir animación de desaparecer
	hitbox.disabled = true   # desactivar colisiones mientras está desaparecido
	# Una vez termine la animación de divear, continuaremos en _finish_dive_sequence.
	sprite.animation_finished.connect(_finish_dive_sequence)  # conectar señal para saber cuándo terminar dive

func _finish_dive_sequence() -> void:
	# Esta función se llama cuando la animación 'divear' termina
	sprite.animation_finished.disconnect(_finish_dive_sequence)  # desconectar para evitar llamadas múltiples
	# Teletransportar/reubicar al jefe en otra posición (por ejemplo, aleatoria en la pantalla)
	_teleport_to_new_position()
	# Reaparecer con animación de aparición
	sprite.play("aparicion")
	# Conectar para saber cuándo termina la animación de aparición, y entonces reactivar colisiones y ataques
	sprite.animation_finished.connect(_on_appear_finished)

func _on_appear_finished() -> void:
	# Al finalizar la animación 'aparicion'
	sprite.animation_finished.disconnect(_on_appear_finished)
	hitbox.disabled = false    # reactivar colisiones (el jefe puede ser dañado de nuevo)
	_is_diving = false
	# Realizar un ataque inmediato tras aparecer, por ejemplo
	_execute_attack()
	# Opcional: ajustar temporizador para próximo dive, p.ej. incrementar velocidad de dive o frecuencia
	phase_timer.wait_time = 3.0  # reducir tiempo entre dives si se quiere intensificar

func _teleport_to_new_position() -> void:
	# Posicionar al jefe en un nuevo lugar de la arena tras desaparecer.
	# Esto puede ser aleatorio dentro de ciertos límites o en puntos fijos predefinidos.
	var arena_rect = get_viewport_rect()  # como ejemplo, usar el tamaño de la vista
	# Elegir una nueva posición aleatoria lejos del jugador para reaparecer
	var new_x = randf_range(0.1, 0.9) * arena_rect.size.x
	var new_y = randf_range(0.2, 0.8) * arena_rect.size.y
	position = Vector2(new_x, new_y)

func _on_Hitbox_body_entered(body: Node) -> void:
	# Cuando algo entra en la hitbox del jefe (por ejemplo, un proyectil del jugador o el propio jugador)
	# Determinar si es un ataque del jugador
	if body.is_in_group("player_attack") or body.name == "Player":
		# Aplicar daño al jefe
		_take_damage(body.damage if typeof(body.damage) == TYPE_FLOAT or TYPE_INT else 10)
		# Opcional: si es el jugador mismo, también podríamos dañarlo o empujarlo, etc.

func _take_damage(amount: float) -> void:
	if health <= 0:
		return  # si ya está muerto o muriendo, ignorar
	health -= amount
	if health < 0:
		health = 0
	# Reproducir animación de daño y quizás un destello
	sprite.play("daño")
	# Actualizar barra de vida del HUD a través del sistema del juego
	# Comprobar cambio de fase por porcentaje de vida
	var health_ratio = float(health) / float(max_health)
	if current_phase == Phase.FASE1 and health_ratio <= 0.66:
		_enter_phase(Phase.FASE2)
	elif current_phase == Phase.FASE2 and health_ratio <= 0.33:
		_enter_phase(Phase.FASE3)
	# Si la vida llega a 0, iniciar secuencia de muerte
	if health == 0:
		_die()

func _enter_phase(new_phase: int) -> void:
	current_phase = new_phase
	match current_phase:
		Phase.FASE2:
			# Cambios al entrar fase 2: p.ej., acelerar temporizador de ataque, cambiar patrón
			phase_timer.wait_time = 1.5  # ataques más frecuentes
			sprite.play("idle")  # podría haber una animación/transición
		Phase.FASE3:
			# Cambios al entrar fase 3 (fase final)
			phase_timer.wait_time = 2.5  # ajustar frecuencia de dive
			sprite.play("idle")
			# Quizá algún efecto visual o sonido indicando enraged/fase final
	# Sincronizar HUD si hubiera indicadores de fase (p.ej., cambiar color de barra de vida)

func _die() -> void:
	# Secuencia de muerte del jefe
	phase_timer.stop()      # detener cualquier temporizador de ataque
	hitbox.disabled = true  # ya no colisiona
	sprite.play("muerte")   # reproducir animación de muerte
	# Opcional: desconectar señales, reproducir sonido de muerte, etc.
	# Cuando termine la animación de muerte, remover al jefe del escenario
	sprite.animation_finished.connect(_on_death_animation_finished)

func _on_death_animation_finished() -> void:
	sprite.animation_finished.disconnect(_on_death_animation_finished)
	# Notificar al sistema de juego que el jefe ha sido derrotado (puede ser vía señal, por ejemplo)
	emit_signal("boss_defeated", self)
	queue_free()  # eliminar nodo del jefe
	# La barra de vida del HUD puede ocultarse vía la lógica del HUD o base class Bosses

func _check_screen_bounds() -> void:
	# Comprueba si el jefe alcanza los bordes de la pantalla (u otros límites) para invertir dirección
	var arena_rect = get_viewport_rect()
	if position.x < 0 or position.x > arena_rect.size.x:
		direction *= -1
		# Reproducir animación de voltear si se requiere, o simplemente espejar sprite:
		sprite.flip_h = (direction < 0)
func _shoot_projectile(count: int):
	print("Disparando", count, "proyectiles (placeholder)")
