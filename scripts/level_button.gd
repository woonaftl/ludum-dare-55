extends Button


var level = 0:
	set(new_value):
		level = new_value
		text = str(level + 1)


func _on_pressed():
	AudioBus.play("Click")
	Global.level = level
	get_tree().change_scene_to_file("res://scenes/level.tscn")
