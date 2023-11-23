extends CharacterBody2D

signal shot_fired(spawn_pos: Vector2, direction: Vector2)

@export var movement_speed: float
@export var movement_acceleration: float

const MOVE_LEFT_ACTION: String = "move_left"
const MOVE_RIGHT_ACTION: String = "move_right"
const MOVE_UP_ACTION: String = "move_up"
const MOVE_DOWN_ACTION: String = "move_down"

const SHOOT_ACTION: String = "shoot"


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	_check_movement_input(delta)
	_check_shooting_input(delta)
	_check_rotation()


func _check_movement_input(delta: float) -> void:
	var movement_dir: Vector2 = _get_movement_direction()
	var target_velocity: Vector2 = movement_dir * movement_speed
	velocity = velocity.move_toward(target_velocity, movement_acceleration * delta)
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var collision_speed: float = velocity.length() * 0.6
		collision.get_collider().velocity = collision_speed * -collision.get_normal()
#		velocity = velocity.bounce(collision.get_normal()) * 0.2
	

func _get_movement_direction() -> Vector2:
	var direction: Vector2 = Input.get_vector(MOVE_LEFT_ACTION, 
			MOVE_RIGHT_ACTION, MOVE_UP_ACTION, MOVE_DOWN_ACTION)
	return direction.normalized()


func _check_shooting_input(delta: float) -> void:
	if Input.is_action_just_pressed(SHOOT_ACTION):
		var shooting_dir: Vector2 = _get_shooting_direction()
		_shoot(shooting_dir)


func _get_shooting_direction() -> Vector2:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	return (mouse_pos - center_pos).normalized()


func _shoot(direction: Vector2) -> void:
	shot_fired.emit(position, direction)


func _check_rotation() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	var angle = rad_to_deg(center_pos.angle_to_point(mouse_pos))
	rotation_degrees = angle
	
