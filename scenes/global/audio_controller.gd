extends Node2D

@export var audio_players: Array[AudioStreamPlayer]
@export var sfx_main: AudioStream

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func play_main_sfx(pitch: float) -> void:
	play_sfx(sfx_main, pitch, 0)


func play_sfx(audio_stream: AudioStream, pitch: float = 1, volume_db: float = 0) -> void:
	var audio_player: AudioStreamPlayer = _get_available_audio_player()
	audio_player.pitch_scale = pitch
	audio_player.volume_db = volume_db
	audio_player.stream = audio_stream
	audio_player.play()


func _get_available_audio_player() -> AudioStreamPlayer:
	for audio_player in audio_players:
		if not audio_player.playing:
			return audio_player
	var new_audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(new_audio_player)
	audio_players.append(new_audio_player)
	return new_audio_player
	

