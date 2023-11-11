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
