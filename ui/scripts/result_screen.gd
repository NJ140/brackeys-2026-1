extends Control

@export var TITLE_SCENE: String = "res://ui/title_screen.tscn"
@export var victory_bg: Texture2D
@export var defeat_bg: Texture2D

@onready var background: TextureRect = $Background
@onready var fade_rect: ColorRect = $Fade
@onready var anim: AnimationPlayer = $Anim
@onready var result_label: Label = $Center/Card/Content/VBox/ResultLabel
@onready var score_label: Label = $Center/Card/Content/VBox/ScoreLabel

var _transitioning := false

func _ready() -> void:
	# Fill text + background from GameResult
	if GameResult.is_victory:
		result_label.text = "VICTORY"
		if victory_bg:
			background.texture = victory_bg
	else:
		result_label.text = "DEFEAT"
		if defeat_bg:
			background.texture = defeat_bg

	score_label.text = "Score: %d" % GameResult.final_score

	# Fade in
	fade_rect.color.a = 1.0
	if anim and anim.has_animation("fade_in"):
		anim.play("fade_in")
	else:
		fade_rect.color.a = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		_return_to_title()

func _return_to_title() -> void:
	if _transitioning:
		return
	_transitioning = true

	var tree := get_tree()

	if anim and anim.has_animation("fade_out"):
		anim.play("fade_out")
		await anim.animation_finished

	GameResult.clear()

	if tree:
		tree.change_scene_to_file(TITLE_SCENE)
