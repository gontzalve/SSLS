extends Node2D

@export var letter_scene: PackedScene
@export var alphabet_data: Resource

var letters: Array[Node2D]

const LETTER_COUNT: int = 100
const LETTER_SPAWN_RANGE_X: Vector2 = Vector2(-360, 1500)
const LETTER_SPAWN_RANGE_Y: Vector2 = Vector2(-360, 960)


func _ready() -> void:
	_spawn_letter_nodes()
	_initialize_letter_nodes()


func _process(_delta: float) -> void:
	pass


func _spawn_letter_nodes() -> void:
	for i in range(LETTER_COUNT):
		var letter_node: Node = letter_scene.instantiate()
		letters.append(letter_node)
		$LetterContainer.add_child(letter_node)


func _initialize_letter_nodes() -> void:
	for letter in letters:
		var initial_pos: Vector2 = _calculate_letter_initial_position()
		letter.initialize(initial_pos, alphabet_data.get_random_character())


func _calculate_letter_initial_position() -> Vector2:
	var initial_pos = Vector2.ZERO
	initial_pos.x = randf_range(LETTER_SPAWN_RANGE_X.x, LETTER_SPAWN_RANGE_X.y)
	initial_pos.y = randf_range(LETTER_SPAWN_RANGE_Y.x, LETTER_SPAWN_RANGE_Y.y)
	return initial_pos
