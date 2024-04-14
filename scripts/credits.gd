extends Control


func _on_back_button_pressed():
	AudioBus.play("Click")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
