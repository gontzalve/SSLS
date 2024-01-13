extends Node2D

signal level_ring_appeared
signal level_created
signal letter_dead(assigned_char: String, is_correct: bool)
signal level_completed

@export var word_levels: Resource

var current_level_word: String
var remaining_letters: String
var remaining_letters_count: int
var current_level_duration: float


func _ready() -> void:
	$LevelGenerator.level_ring_appeared.connect(_on_level_ring_appeared)
	$LevelGenerator.level_created.connect(_on_level_created)


func create_word_level(index: int) -> void:
	var level_word: String = word_levels.get_level_word(index)
	if level_word == "-":
		return
	current_level_word = level_word
	remaining_letters = level_word
	remaining_letters_count = level_word.length()
	current_level_duration = word_levels.get_level_duration(index)
	$LevelGenerator.clear_level()
	$LevelGenerator.create_level(level_word)


func get_current_level_word() -> String:
	return current_level_word


func get_current_level_duration() -> float:
	return current_level_duration


func clear_level() -> void:
	$LevelGenerator.clear_level()


func _on_level_ring_appeared() -> void:
	level_ring_appeared.emit()


func _on_level_created() -> void:
	level_created.emit()


func on_letter_dead(assigned_char: String) -> void:
	var letter_index: int = remaining_letters.find(assigned_char)
	if letter_index >= 0:
		remaining_letters[letter_index] = "*"
		remaining_letters_count -= 1
	letter_dead.emit(assigned_char, letter_index)
	if remaining_letters_count == 0:
		level_completed.emit()