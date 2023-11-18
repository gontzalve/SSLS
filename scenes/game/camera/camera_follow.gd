extends Node2D

@export var camera_container: Node2D

var target_node: Node2D

func _process(delta: float) -> void:
	_follow_target_node()


func set_target_reference(target: Node2D) -> void:
	target_node = target


func _follow_target_node() -> void:
	if target_node == null:
		return
	camera_container.position = target_node.position
