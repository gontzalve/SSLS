extends Node2D

signal level_created
signal level_ring_appeared

@export var letter_scene: PackedScene
@export var alphabet_data: Resource
@export var letter_container: Node2D

var letter_node_rings = []
var origin_position: Vector2
var letter_node_slot_radius: float
var current_spawn_circle_radius: float

const LETTER_COUNT: int = 180
const LETTER_REPETITIONS: int = 4

const LETTER_NODE_RADIUS: float = 54.0
const LETTER_NODE_RADIUS_PADDING: float = 8.0 
const SPAWN_CIRCLE_INITIAL_RADIUS: float = 150.0
const SPAWN_CIRCLE_RADIUS_INCREASE_STEP: float = 120.0

const LETTER_APPEAR_INITIAL_DELAY: float = 0.4


func _ready() -> void:
	origin_position = Vector2.ZERO
	letter_node_slot_radius = LETTER_NODE_RADIUS + LETTER_NODE_RADIUS_PADDING


func clear_level() -> void:
	for letter_ring in letter_node_rings:
		for i in range(letter_ring.size() - 1, -1, -1): 
			letter_ring[i].queue_free()
	letter_node_rings.clear()


func create_level(level_word: String) -> void:
	_spawn_letter_nodes()
	_initialize_letter_nodes(level_word)
	_execute_letter_nodes_appear_sequence()


func _spawn_letter_nodes() -> void:
	var spawned_letters: int = 0
	current_spawn_circle_radius = SPAWN_CIRCLE_INITIAL_RADIUS
	while spawned_letters < LETTER_COUNT:
		# print("Spawned Letters: " , spawned_letters, " / Spawn Radius: ", current_spawn_circle_radius)
		var letter_slot_angle: float = _calculate_letter_slot_angle(current_spawn_circle_radius)
		var letter_slot_count: int = floori(360.0 / letter_slot_angle)
		letter_slot_angle = 360.0 / letter_slot_count
		if letter_slot_count > LETTER_COUNT - spawned_letters:
			return
		# print("Slot Angle: " , letter_slot_angle)
		# print("Letter slots: " , letter_slot_count)
		var letter_node_ring: Array[Node] = []
		for i in range(letter_slot_count):
			var spawn_angle: float = (letter_slot_angle / 2) + i * letter_slot_angle
			var spawn_pos: Vector2 = _calculate_letter_spawn_position(spawn_angle, current_spawn_circle_radius)
			var letter_node: Node = _spawn_letter(spawn_pos)
			letter_node_ring.append(letter_node)
			spawned_letters += 1
		letter_node_rings.append(letter_node_ring)
		current_spawn_circle_radius += SPAWN_CIRCLE_RADIUS_INCREASE_STEP
		print("spawned: ", spawned_letters)
		# print("-------------------------------")
	

func _calculate_letter_slot_angle(spawn_radius: float) -> float:
	var slot_angle: float = 4 * asin(letter_node_slot_radius / (2 * spawn_radius))
	return rad_to_deg(slot_angle)


func _calculate_letter_spawn_position(angle: float, radius: float) -> Vector2:
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
	for i in range(level_characters_count):
		var random_ring: int = randi_range(0, letter_node_rings.size() - 1)
		var random_slot: int = randi_range(0, letter_node_rings[random_ring].size() - 1)
		letter_node_rings[random_ring][random_slot].set_letter_type(level_word[i % word_size])
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
	var appeared_letter_count: int = 0
	for i in range(letter_node_rings.size()):
		for j in range(letter_node_rings[i].size()):
			letter_node_rings[i][j].appear()
			var delay: float = _calculate_letter_appear_delay(appeared_letter_count)
			delay = maxf(delay, 0.01)
			await get_tree().create_timer(delay).timeout
			appeared_letter_count += 1
		if i < letter_node_rings.size() - 1:
			level_ring_appeared.emit()
	await get_tree().create_timer(0.5).timeout
	level_created.emit()


func _calculate_letter_appear_delay(letter_index: int) -> float:
	var delay: float = LETTER_APPEAR_INITIAL_DELAY
	delay -= LETTER_APPEAR_INITIAL_DELAY * _ease_out_expo(letter_index / 36.0)
	return delay


func _ease_out_expo(x: float) -> float:
	if x >= 1:
		return 1
	return 1 - pow(2, -10 * x)
