extends Node

var rhythm = _Rhythm.new()

class _Rhythm:
	signal clock(index,current,delta)
	signal marker_judged(grade,hit_error_sec,marker_index)
	signal song_precount(max,index)
	signal song_starting(song:BattleSong)
