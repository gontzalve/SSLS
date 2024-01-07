extends Node2D

signal countdown_ended


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
		if i == duration_seconds:
			%CountdownLabel.text = "Go!"
			await get_tree().create_timer(0.5).timeout
		else:
			%CountdownLabel.text = "%d" % (duration_seconds - i)
			await get_tree().create_timer(1).timeout
	%CountdownLabel.visible = false
	countdown_ended.emit()


func set_level_info(word: String, duration: float) -> void:
	update_timer(duration)
	%WordLabel.text = word
	pass


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
