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

@export var markers : Array[float] = [] #[0.0, 0.124, 1.0, 1.124, 2.124, 3.0, 3.124, 4.124, 5.0, 5.124, 6.124, 7.0, 7.124, 7.124, 8.0, 8.124, 9.0, 9.124, 10.124, 11.0, 11.124, 12.124, 13.0, 13.124, 16.0, 17.0, 18.124, 19.0, 19.124, 20.0, 21.0, 22.0, 23.0, 24.0, 24.0, 25.0, 26.0, 27.0, 27.124, 28.0, 29.0, 30.0, 31.0, 32.0, 33.0, 34.0, 35.0, 35.124, 35.124, 36.0, 36.124, 37.0, 37.124, 38.124, 39.0, 39.124, 40.0, 40.124, 41.0, 41.124, 42.124, 43.0, 43.124, 43.124, 44.0, 44.124, 45.0, 45.124, 46.124, 47.0, 47.0, 47.124, 47.124, 48.0, 48.124, 49.0, 49.124, 50.124, 51.0, 51.124, 52.124, 53.0, 53.124, 54.124, 55.0, 55.124, 56.0, 56.124, 57.0, 57.124, 58.0, 59.0, 59.124, 60.0, 60.124, 60.124, 61.124, 61.124, 62.124, 63.0, 63.124, 64.124, 65.0, 65.124, 66.0, 67.0, 67.0, 67.124, 67.124, 68.0, 68.124, 69.0, 70.0, 70.124, 71.124, 72.0, 72.124, 73.0, 73.124, 74.124, 75.0, 75.124, 76.124, 77.0, 77.124, 78.124, 79.0, 82.0, 83.0, 83.124, 84.124, 86.0, 87.0, 87.124, 88.0, 89.124, 90.0, 91.0, 91.124, 92.0, 93.124, 94.124, 95.124, 96.0, 96.124, 97.0, 97.124, 98.0, 98.124, 99.0, 99.124, 100.0, 100.124, 101.0, 101.124, 102.0, 102.124, 103.0, 103.124, 104.0, 104.124, 105.0, 105.124, 106.124, 107.0, 107.124, 108.0, 108.0, 108.124, 108.124, 109.0, 109.0, 109.124, 109.124, 110.0, 110.0, 110.124, 110.124, 111.0, 111.0, 111.124, 111.124, 112.0, 114.124, 115.0, 115.124, 116.0, 116.124, 117.0, 117.124, 118.0, 118.124, 119.0, 119.124, 119.124, 120.0, 120.124, 121.0, 121.124, 122.0, 122.124, 123.0, 123.124, 124.0, 124.124, 125.0, 125.124, 126.0, 126.124, 127.0, 127.124, 127.124, 128.0, 128.124, 129.0, 129.124, 130.124, 131.0, 131.124, 132.0, 134.0, 134.124, 135.0, 135.124, 136.0, 136.124, 136.124, 137.124, 137.124, 139.0, 139.124, 140.0, 142.0, 142.124, 143.0, 143.124, 144.124, 144.124, 145.0, 146.124, 146.124, 147.0, 148.124, 148.124, 149.0, 150.124, 150.124, 151.0, 152.0, 153.0, 153.124, 154.0, 154.124, 155.0, 155.124, 156.0, 156.0, 157.0, 157.124, 157.124, 158.124, 159.124, 159.124, 160.0]

var bpm :int =120

var song_name : StringName

func _ready():
	markers.sort()

func parse_marker_text():
	var markers_raw :String = FileAccess.get_file_as_string(marker_text_path)
	var parsed_markers : Array[float] = []
	markers_raw = markers_raw.remove_chars("\t")
	markers_raw = markers_raw.remove_chars(" ")
	var _bpm = markers_raw.get_slice("\n",0)
	bpm = _bpm.to_int()
	print(markers_raw)
	markers_raw = markers_raw.lstrip(_bpm+"\n")
	for i in markers_raw.get_slice_count("\n")-1:
		var result = markers_raw.get_slice("\n",i).get_slice(HIT_MARKER_NAME,0).erase(0,3)
		var value :float = 0.0
		for j in range(result.get_slice_count(":")-1,-1,-1):
			value += time_code_to_sec(j,result.get_slice(":",j).to_float())
		parsed_markers.append(value)
	markers = parsed_markers
	markers.sort()
	print(markers)
	#print(markers)

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
