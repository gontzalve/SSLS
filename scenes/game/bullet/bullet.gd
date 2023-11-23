extends RigidBody2D


@export var initial_impulse: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func start_movement(direction: Vector2):
	apply_impulse(direction * initial_impulse)
	_set_initial_rotation(direction)


func _on_body_entered(body: Node) -> void:
	print(body.name)


func _set_initial_rotation(direction: Vector2) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	var angle = rad_to_deg(center_pos.angle_to_point(mouse_pos))
	rotation_degrees = angle
