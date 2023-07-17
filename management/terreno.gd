extends Node2D

const LAYER_DEFAULT: int = 0
const FOAM: PackedScene = preload("res://management/foam.tscn")

@onready var grama: TileMap = $Grama
@onready var agua: TileMap = $Agua

var celulas_de_grama_usada: Array
var celula_de_agua_usada: Array

func _ready() -> void:
	var grama_usada_rect: Rect2 = grama.get_used_rect()
	celulas_de_grama_usada = grama.get_used_cells(LAYER_DEFAULT)
	gerar_tiles_de_agua(grama_usada_rect) 
	gerar_foam()

func gerar_tiles_de_agua(rect_usado: Rect2) -> void:
	for x in range(rect_usado.position.x - 10, rect_usado.size.x + 10):
		for y in range(rect_usado.position.y - 10, rect_usado.size.y + 10):
			if celulas_de_grama_usada.has(Vector2i(x, y)):
				continue

			agua.set_cell(LAYER_DEFAULT, Vector2i(x, y), LAYER_DEFAULT, Vector2i(0, 0))

	celula_de_agua_usada = agua.get_used_cells(LAYER_DEFAULT)

func gerar_foam() -> void:
	for celula in celulas_de_grama_usada:
		if checar_vizinhos_da_grama(celula):
			chamar_foam(celula)

func checar_vizinhos_da_grama(celula: Vector2i):
	var vizinho_direita: Vector2i = Vector2i(celula.x + 1, celula.y)
	var vizinho_esquerda: Vector2i = Vector2i(celula.x - 1, celula.y)
	var vizinho_cima: Vector2i = Vector2i(celula.x, celula.y - 1)
	var vizinho_baixo: Vector2i = Vector2i(celula.x, celula.y + 1)

	var lista_de_vizinhos: Array = [vizinho_esquerda, vizinho_direita, vizinho_cima, vizinho_baixo]

	for vizinho in lista_de_vizinhos:
		if celula_de_agua_usada.has(vizinho):
			return true

	return false

func chamar_foam(foam_celula: Vector2) -> void:
	var foam = FOAM.instantiate()
	add_child(foam)
	foam.position = (foam_celula * 64.0) + Vector2(32, 32)
