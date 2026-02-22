extends AnimatedSprite2D



const BLOCK = "attack_2"
const ATTACK = "attack_1"
const IDLE = "idle"

@export var is_enemy := false

var times_to_attack := []
var index := 0

func _ready() -> void:
	if is_enemy:
		EventBus.spawning.marker_spawns_set.connect(on_marker_spawns_set)
	animation_finished.connect(play.bind(IDLE))

func _input(event: InputEvent) -> void:
	if is_enemy: return
	
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
		play("attack_2")

func  _process(delta: float) -> void:
	if not is_enemy: return
	var time = GlobalRhythmManager.get_current_song_time()
	while index < times_to_attack.size():
		if times_to_attack[index] > time:
			break
		play(ATTACK)
		index += 1

func on_marker_spawns_set(markers:Array):
	var animation_time :float= sprite_frames.get_frame_count(ATTACK) / sprite_frames.get_animation_speed(ATTACK) as float
	times_to_attack = markers.map(func(m): return m - animation_time)
	#print(times_to_attack)
