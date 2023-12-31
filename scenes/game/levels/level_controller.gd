extends Node2D

signal level_ring_appeared
signal level_created

@export var word_levels: Resource


func _ready() -> void:
	$LevelGenerator.level_ring_appeared.connect(_on_level_ring_appeared)
	$LevelGenerator.level_created.connect(_on_level_created)


func load_word_level(index: int) -> void:
	var level_word: String = word_levels.get_level_word(index)
	if level_word == "-":
		return
	$LevelGenerator.clear_level()
	$LevelGenerator.create_level(level_word)


func clear_level() -> void:
	$LevelGenerator.clear_level()


func _on_level_ring_appeared() -> void:
	level_ring_appeared.emit()


func _on_level_created() -> void:
	level_created.emit()
