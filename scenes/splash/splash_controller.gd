extends Node2D

@export var godot_logo: Node2D
@export var godot_letter_container: Node2D

var godot_letters: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_get_references()
	_setup_scene()
	_execute_splash_sequence()


func _get_references() -> void:
	godot_letters = godot_letter_container.get_children()
	

func _setup_scene() -> void:
	godot_logo.scale = Vector2.ZERO
	var godot_letters_initial_pos: Vector2 = Vector2(480, 360)
	godot_letter_container.position = godot_letters_initial_pos


func _execute_splash_sequence() -> void:
	for letter in godot_letters:
		letter.visible = false
	await get_tree().create_timer(0.5).timeout
	for letter in godot_letters:
		letter.visible = true
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.1).timeout
	_tween_node_scale(godot_logo, 0.6, Tween.EASE_OUT)
	_tween_logo_letters(Vector2(480, 450), Tween.EASE_OUT)
	await get_tree().create_timer(1.2).timeout
	_tween_node_scale(godot_logo, 0, Tween.EASE_IN)
	_tween_logo_letters(Vector2(480, 360), Tween.EASE_IN)
	await get_tree().create_timer(0.6).timeout
	for letter in godot_letters:
		letter.visible = false
		await get_tree().create_timer(0.1).timeout
	

func _tween_node_scale(node: Node, new_scale: float, easing: int) -> void:
	var tween: Tween = create_tween()
	var tweener: PropertyTweener
	tweener = tween.tween_property(node, "scale", Vector2.ONE * new_scale, 0.4)
	tweener.set_trans(Tween.TRANS_BACK)
	tweener.set_ease(easing)
	

func _tween_logo_letters(new_position: Vector2, easing: int) -> void:
	var tween: Tween = create_tween()
	var tweener: PropertyTweener
	tweener = tween.tween_property(godot_letter_container, "position", new_position, 0.4)
	tweener.set_trans(Tween.TRANS_BACK)
	tweener.set_ease(easing)

