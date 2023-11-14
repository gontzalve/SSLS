extends CharacterBody2D

@export var movement_speed: float
@export var movement_acceleration: float

const MOVE_LEFT_ACTION: String = "move_left"
const MOVE_RIGHT_ACTION: String = "move_right"
const MOVE_UP_ACTION: String = "move_up"
const MOVE_DOWN_ACTION: String = "move_down"

const SHOOT_ACTION: String = "shoot"
#const MOVE_LEFT_ACTION: String = "move_left"


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	_check_movement_input(delta)


func _check_movement_input(delta: float) -> void:
	var movement_dir: Vector2 = _get_movement_direction()
	var target_velocity: Vector2 = movement_dir * movement_speed
	velocity = velocity.move_toward(target_velocity, movement_acceleration * delta)
	move_and_slide()
	

func _get_movement_direction() -> Vector2:
	var direction: Vector2 = Input.get_vector(MOVE_LEFT_ACTION, 
			MOVE_RIGHT_ACTION, MOVE_UP_ACTION, MOVE_DOWN_ACTION)
	return direction.normalized()
	
