extends Node2D


func _ready() -> void:
	%Player.position = %Level.get_center_cell_pos()


func _process(_delta: float) -> void:
	pass
