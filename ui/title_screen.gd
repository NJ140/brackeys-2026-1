extends Control

@export var next_scene_path: String = "res://ui/game_ui.tscn"
@export var fade_in_name: StringName = &"fade_in"
@export var fade_out_name: StringName = &"fade_out"

@onready var press_label: Label = $Center/Vbox/PressLabel
@onready var fade_rect: ColorRect = $Fade
@onready var anim: AnimationPlayer = $Anim

var _transitioning := false
var _blink_tween: Tween

func _ready() -> void:
	# Make sure Fade starts transparent
	fade_rect.visible = true
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var c := fade_rect.color
	c.a = 0.0
	fade_rect.color = c

	_start_press_blink()

	_force_fade_alpha(1.0)
	anim.play(fade_in_name)

func _unhandled_input(event: InputEvent) -> void:
	if _transitioning:
		return

	# "Press any button": keyboard, mouse click, controller
	if event is InputEventKey and event.pressed and not event.echo:
		_start_transition()
	elif event is InputEventMouseButton and event.pressed:
		_start_transition()
	elif event is InputEventJoypadButton and event.pressed:
		_start_transition()

func _start_transition() -> void:
	_transitioning = true

	# Stop blink
	if _blink_tween and _blink_tween.is_running():
		_blink_tween.kill()

	#clear -> black
	_force_fade_alpha(0.0)

	anim.play(fade_out_name)
	await anim.animation_finished

	#change scene
	var err := get_tree().change_scene_to_file(next_scene_path)
	if err != OK:
		push_error("Failed to change scene to: %s (err=%s)" % [next_scene_path, str(err)])

func _start_press_blink() -> void:
	press_label.visible = true
	press_label.modulate.a = 1.0

	if _blink_tween and _blink_tween.is_running():
		_blink_tween.kill()

	_blink_tween = create_tween()
	_blink_tween.set_loops() # infinite
	_blink_tween.tween_property(press_label, "modulate:a", 0.25, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_blink_tween.tween_property(press_label, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _force_fade_alpha(a: float) -> void:
	var c := fade_rect.color
	c.a = clamp(a, 0.0, 1.0)
	fade_rect.color = c
