extends Node

var rhythm = _Rhythm.new()
var spawning = _Spawning.new()
var combat = _Combat.new()

class _Rhythm:
	signal clock(index,current,delta)
	signal marker_judged(grade,hit_error_sec,marker_index)
	signal song_precount(max,index)
	signal song_starting(song:BattleSong)

class _Spawning:
	signal marker_spawns_set(markers)

class _Combat:
	signal enemy_damage(value)
	signal hero_damage(value)
	signal player_lost
