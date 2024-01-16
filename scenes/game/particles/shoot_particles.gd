extends Node2D

@export var particle_system: CPUParticles2D


func _ready() -> void:
	particle_system.emitting = true
	particle_system.finished.connect(_on_particle_emission_finished)


func set_color(color: Color) -> void:
	particle_system.color = color


func set_direction(dir: Vector2) -> void:
	particle_system.direction = dir


func _on_particle_emission_finished() -> void:
	queue_free()