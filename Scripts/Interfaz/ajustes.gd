extends CanvasLayer

var language_codes = ["es", "en", "pt", "it"]

@onready var key_change_scene = preload("res://Scenes/ajustes/cambio_teclas.tscn")
var key_change_open = false

func _ready() -> void:
	var general_volume = Globales.getGeneralVolume()
	var music_volume = Globales.getMusicVolume()
	var enemy_volume = Globales.getEnemyVolume()
	
	$HSplitContainer/Columna1/ContGeneral/NivelGeneral.text = str(general_volume * 100)
	$HSplitContainer/Columna1/ContMusica/NivelMusica.text = str(music_volume * 100)
	$HSplitContainer/Columna1/ContEnemigos/NivelEnemigos.text = str(enemy_volume * 100)
	
	$HSplitContainer/Columna1/ContGeneral/HSliderGeneral.value = general_volume
	$HSplitContainer/Columna1/ContMusica/HSliderMusic.value = music_volume
	$HSplitContainer/Columna1/ContEnemigos/HSliderEnemigos.value = enemy_volume
	
	set_exit_text()
	
	# Set the selected language
	var default_language = TranslationServer.get_locale()
	var language = language_codes.find(default_language)
	var language_buttons = $HSplitContainer/Columna2/Idiomas
	
	if language != -1:
		language_buttons.selected = language
	else: 
		language_buttons.selected = 1
	
	var default_colorblind_mode = Globales.colorblindness_type
	var colorblind_mode = Globales.TYPE.find_key(default_colorblind_mode)
	var colorblind_buttons = $HSplitContainer/Columna2/Daltonismo
	
	colorblind_buttons.selected = default_colorblind_mode
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir") and !key_change_open:
		_on_back_button_pressed()

func _on_back_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/inicio.tscn")
	if get_parent().has_method("make_container_visible"):
		get_parent().make_container_visible()
	elif get_parent().get_parent().has_node("AreaAjustes"):
		get_parent().get_parent().open_settings = false
	queue_free()

# Sound
func _on_h_slider_general_value_changed(value: float) -> void:
	$HSplitContainer/Columna1/ContGeneral/NivelGeneral.text = str(value * 100)
	Globales.setGeneralVolume(value)

func _on_h_slider_music_value_changed(value: float) -> void:
	$HSplitContainer/Columna1/ContMusica/NivelMusica.text = str(value * 100)
	Globales.setMusicVolume(value)

func _on_h_slider_enemies_value_changed(value: float) -> void:
	$HSplitContainer/Columna1/ContEnemigos/NivelEnemigos.text = str(value * 100)
	Globales.setEnemyVolume(value)


func _on_keys_pressed() -> void:
	key_change_open = true
	add_child(key_change_scene.instantiate())


func _on_option_button_item_selected(index: int) -> void:
	TranslationServer.set_locale(language_codes[index])
	set_exit_text()
	var grandparent = get_parent().get_parent()
	if grandparent.has_method("reset_texts"):
		grandparent.reset_texts()
	if get_parent().has_method("reset_texts"):
		get_parent().reset_texts()

func _on_colorblind_item_selected(index):
	var selected = Globales.TYPE.keys()[index]
	Globales.colorblindness_type = Globales.TYPE[selected]
	#if get_parent().has_method("make_container_visible"):
	get_parent().get_parent().colorblind.Type = Globales.colorblindness_type
	

func set_exit_text():
	# Change exit text
	var exit_key = InputMap.action_get_events("salir")[0].as_text().replace(" (Physical)", "")
	$BotonVolver/TextoSalir.text = tr("gen_salir").replace("{tecla}", exit_key)
