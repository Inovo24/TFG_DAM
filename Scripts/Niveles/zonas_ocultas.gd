extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		#print("holaa")
		var parent = self.get_parent()
		if parent:
			parent.modulate.a = 0.1
			body.secretAreas +=1
			#print("adios")


func _on_body_exited(body):
	if body.is_in_group("player"):
		var parent = self.get_parent()
		if parent:
			body.secretAreas -=1
			if body.secretAreas==0:
				parent.modulate.a = 1
