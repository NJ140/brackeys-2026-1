extends Label

var song_length:float= 0.0
var time:float=0.0

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	if not GlobalRhythmManager.audio_player.stream: return
	song_length = GlobalRhythmManager.audio_player.stream.get_length()
	var t_min = floori(song_length / 60)
	var t_sec = floori(song_length) % 60
	time = min(GlobalRhythmManager.get_current_song_time(),song_length)
	var minute = floori(time / 60)
	var second = floori(time) % 60
	text = "%02d:%02d / %02d:%02d" % [minute, second, t_min,t_sec]
	
