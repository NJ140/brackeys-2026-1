extends Label

var value:= 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.rhythm.marker_judged.connect(on_marker_judged)
	
func on_marker_judged(grade,hit_error_sec,marker_index):
	match grade:
		RhythmMan.Grade.Good:
			value += 10
			EventBus.game.score_changed.emit(10)
		RhythmMan.Grade.Perfect:
			value += 25
			EventBus.game.score_changed.emit(25)
		_:
			pass
	text = str(value)
