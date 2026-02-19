extends Control

@onready var game_view: SubViewportContainer = $Layout/CenterArea/GameView
@onready var subvp: SubViewport = $Layout/CenterArea/GameView/SubViewport
@onready var world_ui: Control = $Layout/CenterArea/GameView/SubViewport/World
@onready var volume_slider: HSlider = $Layout/TopBar/TopMargin/TopRoot/TopRow/LeftControls/VolumeSliderWrap/VolumeSlider

func _ready() -> void:
	# Run once now (may be 0-sized), then again after layout is finalized.
	_resize_subviewport()
	call_deferred("_resize_subviewport")

	# Re-run when this Control resizes and when the OS window changes.
	resized.connect(_resize_subviewport)
	get_viewport().size_changed.connect(_resize_subviewport)

	# Re-run when containers finish arranging children (important for VBox/HBox layouts).
	$Layout.sort_children.connect(_resize_subviewport)
	
	volume_slider.value_changed.connect(_volume_changed)
	
func _volume_changed(value):
	UiEvent.volume_changed.emit(value)
	
func _resize_subviewport() -> void:
	var s: Vector2 = game_view.size
	if s.x < 1.0 or s.y < 1.0:
		return

	subvp.size = Vector2i(int(s.x), int(s.y))

	# Give the Control root inside the SubViewport an explicit rect
	world_ui.position = Vector2.ZERO
	world_ui.size = s
