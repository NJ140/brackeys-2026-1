@tool class_name BattleSong extends Resource

const HIT_MARKER_NAME = "HIT"

@export_file("*.ogg") var song_path: String
@export_file("*.txt") var marker_text: String

@export var markers : Array[float] = []

var song_name : StringName

func parse_text()
