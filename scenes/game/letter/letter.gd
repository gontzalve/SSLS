extends CharacterBody2D

signal dead(letter_node: Node2D)

@export var letter_textures_data: Resource
@export var force_magnitude: float
@export var friction: Vector2

var assigned_letter_char: String = ""
var assigned_color: Color
var is_dead: bool
var current_health: int

var hit_tween: SimpleTween = null

const LETTER_GROUP_NAME: String = "letters"
const WALL_GROUP_NAME: String = "walls"
const CLOSE_TO_ZERO_SPEED: float = 3
const MAX_SPEED: float = 300
const LETTER_MAX_HEALTH: int = 4


func appear() -> void:
	show()
	$LetterSprite.hide()
	scale = Vector2.ZERO
	is_dead = false
	current_health = LETTER_MAX_HEALTH
	_tween_up_scale()


func has_letter_assigned() -> bool:
	return assigned_letter_char != ""


func _tween_up_scale() -> void:
	var simple_tween: SimpleTween = TweenHelper.create(self).to_scale_f(1, 0.2)
	simple_tween.set_easing(Tween.TRANS_BACK, Tween.EASE_OUT).set_callback(_on_appeared)


func _on_appeared() -> void:
	$LetterSprite.show()


func _physics_process(delta: float) -> void:
	_execute_movement(delta)
	_apply_friction(delta)
	pass
	

func set_initial_pos(pos: Vector2) -> void:
	position = pos


func set_letter_type(letter_char: String) -> void:
	assigned_letter_char = letter_char
	set_texture(letter_char)
	

func set_initial_color() -> void:
	assigned_color = ColorPalette.get_random_color_for_letter()
	set_color(assigned_color)


func set_texture(letter_char: String) -> void:
	var letter_texture = letter_textures_data.get_texture_from_char(letter_char)
	$LetterSprite.texture = letter_texture
	

func _execute_movement(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group(LETTER_GROUP_NAME):
			var collision_speed: float = velocity.length() * 0.75
			collision.get_collider().velocity = collision_speed * -collision.get_normal()
		elif collision.get_collider().is_in_group(WALL_GROUP_NAME):
			velocity = velocity * -collision.get_normal() * 0.75


func on_bullet_collision(push_velocity: Vector2, bullet_angle: float) -> void:
	if is_dead:
		return
	_receive_push(push_velocity)
	_receive_damage(1)
	if current_health > 0:
		_play_hit_feedback(bullet_angle)
	else:
		_on_death()


func _receive_push(push_velocity: Vector2) -> void:
	var next_velocity = velocity + push_velocity 
	if next_velocity.length() <= MAX_SPEED:
		velocity = next_velocity
	else:
		velocity = next_velocity.normalized() * MAX_SPEED


func _receive_damage(damage: int) -> void:
	current_health -= damage


func _play_hit_feedback(bullet_angle: float) -> void:
	if hit_tween != null and hit_tween.is_running():
		hit_tween.stop()
	hit_tween = TweenHelper.create($Outline)
	hit_tween.to_scale_v(Vector2(0.9, 1.1), 0.2).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	hit_tween.to_scale_f(1, 0.2).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Outline.rotation_degrees = bullet_angle


func _on_death() -> void:
	is_dead = true
	dead.emit(self)
	set_process(false)
	velocity = Vector2.ZERO
	$Fill.visible = false
	$CollisionShape2D.set_deferred("disabled", true)


func disappear_as_correct_letter() -> void:
	if hit_tween != null and hit_tween.is_running():
		hit_tween.stop()
	var outline_tween: SimpleTween = TweenHelper.create($Outline)
	outline_tween.to_scale_f(0, 0.3).set_easing(Tween.TRANS_BACK, Tween.EASE_IN)
	var letter_tween: SimpleTween = TweenHelper.create($LetterSprite)
	letter_tween.to_alpha(0, 0.5).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN)
	letter_tween.parallel().to_position(Vector2.UP * 20, 0.5).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN)
	letter_tween.parallel().to_scale_f(1.5, 0.5).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN)
	await letter_tween.finished
	_on_disappeared()


func disappear_as_incorrect_letter() -> void:
	if hit_tween != null and hit_tween.is_running():
		hit_tween.stop()
	var letter_tween: SimpleTween = TweenHelper.create($LetterSprite)
	letter_tween.to_alpha(0, 0.2).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN)
	var outline_tween: SimpleTween = TweenHelper.create($Outline)
	outline_tween.to_scale_f(0, 0.3).set_easing(Tween.TRANS_BACK, Tween.EASE_IN)
	outline_tween.set_callback(_on_disappeared)


func _on_disappeared() -> void:
	queue_free()


func _apply_friction(delta: float) -> void:
	if velocity.length() < CLOSE_TO_ZERO_SPEED:
		velocity = Vector2.ZERO
	velocity -= sign(velocity) * friction * delta


func set_color(color: Color) -> void:
	$LetterSprite.modulate = color
	$Outline.modulate = color
