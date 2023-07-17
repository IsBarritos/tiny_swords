extends CharacterBody2D

const AUDIO_TEMPLATE: PackedScene = preload("res://management/audio_template.tscn")

@onready var textura_do_cavaleiro: Sprite2D = get_node("Textura")
@onready var animacao: AnimationPlayer = get_node("Animação")
@onready var colisao_de_ataque: CollisionShape2D = get_node("AreaDeAtaque/Colisão")
@onready var animacao_auxiliar: AnimationPlayer = get_node("AnimaçãoAuxiliar")
@onready var terra: GPUParticles2D = get_node("Terra")

@export var velocidade: float = 250
@export var dano: int = 1
@export var vida: int = 10

var pode_atacar: bool = true
var pode_morrer: bool = false

func _ready() -> void:
	if transicao.vida_do_jogador != 0:
		vida = transicao.vida_do_jogador
		return
		
	transicao.vida_do_jogador = vida

func _physics_process(_delta) -> void:
	if !pode_atacar or pode_morrer:
		return

	atualizar_movimento()
	atualizar_animacao()
	detectar_ataque()

func atualizar_movimento() -> void:
	var movimentacao: Vector2 = pegar_direcoes()
	velocity = movimentacao * velocidade
	move_and_slide()

func pegar_direcoes() -> Vector2:
	return Vector2(
	Input.get_axis("mEsquerda", "mDireita"),
	Input.get_axis("mCima", "mBaixo")
	)

func atualizar_animacao() -> void:
	if velocity != Vector2.ZERO:
		textura_do_cavaleiro.flip_h = velocity.x < 0
		animacao.play("andando")
		terra.emitting = true
		
		if velocity.x < 0:
			colisao_de_ataque.position.x = -60.5
		else:
			colisao_de_ataque.position.x = 60.5
	else:
		animacao.play("parado")
		terra.emitting = false

func detectar_ataque() -> void:
	if Input.is_action_just_pressed("BEM") and pode_atacar:
		pode_atacar = false
		animacao.play("ataque")
		terra.emitting = false

func fim_da_animacao(anim_name: String) -> void:
	match anim_name:
		"ataque":
			pode_atacar = true
		"morte":
			transicao.fade_in()
			transicao.vida_do_jogador = 0
			transicao.pontuação_do_jogador = 0

func corpo_entrou_na_area_de_ataque(body) -> void:
	body.atualizar_vida(dano)
	
func atualizar_vida(valor) -> void:
	vida -= valor
	
	transicao.vida_do_jogador = vida
	get_tree().call_group("nivel", "atualizar_vida", vida)
	
	if vida <= 0:
		pode_morrer = true
		animacao.play("morte")
		colisao_de_ataque.set_deferred("disabled", true)
		return
		
	animacao_auxiliar.play("danoTomado")

func chamar_sfx(sfx_patio: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_para_tocar = sfx_patio
	add_child(sfx)
