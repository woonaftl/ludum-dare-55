extends Sprite2D


var wait
var destination = position
var speed = 250


func _ready():
	randomize()
	wait = randf_range(5, 15)


func _process(delta):
	visible = destination != position
	flip_h = destination.x < position.x
	position = position.move_toward(destination, delta * speed)
	offset = Vector2(0, sin(Time.get_ticks_msec() * 0.001) * 6)
	wait -= delta
	if wait < 1:
		wait = randf_range(10, 20)
		if position == Vector2(-50, 200):
			destination = Vector2(700, 150)
		else:
			destination = Vector2(-50, 200)
