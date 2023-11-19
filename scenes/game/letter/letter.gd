extends CharacterBody2D

@export var color_palette_data: Resource
@export var letter_textures_data: Resource
@export var force_magnitude: float
@export var friction: Vector2

var assigned_letter_char: String

const LETTER_GROUP_NAME: String = "letters"
const CLOSE_TO_ZERO_SPEED: float = 3


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
	var random_color: Color = color_palette_data.get_random_color_for_letter()
	$LetterSprite.modulate = random_color
	$Outline.modulate = random_color


func set_texture(letter_char: String) -> void:
	var letter_texture = letter_textures_data.get_texture_from_char(letter_char)
	$LetterSprite.texture = letter_texture
	

func _execute_movement(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group(LETTER_GROUP_NAME):
			var collision_speed: float = velocity.length() * 0.6
			collision.get_collider().velocity = collision_speed * -collision.get_normal()


func _apply_friction(delta: float) -> void:
	if velocity.length() < CLOSE_TO_ZERO_SPEED:
		velocity = Vector2.ZERO
	velocity -= sign(velocity) * friction * delta
	
