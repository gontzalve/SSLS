extends Resource

@export var characters: Array[String]


func get_random_character() -> String:
	return characters.pick_random().to_lower()
