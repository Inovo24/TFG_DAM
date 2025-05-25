extends CanvasLayer

@export var label_text:String = "lbl_frase_loki_odin"

func _ready() -> void:
	$Label.text = label_text
