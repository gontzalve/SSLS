extends Node2D


func hide_ui() -> void:
	$BackUI.visible = false
	$FrontUI.visible = false
	pass


func show_ui() -> void:
	$BackUI.visible = true
	$FrontUI.visible = true
	pass


func set_level_info(word: String, duration: float) -> void:
	update_timer(duration)
	%WordLabel.text = word
	%GameOverLabel.visible = false
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
