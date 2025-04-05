extends Personajes

class_name Vikingo

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
	var area = $Sprite2D/Area2D
	print("aaaaaaaaaaaaaaaaaaaaaaaa")
	for cuerpo in area.get_overlapping_bodies():
		print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
		if cuerpo is Enemigos:
			cuerpo.recibir_daño(daño)
			
