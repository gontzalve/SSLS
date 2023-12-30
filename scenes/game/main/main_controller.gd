extends Node2D

var player: Node2D
var game_cursor: Node2D
var game_camera: Node2D
var bullet_factory: Node2D


func _ready() -> void:
	_get_references()
	_connect_to_signals()
	_setup_scene()
	await get_tree().create_timer(0.5).timeout
	_start_game()


func _setup_scene() -> void:
	player.initialize()
	game_cursor.hide_cursor()

	
func _start_game() -> void:
	player.appear_at(Vector2.ZERO)


func _on_player_appeared() -> void:
	game_cursor.show_cursor()
	

func _on_player_shot_fired(spawn_pos: Vector2, direction: Vector2) -> void:
	game_camera.start_shake()
	bullet_factory.create_bullet(spawn_pos, direction)


func _on_game_camera_zoomed_in() -> void:
	game_cursor.set_big_cursor()


func _on_game_camera_zoomed_out() -> void:
	game_cursor.set_small_cursor()


func _get_references() -> void:
	player = %Player
	game_cursor = %GameCursor
	game_camera = %GameCamera
	bullet_factory = %BulletFactory


func _connect_to_signals() -> void:
	player.appeared.connect(_on_player_appeared)
	player.shot_fired.connect(_on_player_shot_fired)
	game_camera.zoomed_in.connect(_on_game_camera_zoomed_in)
	game_camera.zoomed_out.connect(_on_game_camera_zoomed_out)
