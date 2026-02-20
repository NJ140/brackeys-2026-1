@tool class_name BattleSong extends Resource
#TODO Get BPM for songs form jman
const HIT_MARKER_NAME = "HIT"

enum TimeSlice{
	Min,
	Sec,
	MiliSec,
}

@export var lead_time_beat_count :int= 4
@export var song: AudioStreamOggVorbis
@export_file("*.txt") var marker_text_path: String

@export var markers : Array[float] = []
var bpm :int

var song_name : StringName

func parse_marker_text():
	var markers_raw :String = FileAccess.get_file_as_string(marker_text_path)
	var parsed_markers : Array[float] = []
	markers_raw = markers_raw.remove_chars("\t")
	markers_raw = markers_raw.remove_chars(" ")
	var _bpm = markers_raw.get_slice("\n",0)
	bpm = _bpm.to_int()
	markers_raw = markers_raw.lstrip(_bpm+"\n")
	for i in markers_raw.get_slice_count("\n")-1:
		var result = markers_raw.get_slice("\n",i).get_slice(HIT_MARKER_NAME,0).erase(0,3)
		var value :float = 0.0
		for j in range(result.get_slice_count(":")-1,-1,-1):
			value += time_code_to_sec(j,result.get_slice(":",j).to_float())
		parsed_markers.append(value)
	markers = parsed_markers
	markers.sort()

func time_code_to_sec(index:int,t:float) -> float:
	var result :float= t
	match index:
		TimeSlice.Min:
			result *= 60
		TimeSlice.MiliSec:
			result /= 100
	return result

func get_bpm():
	return bpm

func get_seconds_per_beat() -> float:
	const sec_per_min = 60
	return (sec_per_min/(bpm as float))

func get_lead_time_sec():
	return get_seconds_per_beat() * (lead_time_beat_count as float) 
