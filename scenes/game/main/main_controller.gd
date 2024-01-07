extends Node2D

var player: Node2D
var game_cursor: Node2D
var game_camera: Node2D
var bullet_factory: Node2D
var level_controller: Node2D
var ui_controller: Node
var game_timer: Timer

var current_level_index: int
var has_level_started: bool


func _ready() -> void:
	has_level_started = false
	_get_references()
	_connect_to_signals()
	_setup_scene()
	await get_tree().create_timer(0.5).timeout
	_start_game()


func _process(_delta: float) -> void:
	if not has_level_started:
		return
	ui_controller.update_timer(game_timer.time_left)


func _setup_scene() -> void:
	player.initialize()
	game_cursor.hide_cursor()
	ui_controller.hide_ui()

	
func _start_game() -> void:
	current_level_index = 0
	player.appear_at(Vector2.ZERO)


func _on_player_appeared() -> void:
	await get_tree().create_timer(0.4).timeout
	level_controller.create_word_level(current_level_index)


func _on_level_ring_appeared() -> void:
	game_camera.start_zoom(game_camera.get_current_zoom() - 0.13, 0.3)
	pass


func _on_level_created() -> void:
	await get_tree().create_timer(0.5).timeout
	game_camera.start_zoom(1, 0.6)
	await get_tree().create_timer(1.2).timeout
	_start_current_level()


func _start_current_level() -> void:
	game_cursor.show_cursor()
	player.allow_input()
	ui_controller.show_ui()
	var word: String = level_controller.get_current_level_word()
	var duration: float = level_controller.get_current_level_duration()
	ui_controller.set_level_info(word, duration)
	await get_tree().create_timer(0.2).timeout
	game_timer.start(duration)
	has_level_started = true
	

func _on_player_shot_fired(spawn_pos: Vector2, direction: Vector2) -> void:
	game_camera.start_shake()
	bullet_factory.create_bullet(spawn_pos, direction)


func _on_game_camera_zoomed_in() -> void:
	game_cursor.set_big_cursor()


func _on_game_camera_zoomed_out() -> void:
	game_cursor.set_small_cursor()


func _on_level_timed_out() -> void:
	# game_cursor.hide_cursor()
	player.disallow_input()
	game_timer.stop()
	ui_controller.show_game_over_ui()


func _get_references() -> void:
	player = %Player
	game_cursor = %GameCursor
	game_camera = %GameCamera
	bullet_factory = %BulletFactory
	level_controller = %LevelController
	ui_controller = %UIController
	game_timer = %GameTimer


func _connect_to_signals() -> void:
	player.appeared.connect(_on_player_appeared)
	player.shot_fired.connect(_on_player_shot_fired)
	game_camera.zoomed_in.connect(_on_game_camera_zoomed_in)
	game_camera.zoomed_out.connect(_on_game_camera_zoomed_out)
	level_controller.level_ring_appeared.connect(_on_level_ring_appeared)
	level_controller.level_created.connect(_on_level_created)
	game_timer.timeout.connect(_on_level_timed_out)
