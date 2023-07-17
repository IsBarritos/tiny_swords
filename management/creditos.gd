extends Control

func _ready() -> void:
	for botao in get_tree().get_nodes_in_group("botao"):
		botao.pressed.connect(botao_pressionado.bind(botao.name))
		
func botao_pressionado(nome_botao: String) -> void:
	match nome_botao:
		"VoltarMenu":
			transicao.patio_da_cena = "res://management/menu.tscn"
			transicao.fade_in()
			
		"Fechar":
			transicao.pode_fechar = true
			transicao.fade_in()
