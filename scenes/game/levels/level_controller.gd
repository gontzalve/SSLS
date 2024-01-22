extends Node2D

signal level_ring_appeared
signal level_created
signal letter_dead(assigned_char: String, is_correct: bool)
signal level_completed
signal level_cleared

@export var levels: LevelCollection

var current_level_data: LevelData
var remaining_letters: String
var remaining_letters_count: int
var current_level_duration: float


func _ready() -> void:
	$LevelGenerator.level_ring_appeared.connect(func(): level_ring_appeared.emit())
	$LevelGenerator.level_created.connect(func(): level_created.emit())
	$LevelGenerator.level_cleared.connect(func(): level_cleared.emit())


func create_word_level(index: int, player_position: Vector2) -> void:
	var level_data: LevelData = levels.get_level(index)
	if level_data == null:
		return
	current_level_data = level_data
	remaining_letters = level_data.level_word
	remaining_letters_count = level_data.level_word.length()
	current_level_duration = level_data.duration
	$LevelGenerator.create_level(level_data, player_position)


func get_current_level_data() -> LevelData:
	return current_level_data


func clear_level() -> void:
	$LevelGenerator.clear_level()


func on_letter_dead(letter_node: Node2D) -> void:
	var assigned_char: String = letter_node.assigned_letter_char
	var letter_index: int = remaining_letters.find(assigned_char)
	if letter_index < 0:
		letter_node.disappear_as_incorrect_letter()
		return
	remaining_letters[letter_index] = "*"
	letter_node.disappear_as_correct_letter()
	letter_dead.emit(assigned_char, letter_index)
	remaining_letters_count -= 1
	if remaining_letters_count == 0:
		level_completed.emit()
