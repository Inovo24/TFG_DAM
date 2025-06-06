extends Levels

@onready var camara_level1 = $Camera2D
@onready var posicion_level1 = $Camera2D/Marker2D
@onready var music_player: AudioStreamPlayer2D = $MusicPlayer

#Nivel1 

func _ready():	
	music_player.play()
	camera = camara_level1
	initialPosition = posicion_level1
	has_boss = true
	level_name = "nivel1"
	super._ready()
