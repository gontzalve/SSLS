extends Node2D

@export var next_scene: PackedScene


func _ready() -> void:
	$Sequencer.sequence_ended.connect(_on_splash_sequence_ended)


func _on_splash_sequence_ended() -> void:
	get_tree().change_scene_to_packed(next_scene)
