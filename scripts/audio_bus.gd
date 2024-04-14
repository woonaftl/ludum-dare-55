extends Node


var wait_quack


func play(sound_id: String) -> void:
	var a: Node = get_node(sound_id)
	if a is AudioStreamPlayer and not a.playing:
		a.play()


func _ready():
	randomize()
	wait_quack = randf_range(5, 15)

func _process(delta):
	wait_quack -= delta
	if wait_quack < 1:
		wait_quack = randf_range(50, 80)
		play("Quack")
