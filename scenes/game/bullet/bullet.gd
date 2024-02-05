extends RigidBody2D


@export var initial_impulse: float
@export var push_force_magnitude: float
@export var shooting_particles_scene: PackedScene
@export var vanish_particles_scene: PackedScene
@export var range_duration: float

var current_direction: Vector2
var vanishing: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func start_movement(direction: Vector2, range_duration_factor: float):
	current_direction = direction
	apply_impulse(direction * initial_impulse)
	_set_initial_rotation()
	# _set_timer_for_range(range_duration_factor)


func _on_body_entered(body: Node) -> void:
	if vanishing:
		return
	if body.is_in_group("letters"):
		_on_collision_with_letter(body)
	elif body.is_in_group("walls"):
		_on_collision_with_wall()
	queue_free()


func _on_collision_with_letter(body: Node) -> void:
	var push_velocity: Vector2 = (body.position - position) * push_force_magnitude
	body.on_bullet_collision(push_velocity, rotation_degrees)
	var particles: Node = shooting_particles_scene.instantiate()
	get_tree().root.add_child(particles)
	particles.position = _calculate_particles_initial_position(body)
	particles.set_color(body.assigned_color)
	particles.set_direction(-1 * current_direction)


func _on_collision_with_wall() -> void:
	var particles: Node = shooting_particles_scene.instantiate()
	get_tree().root.add_child(particles)
	particles.global_position = $ParticlesPivot.global_position
	particles.set_color(ColorPalette.WHITE)
	particles.set_direction(-1 * current_direction)


func _calculate_particles_initial_position(letter_node: Node) -> Vector2:
	return lerp(position, letter_node.position, 0.75)


func _set_initial_rotation() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	var angle = rad_to_deg(center_pos.angle_to_point(mouse_pos))
	rotation_degrees = angle


func _set_timer_for_range(range_duration_factor: float) -> void:
	var duration = range_duration * range_duration_factor
	await get_tree().create_timer(duration).timeout
	_disable_bullet()


func _disable_bullet() -> void:
	$BulletShape.disabled = true
	vanishing = true
	sleeping = true
	var particles: Node = vanish_particles_scene.instantiate()
	get_tree().root.add_child(particles)
	particles.global_position = $VanishPivot.global_position
	queue_free()
