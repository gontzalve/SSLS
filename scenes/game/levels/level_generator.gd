extends Node2D

signal level_created
signal level_ring_appeared
signal level_cleared

@export var letter_scene: PackedScene
@export var alphabet_data: Resource
@export var letter_container: Node2D

var letter_node_rings = []
var origin_position: Vector2
var letter_node_slot_distance: float

const LETTER_NODE_RADIUS: float = 54.0
const LETTER_NODE_RADIUS_PADDING: float = 8.0 

const SPAWN_SQUARE_INITIAL_RING_SIZE: int = 3
const SPAWN_SQUARE_RING_SIZE_INCREASE_STEP: int = 2

const LETTER_RING_APPEAR_DELAY: float = 0.1


func _ready() -> void:
	letter_node_slot_distance =  2 * (LETTER_NODE_RADIUS + LETTER_NODE_RADIUS_PADDING)


func clear_level() -> void:
	for i in range(letter_node_rings.size()):
		for j in range(letter_node_rings[i].size() - 1, -1, -1):
			if is_instance_valid(letter_node_rings[i][j]):
				letter_node_rings[i][j].queue_free()
		AudioController.play_main_sfx(max(1.2 - i * 0.1, 0.8))
		await get_tree().create_timer(0.08).timeout
	letter_node_rings.clear()
	level_cleared.emit()


func create_level(level_data: LevelData, player_position: Vector2) -> void:
	_spawn_letter_nodes(level_data, player_position)
	_initialize_letter_nodes(level_data)
	_execute_letter_nodes_appear_sequence()


func create_tutorial_level(level_word: String) -> void:
	pass


func _spawn_letter_nodes(level_data: LevelData, player_position: Vector2) -> void:
	origin_position = player_position
	_spawn_letter_nodes_in_squares(level_data)


func _spawn_letter_nodes_in_squares(level_data: LevelData) -> void:
	var ring_side_size: int = SPAWN_SQUARE_INITIAL_RING_SIZE
	var letter_count: int = _get_level_count_from_rings(level_data.level_rings)
	var spawned_letters: int = 0
	while spawned_letters < letter_count:
		var letter_count_in_ring = 4 * (ring_side_size - 1)
		var letter_node_ring: Array[Node] = []
		for i in range(letter_count_in_ring):
			var spawn_pos: Vector2 = _calculate_letter_spawn_position_in_square(i, ring_side_size)
			var letter_node: Node = _spawn_letter(spawn_pos)
			letter_node_ring.append(letter_node)
			spawned_letters += 1
		letter_node_rings.append(letter_node_ring)
		ring_side_size += SPAWN_SQUARE_RING_SIZE_INCREASE_STEP


func _calculate_letter_spawn_position_in_square(slot_index: int, ring_side_size) -> Vector2:
	var pos_x: float = origin_position.x
	var pos_y: float = origin_position.y
	var slot_group_index: int = slot_index / (ring_side_size - 1)
	var slot_index_in_group = slot_index % (ring_side_size - 1)
	match slot_group_index:
		0:
			pos_x = pos_x - floori(ring_side_size / 2) * letter_node_slot_distance + slot_index_in_group * letter_node_slot_distance
			pos_y = pos_y - floori(ring_side_size / 2) * letter_node_slot_distance 
		1:
			pos_x = pos_x + floori(ring_side_size / 2) * letter_node_slot_distance 
			pos_y = pos_y - floori(ring_side_size / 2) * letter_node_slot_distance + slot_index_in_group * letter_node_slot_distance
		2:
			pos_x = pos_x + floori(ring_side_size / 2) * letter_node_slot_distance - slot_index_in_group * letter_node_slot_distance
			pos_y = pos_y + floori(ring_side_size / 2) * letter_node_slot_distance 
		3:
			pos_x = pos_x - floori(ring_side_size / 2) * letter_node_slot_distance 
			pos_y = pos_y + floori(ring_side_size / 2) * letter_node_slot_distance - slot_index_in_group * letter_node_slot_distance
	return Vector2(pos_x, pos_y)


func _spawn_letter(spawn_pos: Vector2) -> Node:
	var letter_node: Node = letter_scene.instantiate()
	letter_node.set_initial_pos(spawn_pos)
	letter_node.hide()
	letter_node.dead.connect(Callable(get_parent(), "on_letter_dead"))
	letter_container.add_child(letter_node)
	return letter_node


func _initialize_letter_nodes(level_data: LevelData) -> void:
	_initialize_letter_characters(level_data)
	_initialize_letter_colors()


func _initialize_letter_characters(level_data: LevelData) -> void:
	_assign_level_characters_to_letter_nodes(level_data)
	_assign_non_level_characters_to_letter_nodes(level_data)


func _assign_level_characters_to_letter_nodes(level_data: LevelData) -> void:
	var level_word = level_data.level_word
	var word_size = level_word.length()
	var letter_repetitions: int = level_data.correct_letter_repetitions
	var level_characters_count = word_size * letter_repetitions
	var level_char_index: int = 0
	var available_rings: Array = _get_available_rings_to_assign_level_characters(level_data.level_rings)
	while level_char_index < level_characters_count:
		var random_ring: int = available_rings.pick_random()
		var random_slot: int = randi_range(0, letter_node_rings[random_ring].size() - 1)
		var letter: Node2D = letter_node_rings[random_ring][random_slot]
		if letter.has_letter_assigned():
			continue
		letter.set_letter_type(level_word[level_char_index % word_size])
		available_rings.erase(random_ring)
		if available_rings.is_empty():
			available_rings = _get_available_rings_to_assign_level_characters(level_data.level_rings)
		level_char_index += 1


func _assign_non_level_characters_to_letter_nodes(level_data: LevelData) -> void:
	var level_word = level_data.level_word
	for letter_ring in letter_node_rings:
		for letter in letter_ring:
			if letter.has_letter_assigned():
				continue
			var random_char: String
			random_char = "x" if level_data.is_tutorial else alphabet_data.get_random_character(level_word)
			letter.set_letter_type(random_char)


func _get_available_rings_to_assign_level_characters(level_rings: int) -> Array:
	var minimum_eligible_ring_index: int = 0 if level_rings == 1 else 1
	return range(minimum_eligible_ring_index, level_rings)

	
func _initialize_letter_colors() -> void:
	for letter_ring in letter_node_rings:
		for letter in letter_ring:
			letter.set_initial_color()


func _execute_letter_nodes_appear_sequence() -> void:
	for i in range(letter_node_rings.size()):
		for letter in letter_node_rings[i]:
			letter.appear()
		if i < letter_node_rings.size() - 1:
			level_ring_appeared.emit()
		AudioController.play_main_sfx(1.2 - i * 0.1)
		await get_tree().create_timer(0.08).timeout
	level_created.emit()


func _get_level_count_from_rings(level_rings: int) -> int:
	return 4 * level_rings * (SPAWN_SQUARE_INITIAL_RING_SIZE + level_rings - 2)
