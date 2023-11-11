extends Node2D

const CELL_WIDTH: int = 64
const CELL_HEIGHT: int = 64


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_center_position() -> Vector2:
	return get_window().size / 2
