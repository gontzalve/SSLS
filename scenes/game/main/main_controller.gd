extends Node2D

@export var sfx_correct_letter: AudioStream

var player: Node2D
var game_cursor: Node2D
var game_camera: Node2D
var bullet_factory: Node2D
var level_controller: Node2D
var ui_controller: Node
var game_timer: Timer

var current_level_index: int
var has_level_started: bool

const COUNTDOWN_DURATION: int = 3


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
	await get_tree().create_timer(0.8).timeout
	_show_level_label()


func _show_level_label() -> void:
	ui_controller.show_level_labels()
	ui_controller.show_next_level_animation(current_level_index)


func _on_level_shown() -> void:
	await get_tree().create_timer(1).timeout
	ui_controller.hide_level_labels()
	level_controller.create_word_level(current_level_index, player.global_position)


func _on_level_ring_appeared() -> void:
	game_camera.start_zoom(game_camera.get_current_zoom() - 0.13, 0.3)


func _on_level_created() -> void:
	await get_tree().create_timer(0.5).timeout
	game_camera.start_zoom(1, 0.6)
	await get_tree().create_timer(0.8).timeout
	ui_controller.show_countdown_ui()
	ui_controller.start_countdown(COUNTDOWN_DURATION)


func _on_countdown_ended() -> void:
	_start_current_level()


func _start_current_level() -> void:
	game_cursor.show_cursor()
	player.allow_input()
	player.allow_shooting_input()
	ui_controller.show_level_ui()
	var word: String = level_controller.get_current_level_word()
	var duration: float = level_controller.get_current_level_duration()
	ui_controller.set_level_info(word, duration)
	await get_tree().create_timer(0.2).timeout
	game_timer.start(duration)
	game_timer.paused = false
	has_level_started = true
	

func _on_player_shot_fired(spawn_pos: Vector2, direction: Vector2) -> void:
	game_camera.start_shake()
	bullet_factory.create_bullet(spawn_pos, direction)


func _on_letter_dead(assigned_char: String, letter_index: int) -> void:
	if letter_index >= 0:
		AudioController.play_sfx(sfx_correct_letter, 1.2)
		ui_controller.resolve_letter(letter_index)


func _on_level_completed() -> void:
	game_timer.paused = true
	await get_tree().create_timer(1).timeout
	level_controller.clear_level()


func _on_level_cleared() -> void:
	current_level_index += 1
	player.disallow_shooting_input()
	ui_controller.hide_ui()
	await get_tree().create_timer(0.4).timeout
	_show_level_label()


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
	level_controller.letter_dead.connect(_on_letter_dead)
	level_controller.level_completed.connect(_on_level_completed)
	level_controller.level_cleared.connect(_on_level_cleared)
	ui_controller.level_shown.connect(_on_level_shown)
	ui_controller.countdown_ended.connect(_on_countdown_ended)
	game_timer.timeout.connect(_on_level_timed_out)
