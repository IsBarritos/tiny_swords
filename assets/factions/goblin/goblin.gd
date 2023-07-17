extends CharacterBody2D

const AREA_DE_ATAQUE: PackedScene = preload("res://assets/factions/goblin/area_de_ataque_do_inimigo.tscn")
const OFFSET: Vector2 = Vector2(0, 31)
const AUDIO_TEMPLATE: PackedScene = preload("res://management/audio_template.tscn")

@export var velocidade: float = 200
@export var limite_da_distancia: float = 60
@export var vida: int = 3
@export var pontos: int = 10

@onready var textura: Sprite2D = get_node("Textura")
@onready var animacao: AnimationPlayer = get_node("Animação")
@onready var animacao_auxiliar: AnimationPlayer = get_node("AnimaçãoAuxiliar")
@onready var terra: GPUParticles2D = get_node("Terra")

var pode_atacar: bool = true
var pode_morrer: bool = false
var ref_cavaleiro: CharacterBody2D = null

func _physics_process(_delta) -> void:
	if !pode_atacar or pode_morrer:
		return
	
	if !ref_cavaleiro or ref_cavaleiro.pode_morrer:
		velocity = Vector2.ZERO
		atualizar_animacao()
		return
		
	atualizar_movimento()

func atualizar_movimento() -> void:
	var direcao: Vector2 = global_position.direction_to(ref_cavaleiro.global_position)
	var distancia: float = global_position.distance_to(ref_cavaleiro.global_position)
	
	if distancia < limite_da_distancia:
		pode_atacar = false
		animacao.play("ataque")
		terra.emitting = false
		return
		
	velocity = direcao * velocidade
	move_and_slide()
	atualizar_animacao()
	
func chamar_area_de_ataque() -> void:
	var area_de_ataque = AREA_DE_ATAQUE.instantiate()
	area_de_ataque.position = OFFSET
	add_child(area_de_ataque)
	
func atualizar_animacao() -> void:
	if velocity != Vector2.ZERO:
		textura.flip_h = velocity.x < 0
		animacao.play("andando")
		terra.emitting = true
		return
		
	animacao.play("parado")
	terra.emitting = false

func fim_da_animacao(anim_name: String) -> void:
	match anim_name:
		"ataque":
			pode_atacar = true

		"morte":
			transicao.pontuação_do_jogador += pontos
			get_tree().call_group("nivel", "aumentar_contagem_de_pontos")
			get_tree().call_group("nivel", "atualizar_pontuação", transicao.pontuação_do_jogador)
			queue_free()
 
func atualizar_vida(valor) -> void:
	vida -= valor
	if vida <= 0:
		pode_morrer = true
		animacao.play("morte")
		return
	
	animacao_auxiliar.play("danoTomado")

func area_de_detecção_corpo_entrou(body) -> void:
	ref_cavaleiro = body

func area_de_detecção_corpo_saiu(_body) -> void:
	ref_cavaleiro = null
	
func chamar_sfx(sfx_patio: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_para_tocar = sfx_patio
	add_child(sfx)
