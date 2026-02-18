extends Node

var rhythm = _Rhythm.new()

class _Rhythm:
	signal clock(index)
	signal marker_judged(grade,hit_error_sec,marker_index)
	signal song_precount(max,index)
	signal song_started()
	signal song_ended()
