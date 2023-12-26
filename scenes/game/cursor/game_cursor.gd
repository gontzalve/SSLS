extends Node2D

@export var cursor_big: Texture2D
@export var cursor_small: Texture2D


func _ready() -> void:
	set_big_cursor()


func show_cursor() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

func hide_cursor() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func set_big_cursor() -> void:
	if cursor_big == null:
		return
	Input.set_custom_mouse_cursor(cursor_big, Input.CURSOR_ARROW, cursor_big.get_size() / 2)


func set_small_cursor() -> void:
	if cursor_small == null:
		return
	Input.set_custom_mouse_cursor(cursor_small, Input.CURSOR_ARROW, cursor_small.get_size() / 2)
