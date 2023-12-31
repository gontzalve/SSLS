extends Node2D

@export var letter_scene: PackedScene
@export var alphabet_data: Resource
@export var word_levels: Resource

var letters: Array[Node2D]
var origin_position: Vector2
var letter_node_slot_radius: float
var current_spawn_circle_radius: float

const LETTER_COUNT: int = 360
const LETTER_REPETITIONS: int = 4

const LETTER_NODE_RADIUS: float = 54.0
const LETTER_NODE_RADIUS_PADDING: float = 8.0 
const SPAWN_CIRCLE_INITIAL_RADIUS: float = 150.0
const SPAWN_CIRCLE_RADIUS_INCREASE_STEP: float = 150.0


func _ready() -> void:
	origin_position = Vector2.ZERO
	letter_node_slot_radius = LETTER_NODE_RADIUS + LETTER_NODE_RADIUS_PADDING
	load_word_level(0)


func load_word_level(index: int) -> void:
	_clear_level()
	var level_word: String = word_levels.get_level_word(index)
	if level_word == "-":
		return
	_execute_spawn_sequence()


func _execute_spawn_sequence() -> void:
	var spawned_letters: int = 0
	current_spawn_circle_radius = SPAWN_CIRCLE_INITIAL_RADIUS
	while spawned_letters < LETTER_COUNT:
		print("Spawned Letters: " , spawned_letters, " / Spawn Radius: ", current_spawn_circle_radius)
		var letter_slot_angle: float = _calculate_letter_slot_angle(current_spawn_circle_radius)
		var letter_slot_count: int = floori(360.0 / letter_slot_angle)
		letter_slot_count = min(letter_slot_count, LETTER_COUNT - spawned_letters)
		print("Slot Angle: " , letter_slot_angle)
		print("Letter slots: " , letter_slot_count)
		for i in range(letter_slot_count):
			var spawn_angle: float = (letter_slot_angle / 2) + i * letter_slot_angle
			var spawn_pos: Vector2 = _calculate_letter_spawn_position(spawn_angle, current_spawn_circle_radius)
			_spawn_letter(spawn_pos)
			await get_tree().create_timer(0.02).timeout
			spawned_letters += 1
		current_spawn_circle_radius += SPAWN_CIRCLE_RADIUS_INCREASE_STEP
		print("-------------------------------")
	# _initialize_letter_nodes(level_word)
	

func _calculate_letter_slot_angle(spawn_radius: float) -> float:
	var slot_angle: float = 4 * asin(letter_node_slot_radius / (2 * spawn_radius))
	return rad_to_deg(slot_angle)


func _calculate_letter_spawn_position(angle: float, radius: float) -> Vector2:
	var rad_angle: float = deg_to_rad(angle)
	return Vector2(radius * cos(rad_angle), radius * sin(rad_angle))


func _spawn_letter(spawn_pos: Vector2) -> void:
	var letter_node: Node = letter_scene.instantiate()
	letter_node.position = spawn_pos
	letters.append(letter_node)
	$LetterContainer.add_child(letter_node)
	pass


func _clear_level() -> void:
	for letter_node in letters:
		letter_node.queue_free()
	letters.clear()



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
	
