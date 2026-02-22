extends ProgressBar

var song_length:float= 0.0
var time:float=0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not GlobalRhythmManager.audio_player.stream: return
	song_length = GlobalRhythmManager.audio_player.stream.get_length()
	time = GlobalRhythmManager.get_current_song_time()
	value = clampf(time/song_length,0.0 ,1.0)
