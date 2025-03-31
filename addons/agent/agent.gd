@tool
extends EditorPlugin


var panel: Panel
var item_list: ItemList
var file_dialog: FileDialog # Declarar file_dialog como variable de clase


func _enter_tree():
	# Crear la interfaz de usuario
	panel = Panel.new()
	panel.size = Vector2i(400, 300)
	
	# Crear el VBoxContainer
	var vbox = VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	panel.add_child(vbox)
	
	item_list = ItemList.new()
	item_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(item_list)
	
	
	# Crear el FileDialog
	file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = PackedStringArray(["*.gd ; Scripts GDScript"])
	file_dialog.connect("file_selected", Callable( self, "_on_file_selected"))
	vbox.add_child(file_dialog)

	# Crear el botón "Seleccionar Script"
	var button = Button.new()
	button.text = "Seleccionar Script"
	button.connect("pressed",Callable( self, "_on_select_file_pressed"))
	vbox.add_child(button)
	
	# Crear el botón "Analizar Código"
	var button1 = Button.new()
	button1.text = "Analizar Código"
	button1.connect("pressed",Callable( self, "_on_analyze_pressed"))
	vbox.add_child(button1)
	
	# Añadir el panel al panel inferior del editor
	add_control_to_bottom_panel(panel, "Mi Agente")

func _exit_tree():
	# Eliminar el panel del panel inferior del editor
	remove_control_from_bottom_panel(panel)
func _on_select_file_pressed():
	# Mostrar el FileDialog
	file_dialog.popup_centered()

func _on_file_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var code = file.get_as_text()
		file.close()
		var problems = analyze_code(code)
		display_results(problems)
	else:
		print("No se pudo abrir el archivo.")
		

func _on_analyze_pressed():
	# Ruta del script a analizar (reemplaza con la ruta de tu script)
	var file_path = "res://tu_script.gd"
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var code = file.get_as_text()
		file.close()
	
		# Analizar el código y obtener los problemas
		var problems = analyze_code(code)
	
		# Mostrar los resultados en la interfaz de usuario
		display_results(problems)
	else:
		print("No se pudo abrir el archivo.")

func analyze_code(code):
	var problems = []
	var lines = code.split("\n")
	var variables = {} # Diccionario para almacenar las variables declaradas
	
	for i in range(lines.size()):
		if lines[i] !=null:
			var line = lines[i].strip()
		
			# Detectar variables declaradas
			var variable_match = line.match("var\\s+(\\w+)")
			if variable_match:
				variables[variable_match[1]] = false # Inicializar como no usada
		
	# Detectar uso de variables
			if variables !=null:
				for variable in variables.keys():
					if line.find(variable) != -1:
						variables[variable] = true # Marcar como usada
			
			# Detectar funciones largas
				if line.match("func\\s+\\w+\\(") :
					var function_lenght = 0
					for j in range (i, lines.size()):
						function_lenght = function_lenght +1
						if lines[j].match("}"):
							if function_lenght > 20:
								problems.append("Función larga en la línea %d" % (i + 1))
							break
	
	# Detectar variables no usadas
	for variable in variables.keys():
		if not variables[variable]:
			problems.append("Variable '%s' no usada" % variable)
		
	return problems

func display_results(problems):
	# Limpiar la lista de resultados
	item_list.clear()
	
	# Mostrar los problemas en la lista
	for problem in problems:
		item_list.add_item(problem)
