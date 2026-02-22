class_name RhythmMan extends Node

enum HitWindow{
	Early_Late,
	Good,
	Perfect,
}

enum Grade{
	No_Grade,
	Early,
	Good,
	Perfect,
	Late,
	Miss,
}
@onready var metronome: AudioStreamPlayer = %MetronomePlayer
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var audio_clock: AudioStreamPlayer = %AudioClock
@export var current_song: BattleSong
@export var hit_windows_sec:Dictionary[HitWindow,float]={
	HitWindow.Perfect : .05,
	HitWindow.Good : .08,
	HitWindow.Early_Late : .20,
}
@export var calibration_offset_sec: float = 0.0

var hit_windows := []

var in_lead_count = false
var song_playing = false

var last_emitted_beat := -1
var current_song_time := 0.0
var current_clock_time := 0.0

var next_marker_index :int = 0
var last_marker_index :int = -1 

var precount_start_time := 0.0

func _ready() -> void:
	audio_clock.play()
	EventBus.rhythm.marker_judged.connect(deb)

func reset():
	audio_clock.play()
	in_lead_count = false
	song_playing = false

	last_emitted_beat = -1
	current_song_time = 0.0
	current_clock_time = 0.0

	next_marker_index  = 0
	last_marker_index = -1 

	precount_start_time = 0.0

func begin(song:BattleSong):
	reset()
	if song:
		current_song = song
	if current_song.song:
		current_song.markers = BattleSong.UNTITLED if current_song.song_id == BattleSong.SongID.UNTITLED else BattleSong.YELLOW
		#current_song.markers.sort()
		
		current_song.parse_marker_text()
		start_lead_count()
		last_marker_index = current_song.markers.size() - 1
		print(0)
	else:
		print("no song")
	hit_windows = hit_windows_sec.keys()
	hit_windows.sort_custom(func(a,b): return hit_windows_sec[a] < hit_windows_sec[b])

func deb(grade,err,index):
	print(Grade.keys()[grade],", ",err,", ",index)

func _input(event: InputEvent) -> void:
	judge_input(event)

func _process(delta: float) -> void:
	var last_clock = current_clock_time
	current_clock_time = get_clock_time_seconds()
	var index = floori(current_clock_time/current_song.get_seconds_per_beat())
	EventBus.rhythm.clock.emit(index,current_clock_time,current_clock_time-last_clock)
	if not song_playing and in_lead_count: 
		if index != last_emitted_beat and index < current_song.lead_time_beat_count:
			metronome.play(0.04)
			last_emitted_beat = index
			EventBus.rhythm.song_precount.emit(current_song.lead_time_beat_count, index)
		if !song_playing and index >= current_song.lead_time_beat_count:
			start_song()
	elif song_playing:
		current_song_time = get_current_song_time()
		while next_marker_index <= last_marker_index:
			var next_marker = current_song.markers[next_marker_index]
			if current_song_time > next_marker + get_max_window():
				EventBus.rhythm.marker_judged.emit(Grade.Miss,get_max_window(),next_marker_index)
				next_marker_index += 1
			else:
				break
	if get_current_song_time() >= current_song.song.get_length():
		EventBus.rhythm.song_ended.emit()
func expected_song_pos() -> float:
	var now_clock := get_clock_time_seconds()
	var boundary_clock :float= precount_start_time + current_song.lead_time_beat_count * current_song.get_seconds_per_beat()
	return max(0.0, now_clock - boundary_clock)

func judge_input(event:InputEvent):
	current_song_time = get_current_song_time()
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
		if not next_marker_index <= last_marker_index: return
		var next_marker = current_song.markers[next_marker_index] 
		print(
			"prev err: ",(current_song_time - current_song.markers[next_marker_index-1]) if next_marker_index != 0 else "n/a"," | ",
			"next err: ",current_song_time - next_marker
		)
		for window in hit_windows:
			var hit_distance = current_song_time - next_marker
			var grade:Grade = Grade.No_Grade
			match window:
				HitWindow.Perfect: grade = Grade.Perfect
				HitWindow.Good: grade = Grade.Good
				HitWindow.Early_Late: grade = Grade.Early if hit_distance <= 0 else Grade.Late
			if abs(hit_distance) < hit_windows_sec[window]:
				EventBus.rhythm.marker_judged.emit(grade,hit_distance,next_marker_index)
				if next_marker_index <= last_marker_index:
					next_marker_index += 1
				return

func start_song():
	in_lead_count = false
	audio_player.stream = current_song.song
	audio_player.play()
	var want := expected_song_pos()
	var have := audio_player.get_playback_position()

	if abs(want - have) > 0.02:
		audio_player.seek(want)
	last_marker_index = current_song.markers.size() - 1
	song_playing = true

func stop_song(): 
	pass

func get_max_window():
	return hit_windows_sec.values().max()

func get_markers() -> Array[float]:
	if not current_song: return []
	return current_song.markers

func get_song_length() -> float:
	if not current_song: return -1.0
	return current_song.song.get_length()
	
func get_current_song_time() -> float:
	var t = audio_player.get_playback_position()
	var delay = AudioServer.get_time_since_last_mix()
	var latency = AudioServer.get_output_latency()
	
	if is_zero_approx(t):
		return get_clock_time_seconds() - current_song.get_lead_time_sec()
	return t + delay + calibration_offset_sec - latency

func start_lead_count():
	in_lead_count = true
	EventBus.rhythm.song_starting.emit(current_song) 
	precount_start_time = get_clock_time_seconds()

func get_clock_time_seconds() -> float:
	return max(0,audio_clock.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency())
