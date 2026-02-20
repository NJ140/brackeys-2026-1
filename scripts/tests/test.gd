extends Node

@onready var label: Label = $Label
@onready var rect_player: AnimationPlayer = %ColorRect/AnimationPlayer
@onready var rhythm_manager: RhythmMan = GlobalRhythmManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.rhythm.song_precount.connect(do_song_precount)
	EventBus.rhythm.clock.connect(on_clock)
	rect_player.play("new_animation")
	rhythm_manager.begin()

func do_song_precount(total,index):
	var countdown = (total-1)-index
	label.text = str(countdown) if countdown != 0 else "Go!"

func on_clock(_index,_time,_delta):
	if rhythm_manager:
		rect_player.speed_scale = 1.0/rhythm_manager.current_song.get_seconds_per_beat()
