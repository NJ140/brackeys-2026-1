extends Node

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.rhythm.song_precount.connect(do_song_precount)
	

func do_song_precount(total,index):
	var countdown = (total-1)-index
	label.text = str(countdown) if countdown != 0 else "Go!"
	
