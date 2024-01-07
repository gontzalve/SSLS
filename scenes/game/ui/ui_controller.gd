extends CanvasLayer


func set_level_info(word: String, duration: float) -> void:
	update_timer(duration)
	$WordContainer/WordLabel.text = word
	pass


func update_timer(time_left: float) -> void:
	$TimerLabel.text = _get_formatted_duration(time_left)


func _get_formatted_duration(duration: float) -> String:
	var minutes: int = floori(duration / 60)
	var seconds: int = floori(duration) % 60
	return "%01d:%02d" % [minutes, seconds]
