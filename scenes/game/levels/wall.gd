extends Sprite2D
class_name Wall

@export var wall_collision_shapes: Array[CollisionShape2D]


func activate_wall_at(pos: Vector2) -> void:
	position = pos
	visible = true
	for wall in wall_collision_shapes:
		wall.set_deferred("disabled", false)


func deactivate_wall() -> void:
	visible = false
	for wall in wall_collision_shapes:
		wall.set_deferred("disabled", true)