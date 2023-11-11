extends Resource

@export var textures: Array[Texture2D]

const START_ASCII_INDEX: int = 97

func get_texture_from_char(letter_char: String) -> Texture2D:
	var lowercase_letter_char: String = _get_lowercase_char(letter_char)
	var char_index: int = _get_char_index(lowercase_letter_char)
	return textures[char_index]
	

func _get_lowercase_char(letter_char: String) -> String:
	if letter_char.length() > 1:
		letter_char = letter_char.substr(0, 1)
	return letter_char.to_lower()
	

func _get_char_index(letter_char: String) -> int:
	var byte_array = letter_char.to_ascii_buffer()
	return byte_array[0] - START_ASCII_INDEX
	
