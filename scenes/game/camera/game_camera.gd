extends Node2D

signal zoomed_in
signal zoomed_out

@export var follow_target_node: Node2D


func _ready() -> void:
	_inject_dependencies()
	_connect_to_children_signals()


func _inject_dependencies() -> void:
	%CameraFollow.set_target_reference(follow_target_node)


func _connect_to_children_signals() -> void:
	$CameraZoom.zoom_changed.connect(_on_camera_zoom_changed)


func _on_camera_zoom_changed(is_zoom_in: bool) -> void:
	if is_zoom_in:
		zoomed_in.emit()
	else:
		zoomed_out.emit()
