extends Panel


signal dialogue_closed


@onready var dialogue_label = %DialogueLabel


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if dialogue_label.visible_ratio < 1:
			dialogue_label.visible_ratio = 1
		else:
			dialogue_closed.emit()
			queue_free()


func _process(_delta: float) -> void:
	if dialogue_label.visible_ratio < 1:
		dialogue_label.visible_characters += UserSettings.dialogue_speed
		if dialogue_label.get_parsed_text().substr(dialogue_label.visible_characters - 1, 1) != " ":
			AudioBus.play("Dialogue")


func set_text(new_text):
	dialogue_label.text = new_text
	dialogue_label.visible_characters = 0
