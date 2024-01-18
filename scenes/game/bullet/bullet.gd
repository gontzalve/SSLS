extends RigidBody2D


@export var initial_impulse: float
@export var push_force_magnitude: float
@export var shooting_particles_scene: PackedScene

var current_direction: Vector2


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func start_movement(direction: Vector2):
	current_direction = direction
	apply_impulse(direction * initial_impulse)
	_set_initial_rotation()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("letters"):
		var push_velocity: Vector2 = (body.position - position) * push_force_magnitude
		body.on_bullet_collision(push_velocity, rotation_degrees)
		var particles: Node = shooting_particles_scene.instantiate()
		get_tree().root.add_child(particles)
		particles.position = _calculate_particles_initial_position(body)
		particles.set_color(body.assigned_color)
		particles.set_direction(-1 * current_direction)
	queue_free()


func _calculate_particles_initial_position(letter_node: Node) -> Vector2:
	return lerp(position, letter_node.position, 0.75)


func _set_initial_rotation() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	var angle = rad_to_deg(center_pos.angle_to_point(mouse_pos))
	rotation_degrees = angle
