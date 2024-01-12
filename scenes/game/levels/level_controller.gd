extends Node2D

signal level_ring_appeared
signal level_created
signal letter_dead(assigned_char: String)

@export var word_levels: Resource

var current_level_word: String
var current_level_duration: float


func _ready() -> void:
	$LevelGenerator.level_ring_appeared.connect(_on_level_ring_appeared)
	$LevelGenerator.level_created.connect(_on_level_created)


func create_word_level(index: int) -> void:
	var level_word: String = word_levels.get_level_word(index)
	if level_word == "-":
		return
	current_level_word = level_word
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
	print(assigned_char)
