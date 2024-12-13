extends CanvasLayer


# Referencia al personaje
var personaje

# Referencia a la barra de vida
@onready var barra_vida = $TextureProgressBar

# Inicialización
func _ready():
	barra_vida.max_value = 100  # Valor máximo inicial

# Método para asignar el personaje
func set_personaje(p_instancia):
	personaje = p_instancia
	barra_vida.max_value = personaje.vida
	actualizar_barra()

# Actualiza el valor de la barra de vida
func actualizar_barra():
	if personaje:
		barra_vida.value = personaje.vida
