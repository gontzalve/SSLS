extends Node2D

enum ZoomTransitionState { 
	NONE, 
	DETECTING_ZOOM_IN, 
	DETECTING_ZOOM_OUT, 
	EXECUTING_ZOOM_IN,
	EXECUTING_ZOOM_OUT,
}

signal zoom_changed(is_zoom_in: bool)

@export var camera2D: Camera2D

const ZOOM_IN_ACTION: String = "zoom_in"
const ZOOM_OUT_ACTION: String = "zoom_out"

const ZOOM_IN_LEVEL_FROM_PLAYER: float = 1
const ZOOM_OUT_LEVEL_FROM_PLAYER: float = 0.5
const ZOOM_MIN_LEVEL: float = 0.3
const ZOOM_STEP: float = 0.1
const ZOOM_DETECTION_TIME: float = 0.3
const ZOOM_INACTIVITY_TIME: float = 0.2
const ZOOM_SENSIBILITY: float = 10

const PLAYER_ZOOM_DURATION: float = 0.4

var current_zoom: float
var current_zoom_transition: ZoomTransitionState
var zoom_detection_timer: float
var zoom_inactivity_timer: float


func _ready() -> void:
	current_zoom_transition = ZoomTransitionState.NONE
	zoom_detection_timer = 0
	zoom_inactivity_timer = 0
	apply_zoom_level(1)


func _process(delta: float) -> void:
	_check_zoom_input(delta)


func apply_zoom_level(zoom_level: float) -> void:
	current_zoom = maxf(zoom_level, ZOOM_MIN_LEVEL)
	camera2D.zoom = Vector2.ONE * current_zoom


func start_zoom(zoom_level: float, duration: float) -> void:
	current_zoom = maxf(zoom_level, ZOOM_MIN_LEVEL)
	_tween_camera_zoom(current_zoom, duration)


func get_current_zoom() -> float:
	return current_zoom


func _check_zoom_input(delta: float) -> void:
	if _is_executing_zoom():
		return
	var detected_zoom_input: int = _get_zoom_input()
	if detected_zoom_input == 0:
		_handle_no_zoom_input(delta)
	else:
		_handle_zoom_input(detected_zoom_input, delta)


func _handle_zoom_input(detected_input: int, delta: float) -> void:
	var detected_zoom_transition: ZoomTransitionState
	if detected_input == 1:
		detected_zoom_transition = ZoomTransitionState.DETECTING_ZOOM_IN
	else:
		detected_zoom_transition = ZoomTransitionState.DETECTING_ZOOM_OUT
	if current_zoom_transition != detected_zoom_transition:
		zoom_detection_timer = 0
		current_zoom_transition = detected_zoom_transition
	zoom_detection_timer += delta * ZOOM_SENSIBILITY
	if zoom_detection_timer >= ZOOM_DETECTION_TIME:
		if detected_input == 1:
			_zoom_in_from_player()
		else:
			_zoom_out_from_player()


func _get_zoom_input() -> int:
	if Input.is_action_just_pressed(ZOOM_IN_ACTION):
		return 1
	elif Input.is_action_just_pressed(ZOOM_OUT_ACTION):
		return -1
	else:
		return 0
 

func _handle_no_zoom_input(delta: float) -> void:
	if current_zoom_transition == ZoomTransitionState.NONE:
		return
	zoom_inactivity_timer += delta
	if zoom_inactivity_timer >= ZOOM_INACTIVITY_TIME:
		_reset_zoom_detection()

		
func _zoom_in_from_player() -> void:
	current_zoom_transition = ZoomTransitionState.EXECUTING_ZOOM_IN
	start_zoom(ZOOM_IN_LEVEL_FROM_PLAYER, PLAYER_ZOOM_DURATION)
	zoom_changed.emit(true)
	

func _zoom_out_from_player() -> void:
	current_zoom_transition = ZoomTransitionState.EXECUTING_ZOOM_OUT
	start_zoom(ZOOM_OUT_LEVEL_FROM_PLAYER, PLAYER_ZOOM_DURATION, )
	zoom_changed.emit(false)
	


func _tween_camera_zoom(zoom_level: float, duration: float) -> void:
	var tween: SimpleTween = TweenHelper.create(camera2D)
	tween.to_property_value("zoom", Vector2.ONE * zoom_level, duration)
	tween.set_easing(Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.set_callback(_on_tween_ended)
	

func _on_tween_ended():
	_reset_zoom_detection()	


func _reset_zoom_detection():
	current_zoom_transition = ZoomTransitionState.NONE
	zoom_detection_timer = 0
	zoom_inactivity_timer  = 0


func _is_executing_zoom() -> bool:
	return (current_zoom_transition == ZoomTransitionState.EXECUTING_ZOOM_IN 
		or current_zoom_transition == ZoomTransitionState.EXECUTING_ZOOM_OUT)
