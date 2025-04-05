extends Personajes

class_name Vikingo

var enemigos: Array = []

func _ready() -> void:
	super._ready()
	#print(vida_maxima)
	daño = 30

func atacar():
	if combo_count ==0:
		anim_state_machine.travel("ataque1")
		
		combo_count +=1
		combo_timer.start()
		_aplicar_daño_a_enemigos()
	elif combo_count ==1 and combo_timer.time_left > 0:
		print("combo 2")
		anim_state_machine.travel("ataque2")
		combo_count +=1
		combo_timer.start()
		_aplicar_daño_a_enemigos()
	elif combo_count==2 and combo_timer.time_left > 0:
		print("combo 3")
		anim_state_machine.travel("ataque3")
		combo_count=0
		_aplicar_daño_a_enemigos()
	else :
		combo_count=0 


func _aplicar_daño_a_enemigos():
	
	print("aaaaaaaaaaaaaaaaaaaaaaaa")
	for enemigo in enemigos:
		enemigo.recibir_daño(daño)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("aaaaa")
	if body is Enemigos and not enemigos.has(body):
		enemigos.append(body)
		print(enemigos)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if enemigos.has(body):
		enemigos.erase(body)
