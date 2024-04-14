extends Control


@onready var control = %Control


func _ready():
	for index in range(Global.level_count - 1, -1, -1):
		var level_button = preload("res://scenes/level_button.tscn").instantiate()
		level_button.level = index
		control.add_sibling(level_button)


func _on_back_button_pressed():
	AudioBus.play("Click")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
