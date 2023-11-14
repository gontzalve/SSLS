extends Camera2D

enum ZoomTransitionState { 
	NONE, 
	DETECTING_ZOOM_IN, 
	DETECTING_ZOOM_OUT, 
	EXECUTING_ZOOM_IN,
	EXECUTING_ZOOM_OUT,
}

const ZOOM_IN_ACTION: String = "zoom_in"
const ZOOM_OUT_ACTION: String = "zoom_out"

const MAX_ZOOM_IN: float = 1
const MAX_ZOOM_OUT: float = 0.5
const ZOOM_STEP: float = 0.1
const ZOOM_DETECTION_TIME: float = 0.3
const ZOOM_INACTIVITY_TIME: float = 0.2
const ZOOM_SENSIBILITY: float = 10

var player_node: Node2D
var current_zoom: float
var current_zoom_transition: ZoomTransitionState
var zoom_detection_timer: float
var zoom_inactivity_timer: float


func _ready() -> void:
	player_node = %Player
	current_zoom_transition = ZoomTransitionState.NONE
	zoom_detection_timer = 0
	zoom_inactivity_timer = 0
	_set_zoom(1)


func _process(delta: float) -> void:
	_follow_player()
	_check_zoom_input(delta)


func _follow_player() -> void:
	if player_node == null:
		return
	position = player_node.position


func _check_zoom_input(delta: float) -> void:
	if _is_executing_zoom():
		return
	var detected_zoom_input: int = _get_zoom_input()
	if detected_zoom_input == 0:
		_handle_no_zoom_input(delta)
	else:
		_handle_zoom_input(detected_zoom_input, delta)


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
		_reset()
		

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
		print("DETECTED ZOOM")
		if detected_input == 1:
			_zoom_in()
		else:
			_zoom_out()
			
		
func _zoom_in() -> void:
	current_zoom_transition = ZoomTransitionState.EXECUTING_ZOOM_IN
	_set_zoom(MAX_ZOOM_IN)
	

func _zoom_out() -> void:
	current_zoom_transition = ZoomTransitionState.EXECUTING_ZOOM_OUT
	_set_zoom(MAX_ZOOM_OUT)
	

func _set_zoom(zoom_level: float) -> void:
	zoom_level = clampf(zoom_level, MAX_ZOOM_OUT, MAX_ZOOM_IN)
	current_zoom = zoom_level
	var tween: Tween = create_tween()
	var tweener: PropertyTweener
	tweener = tween.tween_property(self, "zoom", Vector2.ONE * zoom_level, 0.4)
	tweener.set_trans(Tween.TRANS_BACK)
	tweener.set_ease(Tween.EASE_OUT)
	tween.tween_callback(_on_tween_ended)


func _on_tween_ended():
	_reset()


func _reset():
	current_zoom_transition = ZoomTransitionState.NONE
	zoom_detection_timer = 0
	zoom_inactivity_timer  = 0


func _is_executing_zoom() -> bool:
	return (current_zoom_transition == ZoomTransitionState.EXECUTING_ZOOM_IN 
		or current_zoom_transition == ZoomTransitionState.EXECUTING_ZOOM_OUT)
