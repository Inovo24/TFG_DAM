extends Personajes

class_name Vikingo


func _ready() -> void:
	super._ready()	
	print(vida_maxima)

func atacar():
	if combo_count ==0:
		anim_state_machine.travel("ataque1")
		combo_count +=1
		combo_timer.start()
	elif combo_count ==1 and combo_timer.time_left > 0:
		print("combo 2")
		anim_state_machine.travel("ataque2")
		combo_count +=1
		combo_timer.start()
	elif combo_count==2 and combo_timer.time_left > 0:
		print("combo 3")
		anim_state_machine.travel("ataque3")
		combo_count=0
	else :
		combo_count=0 
