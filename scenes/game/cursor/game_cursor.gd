extends Node2D

@export var cursor_big: Texture2D
@export var cursor_small: Texture2D


func _ready() -> void:
	set_big_cursor()


func set_big_cursor() -> void:
	if cursor_big == null:
		return
	Input.set_custom_mouse_cursor(cursor_big)


func set_small_cursor() -> void:
	if cursor_small == null:
		return
	Input.set_custom_mouse_cursor(cursor_small)
