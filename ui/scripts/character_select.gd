extends Control

@export var battle_scene_path: String = "res://ui/game_ui.tscn"

@onready var option_a: Button = $Center/VBox/OptionA
@onready var option_b: Button = $Center/VBox/OptionB

@onready var name_a: Label = $Center/VBox/OptionA/Row/Name
@onready var name_b: Label = $Center/VBox/OptionB/Row/Name

@onready var fade_rect: ColorRect = $Fade
@onready var anim: AnimationPlayer = $Anim

const CHAR_A_ID := "hero_a"
const CHAR_A_NAME := "Hero A"
const CHAR_B_ID := "hero_b"
const CHAR_B_NAME := "Hero B"

var _transitioning := false

func _ready() -> void:
	# IMPORTANT: Fade should not block button clicks
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Start black, then fade in
	fade_rect.color.a = 1.0
	if anim.has_animation("fade_in"):
		anim.play("fade_in")
	else:
		fade_rect.color.a = 0.0

	# Set label text
	name_a.text = CHAR_A_NAME
	name_b.text = CHAR_B_NAME

	# Click selection
	option_a.pressed.connect(func(): _select_character(CHAR_A_ID, CHAR_A_NAME))
	option_b.pressed.connect(func(): _select_character(CHAR_B_ID, CHAR_B_NAME))

func _select_character(char_id: String, char_name: String) -> void:
	if _transitioning:
		return
	_transitioning = true

	# Fade out then switch
	if anim.has_animation("fade_out"):
		anim.play("fade_out")
		await anim.animation_finished

	# Store selection globally
	SelectedCharacter.character_id = char_id
	SelectedCharacter.character_name = char_name

	get_tree().change_scene_to_file(battle_scene_path)
