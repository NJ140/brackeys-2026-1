extends Node

@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var songs_

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var t = audio_player.get_playback_position()
	var delay = AudioServer.get_time_since_last_mix()
	var latency = AudioServer.get_output_latency()
	
	var corrected_time = t + delay - latency

func get_song(song_name): pass

func parse_logic_markers(file:Resource) -> Array[float]:
	return []


	
	
	
