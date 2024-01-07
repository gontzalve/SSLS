extends Resource

@export var words: Array[String]
@export var durations: Array[float]


func get_level_word(level_index: int) -> String:
	if level_index >= words.size():
		return "-"
	return words[level_index]


func get_level_duration(level_index: int) -> float:
	if level_index >= durations.size():
		return -1
	return durations[level_index]
