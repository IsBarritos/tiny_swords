extends AudioStreamPlayer2D

var sfx_para_tocar: String

func _ready() -> void:
	stream = load(sfx_para_tocar)
	play()

func quando_o_tempo_acabar() -> void:
	queue_free()
