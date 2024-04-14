extends Node


var first_launch = true
var dialogue_speed = 1


func _ready() -> void:
	get_window().min_size = Vector2i(640, 360)
	set_master_volume(-10)


func set_master_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new_value)


func window_set_mode(new_value: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(new_value)
