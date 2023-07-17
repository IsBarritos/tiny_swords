extends Node2D

@onready var interface: CanvasLayer = get_node("Interface")
@onready var vida_label: Label = interface.get_node("Vida")
@onready var pontuação_label : Label = interface.get_node("Pontuação")

@export var pontos_alvo: int
@export var proximo_nivel_patio_da_cena: String 
@export var nivel_atual_patio_da_cena: String

var pontos: int = 0

func _ready() -> void:
	atualizar_vida(transicao.vida_do_jogador)
	atualizar_pontuação(transicao.pontuação_do_jogador)

func atualizar_vida(nova_vida: int) -> void:
	transicao.patio_da_cena = nivel_atual_patio_da_cena
	vida_label.text = "Vida: " + str(nova_vida)
	
func atualizar_pontuação(nova_pontuação: int) -> void:
	pontuação_label.text = "Pontuação: " + str(nova_pontuação)

func aumentar_contagem_de_pontos() -> void:
	pontos += 1
	
	if pontos == pontos_alvo:
		transicao.patio_da_cena = proximo_nivel_patio_da_cena
		transicao.fade_in(true)
