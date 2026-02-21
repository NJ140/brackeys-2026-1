extends Label

var score :Dictionary[RhythmMan.Grade,int]= {
	RhythmMan.Grade.Perfect : 0,
	RhythmMan.Grade.Good : 0,
	RhythmMan.Grade.Early : 0,
	RhythmMan.Grade.Late : 0,
	RhythmMan.Grade.Miss : 0,
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.rhythm.marker_judged.connect(on_marker_judged)

func on_marker_judged(grade,hit_error_sec,marker_index):
	score[grade] += 1
	text = """
		Perfect: {0}
		Good: {1}
		Early: {2} 
		Late: {3}
		Miss: {4}
	""".format(score.values())
	pass
