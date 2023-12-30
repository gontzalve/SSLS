extends Node2D

@export var letter_scene: PackedScene
@export var alphabet_data: Resource
@export var word_levels: Resource

var letters: Array[Node2D]

const LETTER_COUNT: int = 360
const LETTER_REPETITIONS: int = 4


func _ready() -> void:
	pass
	_initialize_grid()
	load_word_level(0)


func load_word_level(index: int) -> void:
	_clear_level()
	var level_word: String = word_levels.get_level_word(index)
	if level_word == "-":
		return
	_spawn_letter_nodes()
	_initialize_letter_nodes(level_word)


func _clear_level() -> void:
	_clear_letters_array()
	

func get_center_cell_pos() -> Vector2:
	return $LevelGrid.get_center_cell_world_pos()


func _initialize_grid() -> void:
	$LevelGrid.initialize()


func _clear_letters_array() -> void:
	for letter_node in letters:
		letter_node.queue_free()
	letters.clear()


func _spawn_letter_nodes() -> void:
	for i in range(LETTER_COUNT):
		var letter_node: Node = letter_scene.instantiate()
		letters.append(letter_node)
		$LetterContainer.add_child(letter_node)


func _initialize_letter_nodes(level_word: String) -> void:
	_initialize_letter_positions()
	_initialize_letter_characters(level_word)
	_initialize_letter_colors()


func _initialize_letter_positions() -> void:
	for letter in letters:
		var cell_pos: Vector2i = $LevelGrid.get_random_free_cell()
		var cell_world_pos: Vector2 = $LevelGrid.get_random_position_inside_cell(cell_pos)
		letter.set_initial_pos(cell_world_pos)
		$LevelGrid.set_cell_as_occupied(cell_pos)
	

func _initialize_letter_characters(level_word: String) -> void:
	var word_size = level_word.length()
	var level_characters_count = word_size * LETTER_REPETITIONS
	for i in range(level_characters_count):
#		print("%s in pos %d" % [level_word[i % word_size], i])
		letters[i].set_letter_type(level_word[i % word_size])
	for i in range(letters.size() - level_characters_count):
		var random_char: String = alphabet_data.get_random_character(level_word)
#		print("%s in pos %d" % [random_char, i])
		letters[i + level_characters_count].set_letter_type(random_char)

	
func _initialize_letter_colors() -> void:
	for letter in letters:
		letter.set_initial_color()
	
