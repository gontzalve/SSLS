extends Node2D

@export var letter_scene: PackedScene
@export var alphabet_data: Resource

var letters: Array[Node2D]

const LETTER_COUNT: int = 120


func _ready() -> void:
	_initialize_grid()
	_spawn_letter_nodes()
	_initialize_letter_nodes()


func _process(_delta: float) -> void:
	pass


func get_center_cell_pos() -> Vector2:
	return $LevelGrid.get_center_cell_world_pos()


func _initialize_grid() -> void:
	$LevelGrid.initialize()


func _spawn_letter_nodes() -> void:
	for i in range(LETTER_COUNT):
		var letter_node: Node = letter_scene.instantiate()
		letters.append(letter_node)
		$LetterContainer.add_child(letter_node)


func _initialize_letter_nodes() -> void:
	for letter in letters:
		var cell_pos: Vector2i = $LevelGrid.get_random_free_cell()
		var cell_world_pos: Vector2 = $LevelGrid.get_random_position_inside_cell(cell_pos)
		letter.initialize(cell_world_pos, alphabet_data.get_random_character())
		$LevelGrid.set_cell_as_occupied(cell_pos)

