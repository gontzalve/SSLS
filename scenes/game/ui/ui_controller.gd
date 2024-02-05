extends Node2D

signal level_shown
signal countdown_ended
signal restart_completed

@export var letter_ui_scene: PackedScene

var letter_ui_node_array: Array[Node] = []
var current_level_number: int

const LETTERS_PANEL_HORIZONTAL_PADDING: int = 20
const WINDOW_SIZE: Vector2 = Vector2(960, 720)


func hide_ui() -> void:
	$BackUI.visible = false
	$FrontUI.visible = false


func show_level_labels() -> void:
	$BackUI.visible = true
	_hide_timer_labels()
	%LevelLabelContainer.visible = true


func show_next_level_animation(next_level_index: int) -> void:
	%LevelLabelContainer.scale = Vector2.ZERO
	var container_tween: SimpleTween = TweenHelper.create(%LevelLabelContainer)
	container_tween.to_scale_f(1, 0.2).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
	current_level_number = next_level_index + 1
	if next_level_index == 0:
		%LevelNumberLabel.text = "%d" % (current_level_number)
		AudioController.play_main_sfx(0.8)
		await container_tween.finished
		level_shown.emit()
		return
	%LevelNumberLabel.text = "%d" % (current_level_number - 1)
	await get_tree().create_timer(0.6).timeout
	AudioController.play_main_sfx(0.8)
	var tween: SimpleTween = TweenHelper.create(%LevelNumberLabel)
	%LevelNumberLabel.text = "%d" % (current_level_number)
	tween.to_scale_f(1.2, 0.2).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.to_scale_f(1, 0.2).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
	await tween.finished
	level_shown.emit()


func hide_level_labels() -> void:
	%LevelLabelContainer.visible = false


func show_countdown_ui() -> void:
	$BackUI.visible = true
	%CountdownLabel.visible = true
	_hide_timer_labels()
	hide_level_labels()
	%GameOverLabel.visible = false


func show_level_ui(is_tutorial: bool) -> void:
	$BackUI.visible = true
	$FrontUI.visible = true
	if not is_tutorial:
		_show_timer_labels()
	%GameOverLabel.visible = false
	%CountdownLabel.visible = false


func start_countdown(duration_seconds: int) -> void:
	for i in range(duration_seconds + 1):
		_tween_countdown_text()
		if i == duration_seconds:
			%CountdownLabel.text = "Go!"
			AudioController.play_main_sfx(1.5)
		else:
			%CountdownLabel.text = "%d" % (duration_seconds - i)
			AudioController.play_main_sfx(1.2)
		await get_tree().create_timer(0.75).timeout
	%CountdownLabel.visible = false
	countdown_ended.emit()


func _tween_countdown_text() -> void:
	var tween: SimpleTween = TweenHelper.create(%CountdownLabel)
	tween.to_scale_f(1.3, 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.to_scale_f(1, 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)


func set_level_info(word: String, duration: float) -> void:
	update_timer(duration)
	_clear_letter_ui_nodes()
	_create_letter_ui_nodes(word)


func _clear_letter_ui_nodes() -> void:
	var letter_count: int = letter_ui_node_array.size()
	for i in range(letter_count - 1, -1, -1):
		letter_ui_node_array[i].queue_free()
	letter_ui_node_array = []


func _create_letter_ui_nodes(word: String) -> void:
	%LettersPanel.visible = false
	%LettersContainer.size.x = 0
	for character in word:
		var letter_ui_node: Node = letter_ui_scene.instantiate()
		letter_ui_node.text = character
		letter_ui_node_array.append(letter_ui_node)
		%LettersContainer.add_child(letter_ui_node)
	await get_tree().create_timer(0.1).timeout
	var panel_width: float = %LettersContainer.size.x + 2 * LETTERS_PANEL_HORIZONTAL_PADDING
	%LettersPanel.size.x = panel_width
	%LettersPanel.position.x = WINDOW_SIZE.x / 2 - panel_width / 2
	%LettersPanel.visible = true


func resolve_letter(letter_index: int) -> void:
	var letter_ui_node = letter_ui_node_array[letter_index]
	letter_ui_node.label_settings.font_color = ColorPalette.GREEN
	var tween: SimpleTween = TweenHelper.create(letter_ui_node)
	tween.to_scale_f(1.5, 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.to_scale_f(1, 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)


func update_timer(time_left: float) -> void:
	%TimerLabel.text = _get_formatted_time(time_left)
	%TimerLabelFront.text = _get_formatted_time(time_left)


func show_game_over_ui() -> void:
	_hide_timer_labels()
	for letter_ui in letter_ui_node_array:
		if letter_ui.label_settings.font_color != ColorPalette.GREEN:
			letter_ui.label_settings.font_color = ColorPalette.RED
	%GameOverLabel.visible = true


func hide_timeout_label() -> void:
	%GameOverLabel.visible = false


func hide_letters_ui_panel() -> void:
	%LettersPanel.visible = false


func _get_formatted_time(time_value: float) -> String:
	var seconds: int = floori(time_value)
	var tenths_seconds: int = floori(time_value * 10) % 10
	return "%d.%d" % [seconds, tenths_seconds]


func _show_timer_labels() -> void:
	%TimerLabel.visible = true
	%TimerLabelFront.visible = true


func _hide_timer_labels() -> void:
	%TimerLabel.visible = false
	%TimerLabelFront.visible = false 


func start_restart_sequence() -> void:
	%GameOverLabel.visible = false
	%LevelLabelContainer.visible = true
	for i in range(current_level_number - 1, 0, -1):
		await get_tree().create_timer(0.1).timeout
		AudioController.play_main_sfx(1.2)
		%LevelNumberLabel.text = "%d" % (i)
	restart_completed.emit()