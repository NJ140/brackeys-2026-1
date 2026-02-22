extends Button
const PAUSE_CHAR = "▐▐  "
const PLAY_CHAR = "   ▶︎   "

var is_paused = false
func _ready() -> void:
	text = PAUSE_CHAR

func _on_pressed() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
	text = PAUSE_CHAR if not is_paused else PLAY_CHAR

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		_on_pressed()
