extends Resource

@export var characters: Array[String]


func get_random_character(excluded_word: String = "") -> String:
	if excluded_word.is_empty():
		return characters.pick_random().to_lower()
	else:
		excluded_word = excluded_word.to_lower()
		while true:
			var random_char: String = characters.pick_random().to_lower()
			if random_char not in excluded_word:
				return random_char
		return "x"
