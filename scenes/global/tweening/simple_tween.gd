extends Object

class_name  SimpleTween

signal finished

var node: Node
var tween: Tween
var tweener_dictionary = {}
var current_property: String


func _init(node_to_tween: Node) -> void:
	node = node_to_tween
	tween = node.create_tween()
	tween.finished.connect(_on_tween_finished)


func to_position(target_position: Vector2, duration: float) -> SimpleTween:
	current_property = "position"
	var tweener: PropertyTweener = tween.tween_property(node, current_property, target_position, duration)
	tweener_dictionary[current_property] = tweener
	return self


func to_scale_f(target_scale: float, duration: float) -> SimpleTween:
	return to_scale_v(Vector2.ONE * target_scale, duration)


func to_scale_v(target_scale: Vector2, duration: float) -> SimpleTween:
	current_property = "scale"
	var tweener: PropertyTweener = tween.tween_property(node, current_property, target_scale, duration)
	tweener_dictionary[current_property] = tweener
	return self


func to_alpha(target_alpha: float, duration: float, include_children: bool = true) -> SimpleTween:
	current_property = "modulate" if include_children else "self_modulate"
	var target_color: Color = node.modulate if include_children else node.self_modulate
	target_color.a = target_alpha
	var tweener: PropertyTweener = tween.tween_property(node, current_property, target_color, duration)
	tweener_dictionary[current_property] = tweener
	return self


func to_property_value(property_name: String, target_value: Variant, duration: float) -> SimpleTween:
	if property_name not in node:
		return self
	current_property = property_name
	var tweener: PropertyTweener = tween.tween_property(node, current_property, target_value, duration)
	tweener_dictionary[current_property] = tweener
	return self


func set_easing(transition_type: int, easing_type) -> SimpleTween:
	tweener_dictionary[current_property].set_trans(transition_type).set_ease(easing_type)
	return self


func parallel() -> SimpleTween:
	tween.parallel()
	return self


func set_callback(callback: Callable) -> SimpleTween:
	tween.tween_callback(callback)
	return self


func is_running() -> bool:
	return tween.is_running()


func stop() -> void:
	tween.stop()


func _on_tween_finished() -> void:
	finished.emit()
