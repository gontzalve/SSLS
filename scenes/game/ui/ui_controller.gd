extends Node2D

signal countdown_ended

@export var letter_ui_scene: PackedScene

const LETTERS_PANEL_HORIZONTAL_PADDING: int = 20
var letter_ui_node_array: Array[Node] = []


func hide_ui() -> void:
	$BackUI.visible = false
	$FrontUI.visible = false


func show_countdown_ui() -> void:
	$BackUI.visible = true
	%CountdownLabel.visible = true
	%TimerLabel.visible = false
	%GameOverLabel.visible = false


func show_level_ui() -> void:
	$BackUI.visible = true
	$FrontUI.visible = true
	%TimerLabel.visible = true
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
	var tween: Tween = create_tween()
	tween.tween_property(%CountdownLabel, "scale", Vector2.ONE * 1.3, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CountdownLabel, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func set_level_info(word: String, duration: float) -> void:
	update_timer(duration)
	_clear_letter_ui_nodes()
	_create_letter_ui_nodes(word)


func _clear_letter_ui_nodes() -> void:
	var letter_count: int = letter_ui_node_array.size()
	for i in range(letter_count, 0, -1):
		letter_ui_node_array[i].queue_free()
	letter_ui_node_array = []


func _create_letter_ui_nodes(word: String) -> void:
	%LettersPanel.visible = false
	for character in word:
		var letter_ui_node: Node = letter_ui_scene.instantiate()
		letter_ui_node.text = character
		letter_ui_node_array.append(letter_ui_node)
		%LettersContainer.add_child(letter_ui_node)
	await get_tree().create_timer(0.1).timeout
	var panel_width: float = %LettersContainer.size.x + 2 * LETTERS_PANEL_HORIZONTAL_PADDING
	%LettersPanel.size.x = panel_width
	%LettersPanel.visible = true


func update_timer(time_left: float) -> void:
	%TimerLabel.text = _get_formatted_time(time_left)
	%TimerLabelFront.text = _get_formatted_time(time_left)


func show_game_over_ui() -> void:
	%TimerLabel.visible = false
	%TimerLabelFront.visible = false
	%GameOverLabel.visible = true


func _get_formatted_time(time_value: float) -> String:
	var seconds: int = floori(time_value)
	var tenths_seconds: int = floori(time_value * 10) % 10
	return "%d.%d" % [seconds, tenths_seconds]
