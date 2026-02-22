extends Node
@export var next_scene_path: String = "res://night.tscn"
@export var victory: String = "res://night.tscn"
@export var battle_song: BattleSong
@export var is_last = false

@onready var fade: ColorRect = %Fade
@onready var anim: AnimationPlayer = %Anim

GameResult
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("fade_in")
	GlobalRhythmManager.begin(battle_song)
	EventBus.rhythm.marker_judged.connect(on_judgment)
	EventBus.rhythm.song_ended.connect(load_next)
	EventBus.game.enemy_defeted.connect()

func load_next():
	if is_last:
		EventBus.game.victory.emit()
		anim.play("fade_out")
		return
	var err := get_tree().change_scene_to_file(next_scene_path)
	if err != OK:
		push_error("Failed to change scene to: %s (err=%s)" % [next_scene_path, str(err)])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_judgment(grade,hit_error_sec,marker_index):
	match grade:
		RhythmMan.Grade.Early,RhythmMan.Grade.Late:
			EventBus.combat.hero_damage.emit(1)
		RhythmMan.Grade.Good:
			EventBus.combat.enemy_damage.emit(2)
		RhythmMan.Grade.Perfect:
			EventBus.combat.enemy_damage.emit(3)
			EventBus.combat.hero_damage.emit(-1)
		RhythmMan.Grade.Miss:
			EventBus.combat.hero_damage.emit(2)
		_:
			pass
