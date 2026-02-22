extends Control

@export var hero_hp_path: NodePath
@export var vignette_path: NodePath

@export var low_threshold: float = 0.20   # 20%
@export var fade_seconds: float = 0.25
@export var ease_curve_power: float = 1.6 # higher = more edge-only feeling
@onready var score_value_label: Label = %ScoreValueLabel

var _hero_hp: Range
var _mat: ShaderMaterial
var _tween: Tween

func _ready() -> void:
	#UiEvent.score_changed.connect(score_value_label)
	_hero_hp = get_node(hero_hp_path) as Range
	var vignette := get_node(vignette_path) as ColorRect
	
	if vignette == null:
		push_error("Vignette node not found.")
		return
	
	_mat = vignette.material as ShaderMaterial
	
	if _mat == null:
		push_error("Vignette has no ShaderMaterial assigned.")
		return

	# Start correct
	_apply_strength(_compute_strength(
		_hero_hp.value,
		_hero_hp.min_value,
		_hero_hp.max_value
	))

	# React to HP changes
	_hero_hp.value_changed.connect(_on_hp_changed)
	


func _on_hp_changed(value: float) -> void:
	_apply_strength(_compute_strength(
		value,
		_hero_hp.min_value,
		_hero_hp.max_value
	))


func _compute_strength(value: float, minv: float, maxv: float) -> float:
	if maxv <= minv:
		return 0.0

	var ratio: float = (value - minv) / (maxv - minv) # 0..1

	# Map 20% → 0 strength
	# Map 0%  → 1 strength
	var denom: float = max(low_threshold, 0.0001)
	var t: float = clampf((low_threshold - ratio) / denom, 0.0, 1.0)

	# Curve it for nicer feel
	t = pow(t, ease_curve_power)

	return t * 1.35


func _apply_strength(target: float) -> void:
	if _tween and _tween.is_running():
		_tween.kill()

	var current: float = float(_mat.get_shader_parameter("strength"))

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_OUT)

	_tween.tween_method(
		func(x: float): _mat.set_shader_parameter("strength", x),
		current,
		target,
		fade_seconds
	)


func _on_pause_button_pressed() -> void:
	pass # Replace with function body.
