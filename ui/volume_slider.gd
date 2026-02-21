extends HSlider

@export var bus : String = "Master"
var bus_index : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index("Master")
	value_changed.connect(_value_changed)

func _value_changed(value):
	AudioServer.set_bus_volume_linear(bus_index,value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
