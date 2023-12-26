extends Node2D


func _ready() -> void:
	_connect_to_signals()
	%GameCursor.hide_cursor()
	await get_tree().create_timer(0.5).timeout
	_start_game()
	

func _connect_to_signals() -> void:
	%Player.appeared.connect(_on_player_appeared)
	%Player.shot_fired.connect(_on_player_shot_fired)
	%GameCamera.zoomed_in.connect(_on_game_camera_zoomed_in)
	%GameCamera.zoomed_out.connect(_on_game_camera_zoomed_out)


func _on_player_appeared() -> void:
	%GameCursor.show_cursor()
	

func _start_game() -> void:
	%Player.appear_at(Vector2.ZERO)


func _on_player_shot_fired(spawn_pos: Vector2, direction: Vector2) -> void:
	%BulletFactory.create_bullet(spawn_pos, direction)


func _on_game_camera_zoomed_in() -> void:
	%GameCursor.set_big_cursor()


func _on_game_camera_zoomed_out() -> void:
	%GameCursor.set_small_cursor()
