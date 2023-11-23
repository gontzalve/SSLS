extends Node2D


func _ready() -> void:
	%Player.position = %Level.get_center_cell_pos()
	%Player.shot_fired.connect(_on_player_shot_fired)
	%GameCamera.zoomed_in.connect(_on_game_camera_zoomed_in)
	%GameCamera.zoomed_out.connect(_on_game_camera_zoomed_out)


func _on_player_shot_fired(spawn_pos: Vector2, direction: Vector2) -> void:
	%BulletFactory.create_bullet(spawn_pos, direction)


func _on_game_camera_zoomed_in() -> void:
	%GameCursor.set_big_cursor()
	pass


func _on_game_camera_zoomed_out() -> void:
	%GameCursor.set_small_cursor()
	pass
