extends CanvasLayer

var character
@onready var progresLiveBar = $TextureProgressBar
#@onready var live = $LabelLive
@onready var shield_lives = $Shield_lives

#var live_img = preload("res://Sprites/sprites_para_borradores/cora.png")

var shield_imgs = [
	preload("res://Sprites/healt/1intento.png"),
	preload("res://Sprites/healt/2intentos.png"),
	preload("res://Sprites/healt/3intentos.png")
]

#Para el tiempo en los bosses
@onready var default = 0

func _ready():
	
	character = Globales.get_player()
	progresLiveBar.max_value = character.getMaxHealth()
	update_bar()
	

func _process(_delta: float) -> void:
	update_bar()
	if character:
		#$Lives/TextureRect.texture = live_img if character.life_count >= 1 else null
		#$Lives/TextureRect2.texture = live_img if character.life_count >= 2 else null
		#$Lives/TextureRect3.texture = live_img if character.life_count >= 3 else null
		if character.life_count ==1:
			shield_lives.texture = shield_imgs[0]
		elif character.life_count == 2:
			shield_lives.texture = shield_imgs[1]
		else:
			shield_lives.texture = shield_imgs[2]

func update_bar():
	if character:
		progresLiveBar.value = character.getCurrentHealth()
		#live.text = str(progresLiveBar.value) + "/" + str(progresLiveBar.max_value)
		var vidas = clamp(character.life_count, 0, 2)
		shield_lives.texture = shield_imgs[vidas]

func update_player():
	character = Globales.get_player()
	progresLiveBar.max_value = character.getMaxHealth()
	update_bar()

func updateTimeLabel(segundos: int):
	var total = segundos + default
	var minutos = total / 60
	var segundos_restantes = total % 60
	$LabelTime.text = "%02d:%02d" % [minutos, segundos_restantes]
