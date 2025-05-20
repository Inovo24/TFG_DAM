extends Control
class_name LevelSelector

@onready var current_level: LevelIcon = $"1"
@export var offset_y: float = -50
@export var offset_x: float = -10

func _ready():
	$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
	
	var salir_tecla = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$TextoSalir.text = tr("gen_salir").replace("{tecla}",salir_tecla)

func _input(event):
	if !$Camera2D/Panel.visible:
		if event.is_action_pressed("mover_izq") and current_level.next_level_left:
			current_level = current_level.next_level_left
			$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
		if event.is_action_pressed("mover_der") and current_level.next_level_right:
			current_level = current_level.next_level_right
			$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
		if event.is_action_pressed("arriba") and current_level.next_level_up:
			current_level = current_level.next_level_up
			$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
		if event.is_action_pressed("abajo") and current_level.next_level_down:
			current_level = current_level.next_level_down
			$PlayerIcon.global_position = current_level.global_position + Vector2(offset_x, offset_y)
		if event.is_action_pressed("aceptar_entrar"):
			$Camera2D/Panel.visible = true
			$Camera2D/Panel/VSplitContainer/HBoxContainer/Nivel.text = tr("lbl_nivel")+" "+current_level.level_name
			var level = Guardado.level_progress["nivel"+current_level.level_name]
			if level["hecho"]:
				$"Camera2D/Panel/VSplitContainer/Sin hacer".visible = false
				$Camera2D/Panel/VSplitContainer/Gemas.visible = true
				$Camera2D/Panel/VSplitContainer/Tiempo.visible = true
				$Camera2D/Panel/VSplitContainer/Jugar.visible = true
				
				var minutos = int(level["time"]) / 60
				var segundos_restantes = int(level["time"]) % 60
				
				$Camera2D/Panel/VSplitContainer/Gemas.text = tr("lbl_maximo_gemas")+": "+str(level["num_gems"])
				$Camera2D/Panel/VSplitContainer/Tiempo.text = tr("lbl_tiempo_minimo")+": "+"%02d:%02d" % [minutos, segundos_restantes]
				$Camera2D/Panel/VSplitContainer/Jugar.text = tr("btn_volver_a_jugar")
			else:
				$"Camera2D/Panel/VSplitContainer/Sin hacer".visible = true
				$Camera2D/Panel/VSplitContainer/Gemas.visible = false
				$Camera2D/Panel/VSplitContainer/Tiempo.visible = false
				if current_level.level_name == "1" or Guardado.level_progress["nivel"+str((int(current_level.level_name)-1))]["hecho"]:
					$Camera2D/Panel/VSplitContainer/Jugar.visible = true
					$Camera2D/Panel/VSplitContainer/Jugar.text = tr("btn_jugar")
				else:
					$Camera2D/Panel/VSplitContainer/Jugar.visible = false
	else:
		if event.is_action_pressed("aceptar_entrar") and $Camera2D/Panel/VSplitContainer/Jugar.visible:
			_on_jugar_pressed()
		

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("salir") and !$Camera2D/Panel.visible:
		get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
	elif Input.is_action_just_pressed("salir") and $Camera2D/Panel.visible:
		$Camera2D/Panel.visible = false


func _on_cerrar_pressed() -> void:
	$Camera2D/Panel.visible = false


func _on_jugar_pressed() -> void:
	if current_level.next_scene_path:
			get_tree().change_scene_to_file(current_level.next_scene_path)
