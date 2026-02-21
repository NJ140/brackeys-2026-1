class_name MarkerSpawner extends Node2D

enum MarkerType{
	Slash,
}

var rhythm_manager :RhythmMan = GlobalRhythmManager
@export var marker_active_speed_beats : Dictionary[MarkerType,float] = {
	MarkerType.Slash : 2.0
}

@onready var player: Node2D = %Player
@onready var enemy: Node2D = %Enemy
var marker_scene =  preload("res://scripts/resources/marker.tscn")

var qeueed_marker_spawn: Array[float] = []
var current_index = 0
var song_qeueed = false

func _ready() -> void:
	EventBus.rhythm.song_starting.connect(prep_markers_for_song)

func prep_markers_for_song(battle_song:BattleSong):
	qeueed_marker_spawn.clear()
	for marker:float in battle_song.markers:
		var marker_type_speed : float = marker_active_speed_beats[MarkerType.Slash]
		var spawn_time = marker - (battle_song.get_seconds_per_beat() * marker_type_speed)
		qeueed_marker_spawn.append(spawn_time)
	song_qeueed = true
	EventBus.spawning.marker_spawns_set.emit(qeueed_marker_spawn)

func _process(_delta: float) -> void:
	if !(song_qeueed): return
	while current_index < qeueed_marker_spawn.size():
		if qeueed_marker_spawn[current_index] > rhythm_manager.get_current_song_time():
			break
		var m : Marker = marker_scene.instantiate()
		var spawn = qeueed_marker_spawn[current_index]
		m.global_position = enemy.global_position
		m.spawn_time = spawn
		m.spawn_point = enemy.global_position
		m.end_point = player.global_position
		m.time_to_hit = rhythm_manager.current_song.markers[current_index] + rhythm_manager.get_max_window()
		m.u_position = (rhythm_manager.get_current_song_time() - spawn) / (m.time_to_hit - spawn)
		m.id = current_index
		m.scale *= 1.2
		add_child(m)
		current_index += 1

func add_marker(lead_time,marker):
	marker.append(marker)

class marker_indecator extends Resource:
	pass
