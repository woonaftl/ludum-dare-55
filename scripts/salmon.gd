extends Sprite2D


signal reached_destination


var speed = 350
var destination
var on_my_way = true


func _process(delta):
	position = position.move_toward(destination, delta * speed)
	offset = Vector2(0, sin(Time.get_ticks_msec() * 0.001) * 6)
	if position == destination:
		if on_my_way:
			on_my_way = false
			reached_destination.emit()
	else:
		on_my_way = true
