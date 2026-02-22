extends Node

var final_score: int = 0
var is_victory: bool = false

func _ready() -> void:
	EventBus.game.score_changed.connect(update_score)

func update_score(delta):
	final_score += delta

func set_result(victory: bool, score: int) -> void:
	is_victory = victory
	final_score = score

func clear() -> void:
	is_victory = false
	final_score = 0
