extends Area2D
var player_in_area_exit = false

func _on_body_entered(body: Node2D) -> void:
	$"../TextoSalir".visible = true
	player_in_area_exit = true


func _on_body_exited(body: Node2D) -> void:
	player_in_area_exit = false
	$"../TextoSalir".visible = false

func _process(delta: float) -> void:
	if player_in_area_exit and Input.is_action_just_pressed("arriba"):
		$ConfirmationDialog.popup() 


func _on_confirmation_dialog_confirmed() -> void:
	get_tree().quit()
