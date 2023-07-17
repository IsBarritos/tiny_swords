extends CanvasLayer

@onready var animação: AnimationPlayer = get_node("Animação")

var patio_da_cena: String
var pode_fechar: bool = false
var vida_do_jogador: int = 0 
var pontuação_do_jogador: int = 0

func fade_in(opt: bool = false) -> void:
	if opt == true:
		animação.play("especial_fade_in")
		return
	
	animação.play("fade_in")

func quando_animação_acabar(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		
		if pode_fechar:
			get_tree().quit()
			return
			
		get_tree().change_scene_to_file(patio_da_cena)
		animação.play("fade_out")
		
	if anim_name == "especial_fade_in":
		get_tree().change_scene_to_file(patio_da_cena)
		animação.play("fade_out")
