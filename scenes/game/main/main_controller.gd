extends Node2D


func _ready() -> void:
	%Player.position = %Level.get_center_cell_pos()
	%GameCamera.on_zoomed_in.connect(_on_game_camera_zoomed_in)
	%GameCamera.on_zoomed_out.connect(_on_game_camera_zoomed_out)


func _process(_delta: float) -> void:
	pass


func _on_game_camera_zoomed_in() -> void:
	%GameCursor.set_big_cursor()
	pass


func _on_game_camera_zoomed_out() -> void:
	%GameCursor.set_small_cursor()
	pass
