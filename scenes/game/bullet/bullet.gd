extends RigidBody2D


@export var initial_impulse: float
@export var push_force_magnitude: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func start_movement(direction: Vector2):
	apply_impulse(direction * initial_impulse)
	_set_initial_rotation(direction)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("letters"):
		var push_velocity: Vector2 = (body.position - position) * push_force_magnitude
		body.on_bullet_collision(push_velocity)
	queue_free()
	pass


func _set_initial_rotation(direction: Vector2) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	var angle = rad_to_deg(center_pos.angle_to_point(mouse_pos))
	rotation_degrees = angle
