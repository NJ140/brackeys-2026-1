extends ProgressBar

@export var is_enemy := false
@export var low_threshold := 0.25

# Set this per bar in the Inspector:
@export var normal_color := Color("#3DFF7A") # Hero default
@export var low_color := Color("#E04B4B")    # Red at low

# Pulse tuning (simple)
@export var pulse_bright := Color("#FF6B6B") # brighter red for pulse peak
@export var pulse_seconds := 0.8

var _fill_override: StyleBoxFlat
var _pulse_tween: Tween
var _is_low := false

func _ready() -> void:
	_prepare_fill_override()
	value_changed.connect(_on_value_changed)
	_on_value_changed(value)
	if is_enemy:
		EventBus.combat.enemy_damage.connect(func(v): value -= v)
	else:
		EventBus.combat.hero_damage.connect(func(v): value -= v)

func _prepare_fill_override() -> void:
	# Duplicate so we don't edit the shared Theme resource.
	var fill := get_theme_stylebox("fill")
	if fill is StyleBoxFlat:
		_fill_override = (fill as StyleBoxFlat).duplicate()
		add_theme_stylebox_override("fill", _fill_override)

func _on_value_changed(_v: float) -> void:
	if max_value <= min_value:
		return

	var ratio := (value - min_value) / (max_value - min_value)
	var now_low := ratio <= low_threshold

	if now_low and not _is_low:
		_is_low = true
		_start_pulse()
	elif (not now_low) and _is_low:
		_is_low = false
		_stop_pulse()
		_set_fill_color(normal_color)
	elif not now_low:
		# Keep normal color while healthy
		_set_fill_color(normal_color)

func _set_fill_color(c: Color) -> void:
	if _fill_override:
		_fill_override.bg_color = c

func _start_pulse() -> void:
	_stop_pulse()
	_set_fill_color(low_color)

	_pulse_tween = create_tween()
	_pulse_tween.set_loops() # infinite
	_pulse_tween.set_trans(Tween.TRANS_SINE)
	_pulse_tween.set_ease(Tween.EASE_IN_OUT)

	# Pulse between two reds
	_pulse_tween.tween_property(_fill_override, "bg_color", pulse_bright, pulse_seconds)
	_pulse_tween.tween_property(_fill_override, "bg_color", low_color,   pulse_seconds)

func _stop_pulse() -> void:
	if _pulse_tween and _pulse_tween.is_running():
		_pulse_tween.kill()
	_pulse_tween = null
