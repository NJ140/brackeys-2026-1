class_name Marker extends Node2D

@onready var sprite: AnimatedSprite2D = %Marker

var rhythm_manager :RhythmMan= GlobalRhythmManager
var spawn_point:Vector2
var end_point:Vector2
var u_position = 0.0
var time_to_hit :float=0.0
var spawn_time := 0.0
var id = -1
var duration := 0.0

func _ready() -> void:
	EventBus.rhythm.marker_judged.connect(on_marker_judged)

func _process(delta: float) -> void:
	duration = time_to_hit - spawn_time
	if is_zero_approx(duration): 
		u_position = 1
	else:
		u_position = (rhythm_manager.get_current_song_time() - spawn_time) / (time_to_hit - spawn_time)
	global_position = lerp(spawn_point,end_point,u_position)

func on_marker_judged(grade,hit_error_sec,marker_index):
	if marker_index == id:
		queue_free()
