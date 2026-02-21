extends Control

@onready var game_view: SubViewportContainer = $Layout/CenterArea/GameView
@onready var subvp: SubViewport = $Layout/CenterArea/GameView/SubViewport
@onready var world_ui: Control = $Layout/CenterArea/GameView/SubViewport/World
@onready var volume_slider: HSlider = $Layout/TopBar/TopMargin/TopRoot/TopRow/LeftControls/VolumeSliderWrap/VolumeSlider

@onready var hero_hp: ProgressBar = $Layout/BottomBar/BottomMargin/BottomRow/LeftHUD/HeroHP
@onready var villain_hp: ProgressBar = $Layout/BottomBar/BottomMargin/BottomRow/RightHUD/VillainHP

var selected_name: String = ""
var selected_id: String = ""

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

	if selected_name != "":
		$Layout/BottomBar/BottomMargin/BottomRow/LeftHUD/HeroName.text = SelectedCharacter.character_name
	EventBus.combat.enemy_damage.connect(_on_villian_damage)
	EventBus.combat.hero_damage.connect(_on_hero_damage)

func _on_villian_damage(value):
	villain_hp.value = max(0, villain_hp.value - value)
	#if villain_hp.value <= 0:
		#pass

func _on_hero_damage(value):
	hero_hp.value = max(0, hero_hp.value - value)
	if hero_hp.value <= 0:
		EventBus.combat.player_lost.emit()
	
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
