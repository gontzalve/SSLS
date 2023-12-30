extends CharacterBody2D

@export var color_palette_data: Resource
@export var letter_textures_data: Resource
@export var force_magnitude: float
@export var friction: Vector2

var assigned_letter_char: String
var assigned_color: Color

const LETTER_GROUP_NAME: String = "letters"
const CLOSE_TO_ZERO_SPEED: float = 3
const MAX_SPEED: float = 200


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
	assigned_color = color_palette_data.get_random_color_for_letter()
	_set_color(assigned_color)


func set_texture(letter_char: String) -> void:
	var letter_texture = letter_textures_data.get_texture_from_char(letter_char)
	$LetterSprite.texture = letter_texture
	

func _execute_movement(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group(LETTER_GROUP_NAME):
			var collision_speed: float = velocity.length() * 0.75
			collision.get_collider().velocity = collision_speed * -collision.get_normal()


func on_bullet_collision(push_velocity: Vector2) -> void:
	_receive_push(push_velocity)
	_execute_flash_sequence()


func _receive_push(push_velocity: Vector2) -> void:
	var next_velocity = velocity + push_velocity 
	if next_velocity.length() <= MAX_SPEED:
		velocity = next_velocity
	else:
		velocity = next_velocity.normalized() * MAX_SPEED


func _execute_flash_sequence() -> void:
	_set_color(Color.WHITE)
	await get_tree().create_timer(0.2).timeout
	_set_color(assigned_color)


func _apply_friction(delta: float) -> void:
	if velocity.length() < CLOSE_TO_ZERO_SPEED:
		velocity = Vector2.ZERO
	velocity -= sign(velocity) * friction * delta


func _set_color(color: Color) -> void:
	$LetterSprite.modulate = color
	$Outline.modulate = color
	
