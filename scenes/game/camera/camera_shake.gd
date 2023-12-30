extends Node2D

@export var camera_2d: Camera2D
@export var shake_fade: float = 5.0
@export var max_strength: float = 30.0

var current_shake_strength: float = 5.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var is_shaking: bool

func _ready() -> void:
	is_shaking = false


func _process(delta: float) -> void:
	if not is_shaking:
		return
	_process_shake(delta)


func start_shake() -> void:
	is_shaking = true
	current_shake_strength = max_strength


func _process_shake(delta: float) -> void:
	if current_shake_strength <= 0:
		is_shaking = false
		return
	var offset_x: float = rng.randf_range(-current_shake_strength, current_shake_strength)
	var offset_y: float = rng.randf_range(-current_shake_strength, current_shake_strength)
	var random_offset: Vector2 = Vector2(offset_x, offset_y)
	camera_2d.offset = random_offset
	current_shake_strength = lerpf(current_shake_strength, 0, shake_fade * delta)
