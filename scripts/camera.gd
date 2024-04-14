extends Camera2D


var decay = 4
var max_amplitude = Vector2(15, 15)
var destination = Vector2.ZERO
var speed = 3500


var shake_amplitude = 0:
	set(new_value):
		shake_amplitude = clamp(new_value, 0, 1)


func _process(delta):
	position = position.move_toward(destination, delta * speed)
	if shake_amplitude:
		shake_amplitude = max(shake_amplitude - decay * delta, 0)
		offset.x = shake_amplitude * randf()
		offset.y = shake_amplitude * randf()
