extends Node2D


@onready var narration_text = $Camera2D/Label 
@onready var narration_timer = $Camera2D/Timer
var waiting_for_input:bool  = false
# Datos de narración
var narration_data = [
	[tr("lbl_cine1"),3],[tr("lbl_cine2"), 3.0],
	[tr("lbl_cine3"),3],[tr("lbl_cine4"), 3.0],
	[tr("lbl_cine5"),2.5],[tr("lbl_cine6"), 2.5],
	[tr("lbl_cine7"),3],[tr("lbl_cine8"), 6.0],
	[tr("lbl_cine9"),2.5],[tr("lbl_cine10"), 2.5],
	[tr("lbl_cine11"),2.5],[tr("lbl_cine12"), 2.5],
	[tr("lbl_cine13"),4.0],
	[tr("lbl_cine14"),2.5],[tr("lbl_cine15"), 2.5],
	[tr("lbl_cine16"),3],[tr("lbl_cine17"), 6.0],
	[tr("lbl_cine18"),2.5],[tr("lbl_cine19"), 2.5],
	[tr("lbl_cine20"),3.0],
	[tr("lbl_cine21"),2.5],[tr("lbl_cine22"), 2.5],
	[tr("lbl_cine23"),2.5],[tr("lbl_cine24"), 2.5],
	[tr("lbl_cine25"),4.0],
	[tr("lbl_cine26"),2.5],[tr("lbl_cine27"), 2.5],
	[tr("lbl_cine28"),3.0],
	[tr("lbl_cine29"),2.5],[tr("lbl_cine30"), 2.5],
	[tr("lbl_cine31"),3.0],
	[tr("lbl_cine32"),4.0],
	[tr("lbl_cine33"),2.5],[tr("lbl_cine34"), 2.5],
];
var current_index = 0

func _ready():
	print("=== INICIANDO CINEMÁTICA ===")
	
	# Verificar nodos críticos
	if not narration_text:
		print("ERROR: Texto no encontrado. Estructura actual:")
		#print_node_structure()
		return
	
	if not narration_timer:
		print("ERROR: Timer no encontrado")
		return
	
	print("✓ Nodos encontrados")
	
	# Configurar texto
	setup_text_display()
	
	# Configurar timer
	narration_timer.one_shot = true
	narration_timer.timeout.connect(_on_timer_timeout)
	
	print("✓ Configuración completa")
	
	# Empezar con delay pequeño
	await get_tree().create_timer(0.5).timeout
	show_current_segment()

func setup_text_display():
	#narration_text.label_settings = preload("res://Scenes/UI/UI_laber_settings/inicioTexts.tres")
	# Configuración básica que funciona tanto para Label como RichTextLabel
	narration_text.text = ""
	narration_text.show()

	# Si es Label normal, configurar autowrap
	if narration_text is Label:
		narration_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func show_current_segment():
	if current_index >= narration_data.size():
		end_narration()
		return
	
	var segment = narration_data[current_index]
	var text = segment[0]
	var duration = segment[1]
	
	print("Segmento %d/%d: %s" % [current_index + 1, narration_data.size(), text])
	
	# Mostrar texto simple y claro
	if narration_text is RichTextLabel:
		# Usar BBCode básico para centrar y dar formato
		narration_text.text = "[center]%s[/center]" % text
	else:
		# Para Label normal
		narration_text.text = text
		narration_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Iniciar timer para este segmento
	narration_timer.wait_time = duration
	narration_timer.start()
	
	current_index += 1

func _on_timer_timeout():
	print("→ Siguiente segmento")
	show_current_segment()

func end_narration():
	print("=== NARRACIÓN TERMINADA ===")
	narration_text.text = tr("user_prompt_1")
	
	waiting_for_input = true
	# Enable input processing for this script
	set_process_input(true)

# This function is automatically called by Godot when an input event occurs
func _input(event):
	if waiting_for_input:
		if event is InputEventKey or event is InputEventMouseButton:
			# Any key or mouse button press will trigger this
			waiting_for_input = false # Stop waiting for input
			set_process_input(false) # Disable input processing for this script
			get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
