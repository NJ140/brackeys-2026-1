extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalRhythmManager.begin()
	EventBus.rhythm.marker_judged.connect(on_judgment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_judgment(grade,hit_error_sec,marker_index):
	pass
