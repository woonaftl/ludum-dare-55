extends Node2D


var index


func _process(_delta):
	position = Vector2(24 + index * 48, 40) + Vector2(0, sin(Time.get_ticks_msec() * 0.001))
