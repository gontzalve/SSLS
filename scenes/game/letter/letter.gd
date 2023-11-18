extends CharacterBody2D

@export var color_palette_data: Resource
@export var letter_textures_data: Resource
@export var force_magnitude: float

var assigned_letter_char: String

const LETTER_GROUP_NAME: String = "letters"


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	_execute_movement(delta)
	pass
	

func initialize(pos: Vector2, letter_char: String) -> void:
	position = pos
	assigned_letter_char = letter_char
	set_initial_color()
	set_letter_type(letter_char)


func set_initial_color() -> void:
	var random_color: Color = color_palette_data.get_random_color_for_letter()
	$LetterSprite.modulate = random_color
	$Outline.modulate = random_color


func set_letter_type(letter_char: String) -> void:
	set_texture(letter_char)
	
	
func set_texture(letter_char: String) -> void:
	var letter_texture = letter_textures_data.get_texture_from_char(letter_char)
	$LetterSprite.texture = letter_texture
	

func _execute_movement(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group(LETTER_GROUP_NAME):
			print("colliding with letter")


func apply_random_force() -> void:
	var random_dir: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	print(random_dir)
#	add_constant_central_force(random_dir * force_magnitude)


