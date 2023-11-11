extends Resource

@export var words: Array[String]


func get_level_word(level_index: int) -> String:
	return words[level_index]
