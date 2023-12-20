extends Resource

@export var colors: PackedColorArray

const BLACK_COLOR_INDEX: int = 0
const WHITE_COLOR_INDEX: int = 1
const LETTER_COLORS_INDEX_RANGE: Vector2i = Vector2i(2, 6)

func _init(p_colors: PackedColorArray = []) -> void:
	colors = p_colors


func get_random_color_for_letter() -> Color:
	var random_index: int = randi_range(LETTER_COLORS_INDEX_RANGE.x, LETTER_COLORS_INDEX_RANGE.y)
	return colors[random_index]


func get_color_array_for_splash_sequence() -> PackedColorArray:
	var splash_colors: PackedColorArray
	splash_colors.append(colors[2])
	splash_colors.append(colors[4])
	splash_colors.append(colors[6])
	splash_colors.append(colors[5])
	splash_colors.append(colors[3])
	return splash_colors
