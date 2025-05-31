extends Node2D

var playerNum:int

@onready var vikingo = $vikingo
@onready var arquero = $arquero
@onready var valkiria = $valkiria

var player_in_area_vikingo = false
var player_in_area_arquero = false
var player_in_area_valkiria = false

func _process(delta):
	if Globales.current_character ==0:
		vikingo.visible = false
		valkiria.visible = true
		valkiria.play("default")
		arquero.visible = true
		arquero.play("default")
	elif Globales.current_character ==1:
		valkiria.visible = false
		vikingo.visible = true
		vikingo.play("default")
		arquero.visible = true
		arquero.play("default")
	elif Globales.current_character ==2:
		arquero.visible = false
		vikingo.visible = true
		vikingo.play("default")
		valkiria.visible = true
		valkiria.play("default")
	
	
	# Cambiar personaje si el jugador está en el área y pulsa aceptar
	if player_in_area_vikingo and Input.is_action_just_pressed("aceptar_entrar"):
		_cambiar_personaje(0)
	if player_in_area_arquero and Input.is_action_just_pressed("aceptar_entrar"):
		_cambiar_personaje(2)
	if player_in_area_valkiria and Input.is_action_just_pressed("aceptar_entrar"):
		_cambiar_personaje(1)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_area_vikingo = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_area_vikingo = false

func _on_area_arq_body_entered(body):
	if body.is_in_group("player"):
		player_in_area_arquero = true

func _on_area_arq_body_exited(body):
	if body.is_in_group("player"):
		player_in_area_arquero = false

func _on_area_val_body_entered(body):
	if body.is_in_group("player"):
		player_in_area_valkiria = true

func _on_area_val_body_exited(body):
	if body.is_in_group("player"):
		player_in_area_valkiria = false

func _cambiar_personaje(num):
	if Globales.current_character != num:
		print("Cambiando a personaje:", num)
		var playerPosition = Globales.get_player().global_position
		Globales.current_character = num
		Globales.player_instance = null

		var playerInstancate = Globales.get_player()
		var grandparent = get_parent().get_parent()
		grandparent.add_child(playerInstancate)
		grandparent.player.queue_free()
		grandparent.player = playerInstancate
		grandparent.player.global_position = playerPosition
		grandparent.player.set_checkpoint_position()
		if grandparent.has_method("reload_health_bar"):
			grandparent.reload_health_bar()
		#get_parent().update_bar()
		#print(get_parent().get_parent().get_node("healthBar").update_bar())
