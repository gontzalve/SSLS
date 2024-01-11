extends Node2D

signal level_created
signal level_ring_appeared

@export var letter_scene: PackedScene
@export var alphabet_data: Resource
@export var letter_container: Node2D

var letter_node_rings = []
var origin_position: Vector2
var letter_node_slot_distance: float

const LETTER_COUNT: int = 120
const LETTER_REPETITIONS: int = 2

const LETTER_NODE_RADIUS: float = 54.0
const LETTER_NODE_RADIUS_PADDING: float = 8.0 

const SPAWN_CIRCLE_INITIAL_RADIUS: float = 150.0
const SPAWN_CIRCLE_RADIUS_INCREASE_STEP: float = 120.0
const SPAWN_SQUARE_INITIAL_RING_SIZE: int = 3
const SPAWN_SQUARE_RING_SIZE_INCREASE_STEP: int = 2

const LETTER_RING_APPEAR_DELAY: float = 0.1


func _ready() -> void:
	origin_position = Vector2.ZERO
	letter_node_slot_distance =  2 * (LETTER_NODE_RADIUS + LETTER_NODE_RADIUS_PADDING)


func clear_level() -> void:
	for letter_ring in letter_node_rings:
		for i in range(letter_ring.size() - 1, -1, -1): 
			letter_ring[i].queue_free()
	letter_node_rings.clear()


func create_level(level_word: String) -> void:
	_spawn_letter_nodes()
	_initialize_letter_nodes(level_word)
	_execute_letter_nodes_appear_sequence()


func create_tutorial_level(level_word: String) -> void:
	pass


func _spawn_letter_nodes() -> void:
	_spawn_letter_nodes_in_squares()
	# _spawn_letter_nodes_in_circles()


func _spawn_letter_nodes_in_squares() -> void:
	var ring_side_size: int = SPAWN_SQUARE_INITIAL_RING_SIZE
	var spawned_letters: int = 0
	while spawned_letters < LETTER_COUNT:
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


func _spawn_letter_nodes_in_circles() -> void:
	var spawned_letters: int = 0
	var current_spawn_circle_radius = SPAWN_CIRCLE_INITIAL_RADIUS
	while spawned_letters < LETTER_COUNT:
		# print("Spawned Letters: " , spawned_letters, " / Spawn Radius: ", current_spawn_circle_radius)
		var letter_slot_angle: float = _calculate_letter_slot_angle_in_circle(current_spawn_circle_radius)
		var letter_slot_count: int = floori(360.0 / letter_slot_angle)
		letter_slot_angle = 360.0 / letter_slot_count
		if letter_slot_count > LETTER_COUNT - spawned_letters:
			return
		# print("Slot Angle: " , letter_slot_angle)
		# print("Letter slots: " , letter_slot_count)
		var letter_node_ring: Array[Node] = []
		for i in range(letter_slot_count):
			var spawn_angle: float = (letter_slot_angle / 2) + i * letter_slot_angle
			var spawn_pos: Vector2 = _calculate_letter_spawn_position_in_circle(spawn_angle, current_spawn_circle_radius)
			var letter_node: Node = _spawn_letter(spawn_pos)
			letter_node_ring.append(letter_node)
			spawned_letters += 1
		letter_node_rings.append(letter_node_ring)
		current_spawn_circle_radius += SPAWN_CIRCLE_RADIUS_INCREASE_STEP
		print("spawned: ", spawned_letters)
		# print("-------------------------------")
	

func _calculate_letter_slot_angle_in_circle(spawn_radius: float) -> float:
	var letter_node_slot_radius: float = letter_node_slot_distance / 2
	var slot_angle: float = 4 * asin(letter_node_slot_radius / (2 * spawn_radius))
	return rad_to_deg(slot_angle)


func _calculate_letter_spawn_position_in_circle(angle: float, radius: float) -> Vector2:
	var rad_angle: float = deg_to_rad(angle)
	return Vector2(radius * cos(rad_angle), radius * sin(rad_angle))


func _spawn_letter(spawn_pos: Vector2) -> Node:
	var letter_node: Node = letter_scene.instantiate()
	letter_node.set_initial_pos(spawn_pos)
	letter_node.hide()
	letter_container.add_child(letter_node)
	return letter_node


func _initialize_letter_nodes(level_word: String) -> void:
	_initialize_letter_characters(level_word)
	_initialize_letter_colors()


func _initialize_letter_characters(level_word: String) -> void:
	var word_size = level_word.length()
	var level_characters_count = word_size * LETTER_REPETITIONS
	var available_rings: Array = range(1, letter_node_rings.size())
	for i in range(level_characters_count):
		var random_ring: int = available_rings.pick_random()
		var random_slot: int = randi_range(0, letter_node_rings[random_ring].size() - 1)
		letter_node_rings[random_ring][random_slot].set_letter_type(level_word[i % word_size])
		available_rings.erase(random_ring)
		if available_rings.is_empty():
			available_rings = range(1, letter_node_rings.size())
	for letter_ring in letter_node_rings:
		for letter in letter_ring:
			if not letter.has_letter_assigned():
				var random_char: String = alphabet_data.get_random_character(level_word)
				letter.set_letter_type(random_char)

	
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