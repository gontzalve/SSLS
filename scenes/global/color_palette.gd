extends Node

@export var BLACK: Color
@export var WHITE: Color
@export var RED: Color
@export var BLUE: Color
@export var GREEN: Color
@export var YELLOW: Color
@export var PURPLE: Color

var letter_colors: PackedColorArray = []


func _ready() -> void:
	letter_colors.append(RED)
	letter_colors.append(BLUE)
	letter_colors.append(GREEN)
	letter_colors.append(YELLOW)
	letter_colors.append(PURPLE)


func get_random_color_for_letter() -> Color:
	var random_index: int = randi_range(0, letter_colors.size() - 1)
	return letter_colors[random_index]


func get_color_array_for_splash_sequence() -> PackedColorArray:
	var splash_colors: PackedColorArray = []
	splash_colors.append(RED)
	splash_colors.append(GREEN)
	splash_colors.append(PURPLE)
	splash_colors.append(YELLOW)
	splash_colors.append(BLUE)
	return splash_colors