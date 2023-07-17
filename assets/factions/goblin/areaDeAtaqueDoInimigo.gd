extends Area2D

@export var dano: int = 1

func _physics_process(_delta) -> void:
	pass

func corpo_entrou_na_area_de_ataque(body) -> void:
	body.atualizar_vida(dano)

func fim_do_ataque() -> void:
	queue_free()
