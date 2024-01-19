extends CharacterBody2D

signal appeared
signal shot_fired(spawn_pos: Vector2, direction: Vector2)

@export var movement_speed: float
@export var movement_acceleration: float
@export var sfx_player_shot: AudioStream

var allowed_input: bool
var allowed_shooting_input: bool
var is_shooting: bool
var current_inaccuracy: float

const MOVE_LEFT_ACTION: String = "move_left"
const MOVE_RIGHT_ACTION: String = "move_right"
const MOVE_UP_ACTION: String = "move_up"
const MOVE_DOWN_ACTION: String = "move_down"

const SHOOT_ACTION: String = "shoot"
const SHOOT_COOLDOWN: float = 0.08
const MAX_SHOOT_INACCURACY: float = 10 # in degree angles
const INACCURACY_INCREASE_PER_SHOT: float = 1 # in degree angles
const INACCURACY_DECREASE_RATE_PER_SECOND: float = 5


func _ready() -> void:
	is_shooting = false
	current_inaccuracy = 0


func _process(delta: float) -> void:
	if not allowed_input:
		return
	_check_movement_input(delta)
	_decrease_inaccuracy(delta)
	_check_shooting_input()
	_check_rotation()
	

func initialize() -> void:
	allowed_input = false
	scale = Vector2.ZERO


func appear_at(pos: Vector2) -> void:
	position = pos
	_tween_up_scale()


func allow_input() -> void:
	allowed_input = true


func disallow_input() -> void:
	allowed_input = false


func allow_shooting_input() -> void:
	allowed_shooting_input = true
	%ArrowSprite.visible = true 
	%CrossSprite.visible = false


func disallow_shooting_input() -> void:
	allowed_shooting_input = false
	%CrossSprite.visible = true 
	%ArrowSprite.visible = false


func _tween_up_scale() -> void:
	var tween: SimpleTween = TweenHelper.create(self).to_scale_f(1, 0.2)
	tween.set_easing(Tween.TRANS_BACK, Tween.EASE_OUT).set_callback(_on_appeared)


func _on_appeared() -> void:
	AudioController.play_main_sfx(0.8)
	appeared.emit()


func _check_movement_input(delta: float) -> void:
	var movement_dir: Vector2 = _get_movement_direction()
	var target_velocity: Vector2 = movement_dir * movement_speed
	velocity = velocity.move_toward(target_velocity, movement_acceleration * delta)
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("letters"):
			_handle_collision_with_letter(collision)


func _handle_collision_with_letter(collision: KinematicCollision2D) -> void:
	var collision_speed: float = velocity.length() * 0.75
	collision.get_collider().velocity = collision_speed * -collision.get_normal()
	# velocity = velocity.bounce(collision.get_normal()) * 0.2
	

func _get_movement_direction() -> Vector2:
	var direction: Vector2 = Input.get_vector(MOVE_LEFT_ACTION, 
			MOVE_RIGHT_ACTION, MOVE_UP_ACTION, MOVE_DOWN_ACTION)
	return direction.normalized()


func _check_shooting_input() -> void:
	if is_shooting:
		return
	if Input.is_action_pressed(SHOOT_ACTION):
		if allowed_shooting_input:
			_increase_inaccuracy()
			var aiming_dir: Vector2 = _get_aiming_direction()
			var shooting_dir: Vector2 = _calculate_shooting_direction(aiming_dir, current_inaccuracy)
			_shoot(shooting_dir)
		else:
			_play_cross_feedback()


func _get_aiming_direction() -> Vector2:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	return (mouse_pos - center_pos).normalized()


func _increase_inaccuracy() -> void:
	if (current_inaccuracy < MAX_SHOOT_INACCURACY):
		current_inaccuracy += INACCURACY_INCREASE_PER_SHOT
		current_inaccuracy = min(current_inaccuracy, MAX_SHOOT_INACCURACY)


func _decrease_inaccuracy(delta: float) -> void:
	if current_inaccuracy > 0:
		current_inaccuracy -= delta * INACCURACY_DECREASE_RATE_PER_SECOND
		current_inaccuracy = max(current_inaccuracy, 0)


func _shoot(direction: Vector2) -> void:
	is_shooting = true
	shot_fired.emit($ShootingPivot.global_position, direction)
	AudioController.play_sfx(sfx_player_shot, randf_range(0.9, 1.1), -12)
	_tween_player_arrow()
	# _tween_container_scale()
	await get_tree().create_timer(SHOOT_COOLDOWN).timeout
	is_shooting = false


func _calculate_shooting_direction(shooting_direction: Vector2, inaccuracy: float) -> Vector2:
	var inaccuracy_angle: float = deg_to_rad(randf_range(-inaccuracy, inaccuracy))
	var random_x: float = cos(inaccuracy_angle) * shooting_direction.x - sin(inaccuracy_angle) * shooting_direction.y
	var random_y: float = sin(inaccuracy_angle) * shooting_direction.x + cos(inaccuracy_angle) * shooting_direction.y
	return Vector2(random_x, random_y).normalized()


func _tween_player_arrow() -> void:
	var tween: SimpleTween = TweenHelper.create(%ArrowSprite)
	tween.to_position(Vector2.RIGHT * 17, 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.to_position(Vector2.RIGHT * 20, 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)


# func _tween_container_scale() -> void:
# 	var tween: SimpleTween = TweenHelper.create(%SpriteContainer)
# 	tween.to_scale_v(Vector2(0.9, 1.1), 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
# 	tween.to_scale_v(Vector2.ONE, 0.15).set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)


func _check_rotation() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center_pos: Vector2 = get_viewport().size / 2
	var angle = rad_to_deg(center_pos.angle_to_point(mouse_pos))
	rotation_degrees = angle


func _play_cross_feedback() -> void:
	var tween: SimpleTween = TweenHelper.create(%CrossSprite)
	tween.to_scale_f(0.7, 0.1).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.to_scale_f(1, 0.1).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
