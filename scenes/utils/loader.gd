extends Control

@export_file var game_scene_path

var loading_status: int
var loading_progress: Array[float]
var current_progress_shown: float
var current_progress_target: float
const LOADING_FILL_SPEED: float = 2


func _ready() -> void:
	current_progress_shown = 0
	current_progress_target = 0
	ResourceLoader.load_threaded_request(game_scene_path)


func _process(delta: float) -> void:
	_process_loading()
	_fill_loading_bar(delta)

func _process_loading() -> void:
	loading_status = ResourceLoader.load_threaded_get_status(game_scene_path, loading_progress)
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			%LoadingBarFill.scale.x = loading_progress[0]
		ResourceLoader.THREAD_LOAD_LOADED:
			_handle_on_scene_loaded(ResourceLoader.load_threaded_get(game_scene_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error. Could not load Resource")


func _fill_loading_bar(delta: float) -> void:
	current_progress_target = maxf(current_progress_target, loading_progress[0])
	current_progress_shown += LOADING_FILL_SPEED * delta
	current_progress_shown = minf(current_progress_shown, current_progress_target)
	%LoadingBarFill.scale.x = current_progress_shown


func _handle_on_scene_loaded(loaded_scene: Resource) -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(loaded_scene)
