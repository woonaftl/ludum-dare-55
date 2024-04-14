extends Control


@onready var level_select_button = %LevelSelectButton
@onready var quit_button = %QuitButton


func _ready():
	level_select_button.visible = not UserSettings.first_launch
	quit_button.visible = not OS.has_feature("web")


func _on_start_button_pressed():
	AudioBus.play("Click")
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_quit_button_pressed():
	AudioBus.play("Click")
	if not OS.has_feature("web"):
		get_tree().quit()


func _on_settings_button_pressed():
	AudioBus.play("Click")
	var settings: Window = preload("res://scenes/settings.tscn").instantiate()
	add_child(settings)
	settings.popup_centered()


func _on_credits_button_pressed():
	AudioBus.play("Click")
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_level_select_button_pressed():
	AudioBus.play("Click")
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
