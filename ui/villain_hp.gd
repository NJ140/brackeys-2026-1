extends ProgressBar
# (or extends Range)

@export var low_threshold := 0.25
@export var normal_color := Color("#A24CFF")
@export var low_color := Color("#E04B4B")

func _ready() -> void:
	update_color()
	value_changed.connect(_on_value_changed)

func _on_value_changed(_v: float) -> void:
	update_color()

func update_color() -> void:
	if max_value <= min_value:
		return

	var ratio := (value - min_value) / (max_value - min_value)

	var fill := get_theme_stylebox("fill")
	if fill is StyleBoxFlat:
		fill = (fill as StyleBoxFlat).duplicate()
		add_theme_stylebox_override("fill", fill)

		var sb := fill as StyleBoxFlat
		sb.bg_color = low_color if ratio <= low_threshold else normal_color
