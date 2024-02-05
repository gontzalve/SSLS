extends Node2D

@export var camera_container: Node2D

var target_node: Node2D
var should_follow: bool

func _process(_delta: float) -> void:
	_follow_target_node()


func set_target_reference(target: Node2D) -> void:
	should_follow = true
	target_node = target


func _follow_target_node() -> void:
	if target_node == null or not should_follow:
		return
	camera_container.global_position = target_node.global_position


func pause_following() -> void:
	should_follow = false


func resume_following() -> void:
	should_follow = true


func move_to_position(pos: Vector2, duration: float) -> void:
	var tween: SimpleTween = TweenHelper.create(camera_container)
	tween.to_position(pos, duration).set_easing(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
