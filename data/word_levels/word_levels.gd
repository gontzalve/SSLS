extends Resource

@export var words: Array[String]


func get_level_word(level_index: int) -> String:
	if level_index >= words.size():
		return "-"
	return words[level_index]
