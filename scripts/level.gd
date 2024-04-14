extends Control


const STICK = preload("res://scenes/stick.tscn")
const EQUALS = preload("res://scenes/equals.tscn")
const PLUS = preload("res://scenes/plus.tscn")


enum States {WAIT, PLAY, COMPLETE}


var puzzle = ""
var state = States.WAIT


@onready var camera = %Camera
@onready var cursor = %Cursor
@onready var equation_control = %EquationControl
@onready var salmon = %Salmon
@onready var summons_left_label = %SticksLeftLabel
@onready var canvas_layer = %CanvasLayer
@onready var dialogue_container = %DialogueContainer
@onready var message_label = %MessageLabel


@onready var summons_left = 0:
	set(new_value):
		summons_left = new_value
		refresh_summons_left_label()


@onready var banishes_left = 0:
	set(new_value):
		banishes_left = new_value
		refresh_summons_left_label()


func _ready():
	camera.position.x -= 800
	load_puzzle()
	if UserSettings.first_launch and Global.level == 1:
		equation_control.visible = false
	salmon.destination = Vector2(100, 300)


func _process(_delta):
	refresh_cursor()
	check_win()
	if state == States.PLAY and summons_left == 0 and banishes_left == 0:
		message_label.text = "[center]PRESS R TO RESTART[/center]"
	elif state == States.COMPLETE:
		message_label.text = "[center]LEVEL COMPLETE[/center]"


func refresh_cursor():
	if state == States.PLAY and summons_left > 0:
		var pos = get_global_mouse_position()
		cursor.global_position = pos
		var segment_and_index = get_segment_and_index(equation_control.to_local(pos))
		if segment_and_index != null:
			var segment = segment_and_index[0]
			var index = segment_and_index[1]
			if not get_tree().get_nodes_in_group("stick").any(
				func(x):
					return x.index == index and x.segment == segment
			):
				cursor.segment = segment
				cursor.index = index
				cursor.reload()
				cursor.visible = true
			else:
				cursor.visible = false
		else:
			cursor.visible = false
	else:
		cursor.visible = false


func refresh_summons_left_label():
	var result = ""
	if summons_left > 0:
		result += "SUMMONS LEFT:%s\n" % summons_left
	if banishes_left > 0:
		result += "BANISHES LEFT:%s\n" % banishes_left
	summons_left_label.text = result


func check_win():
	if state == States.PLAY:
		var current_state = get_current_state()
		var expression = Expression.new()
		var puzzle_fixed = current_state.replace("=", "==")
		var error = expression.parse(puzzle_fixed)
		if error == OK:
			var result = expression.execute()
			if not expression.has_execute_failed():
				if result:
					state = States.COMPLETE
					match Global.level:
						0:
							await show_dialogue("That is correct.")
							await show_dialogue("I just know it is.")
							await show_dialogue("Because I am [wave]Salmon of Knowledge[/wave].")
						1:
							await show_dialogue("This is the correct solution!")
						2:
							await show_dialogue("You got it right.")
						3:
							await show_dialogue("Great job!")
						4:
							await show_dialogue("Nice.")
						5:
							await show_dialogue("Exactly.")
						6:
							await show_dialogue("I have an idea!")
							await show_dialogue("I can resummon a banished stick!")
							await show_dialogue("Too late? My bad.")
						7:
							await show_dialogue("Correct.")
						8:
							await show_dialogue("I can see my breeding grounds from here.")
							await show_dialogue("It's time for me to die, I guess.")
							await show_dialogue("Thank you for playing!")
					salmon.destination = Vector2(700, 100)
					AudioBus.play("Win")
					await get_tree().create_timer(2).timeout
					camera.destination.x += 800


func _input(event):
	if event.is_action_pressed("reset_level"):
		reset_level()


func load_puzzle():
	puzzle = Global.puzzles[Global.level]
	summons_left = Global.summon_limit[Global.level]
	banishes_left = Global.banish_limit[Global.level]
	for index in len(puzzle):
		var symbol = puzzle[index]
		match symbol:
			"+":
				add_plus(index)
			"=":
				add_equals(index)
			"0":
				add_stick(index, "A")
				add_stick(index, "B")
				add_stick(index, "C")
				add_stick(index, "D")
				add_stick(index, "E")
				add_stick(index, "F")
			"1":
				add_stick(index, "B")
				add_stick(index, "C")
			"2":
				add_stick(index, "A")
				add_stick(index, "B")
				add_stick(index, "D")
				add_stick(index, "E")
				add_stick(index, "G")
			"3":
				add_stick(index, "A")
				add_stick(index, "B")
				add_stick(index, "C")
				add_stick(index, "D")
				add_stick(index, "G")
			"4":
				add_stick(index, "B")
				add_stick(index, "C")
				add_stick(index, "F")
				add_stick(index, "G")
			"5":
				add_stick(index, "A")
				add_stick(index, "C")
				add_stick(index, "D")
				add_stick(index, "F")
				add_stick(index, "G")
			"6":
				add_stick(index, "A")
				add_stick(index, "C")
				add_stick(index, "D")
				add_stick(index, "E")
				add_stick(index, "F")
				add_stick(index, "G")
			"7":
				add_stick(index, "A")
				add_stick(index, "B")
				add_stick(index, "C")
			"8":
				add_stick(index, "A")
				add_stick(index, "B")
				add_stick(index, "C")
				add_stick(index, "D")
				add_stick(index, "E")
				add_stick(index, "F")
				add_stick(index, "G")
			"9":
				add_stick(index, "A")
				add_stick(index, "B")
				add_stick(index, "C")
				add_stick(index, "D")
				add_stick(index, "F")
				add_stick(index, "G")


func get_current_state():
	var result = ""
	var stick_group = get_tree().get_nodes_in_group("stick")
	var filled_segments = {}
	for stick in stick_group:
		var index = stick.index
		var segment = stick.segment
		if filled_segments.has(index):
			filled_segments[index].append(segment)
		else:
			filled_segments[index] = [segment]
	var length = len(puzzle)
	for index in length:
		if puzzle[index] == "+":
			result += "+"
		elif puzzle[index] == "=":
			result += "="
		elif filled_segments.has(index):
			result += get_symbol_by_segments(filled_segments[index])
	return result


func get_symbol_by_segments(array):
	if array.has("A") and array.has("B") and array.has("C") and array.has("D") and array.has("E") and array.has("F") and not array.has("G"):
		return "0"
	elif not array.has("A") and array.has("B") and array.has("C") and not array.has("D") and not array.has("E") and not array.has("F") and not array.has("G"):
		return "1"
	elif not array.has("A") and not array.has("B") and not array.has("C") and not array.has("D") and array.has("E") and array.has("F") and not array.has("G"):
		return "1"
	if array.has("A") and array.has("B") and not array.has("C") and array.has("D") and array.has("E") and not array.has("F") and array.has("G"):
		return "2"
	if array.has("A") and array.has("B") and array.has("C") and array.has("D") and not array.has("E") and not array.has("F") and array.has("G"):
		return "3"
	if not array.has("A") and array.has("B") and array.has("C") and not array.has("D") and not array.has("E") and array.has("F") and array.has("G"):
		return "4"
	if array.has("A") and not array.has("B") and array.has("C") and array.has("D") and not array.has("E") and array.has("F") and array.has("G"):
		return "5"
	if not array.has("B") and array.has("C") and array.has("D") and array.has("E") and array.has("F") and array.has("G"):
		return "6"
	if array.has("A") and array.has("B") and array.has("C") and not array.has("D") and not array.has("E") and not array.has("F") and not array.has("G"):
		return "7"
	if array.has("A") and array.has("B") and array.has("C") and array.has("D") and array.has("E") and array.has("F") and array.has("G"):
		return "8"
	if array.has("A") and array.has("B") and array.has("C") and not array.has("E") and array.has("F") and array.has("G"):
		return "9"
	else:
		return "?"


func add_equals(index):
	var new_equals = EQUALS.instantiate()
	equation_control.add_child(new_equals)
	new_equals.index = index


func add_plus(index):
	var new_plus = PLUS.instantiate()
	equation_control.add_child(new_plus)
	new_plus.index = index


func add_stick(index, segment, is_summoned = false):
	var new_stick = STICK.instantiate()
	new_stick.index = index
	new_stick.segment = segment
	new_stick.is_summoned = is_summoned
	if is_summoned:
		camera.shake_amplitude += 1.0
	equation_control.add_child(new_stick)
	new_stick.add_to_group("stick")


func _on_equation_control_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if state == States.PLAY:
			var segment_and_index = get_segment_and_index(event.position)
			if segment_and_index != null:
				var segment = segment_and_index[0]
				var index = segment_and_index[1]
				var sticks_here: Array = get_tree().get_nodes_in_group("stick").filter(
					func(x):
						return x.index == index and x.segment == segment
				)
				if sticks_here.is_empty():
					if summons_left > 0:
						add_stick(index, segment, true)
						AudioBus.play("Summon")
						summons_left -= 1
				elif banishes_left > 0:
					for stick in sticks_here:
						AudioBus.play("Banish")
						stick.banish()
					banishes_left -= 1
					summons_left += 1


func get_segment_and_index(pos):
	var index = floori(pos.x / 48)
	if index < 0 or index >= len(puzzle):
		return null
	if puzzle[index] in ["+", "="]:
		return null
	var segment = get_segment(Vector2(int(pos.x) % 48, pos.y))
	if not segment in ["A", "B", "C", "D", "E", "F", "G"]:
		return null
	return [segment, index]


func get_segment(pos):
	if Rect2(12, 0, 22, 12).has_point(pos):
		return "A"
	if Rect2(32, 12, 12, 22).has_point(pos):
		return "B"
	if Rect2(32, 42, 12, 22).has_point(pos):
		return "C"
	if Rect2(12, 64, 22, 12).has_point(pos):
		return "D"
	if Rect2(0, 42, 12, 22).has_point(pos):
		return "E"
	if Rect2(0, 12, 12, 22).has_point(pos):
		return "F"
	if Rect2(12, 32, 22, 12).has_point(pos):
		return "G"
	return ""


func reset_level():
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_salmon_reached_destination():
	if state == States.COMPLETE:
		if Global.level + 1 == Global.level_count:
			get_tree().change_scene_to_file("res://scenes/credits.tscn")
		else:
			Global.level += 1
			get_tree().change_scene_to_file("res://scenes/level.tscn")
	elif state == States.WAIT:
		equation_control.visible = true
		match Global.level:
			0:
				if UserSettings.first_launch:
					await show_dialogue_initial("I am Salmon of Knowledge.")
					await show_dialogue_initial("I know of many things.")
					await show_dialogue_initial("But I can't into math.")
					await show_dialogue_initial("Or grammar.")
					await show_dialogue_initial("Because I am a fish!")
					await show_dialogue_initial("I'm on my salmon run now.")
					await show_dialogue_initial("I thought I was prepared.")
					await show_dialogue("[shake]But not for this![/shake]")
					await show_dialogue("Is this a [wave]sum[/wave]?")
					await show_dialogue("Salmon do not swim in [wave]schools[/wave].")
					await show_dialogue("But I am Salmon of Knowledge.")
				await show_dialogue("I can [wave]summon[/wave] things from another dimension.")
				await show_dialogue("There are sticks there.")
				if UserSettings.first_launch:
					await show_dialogue("Or, to be precise...")
					await show_dialogue("Just one single stick.")
				await show_dialogue("Click where you want me to summon it.")
				UserSettings.first_launch = false
			1:
				await show_dialogue("I can't believe it.")
				await show_dialogue("Math again...")
			2:
				await show_dialogue("Another dimension here is quite ample.")
				await show_dialogue("There are two sticks in it.")
			3:
				await show_dialogue("Should I mention that it's [wave]summer[/wave] now?")
			4:
				await show_dialogue("That's a lot of digits.")
				await show_dialogue("[wave]As for me, I don't have any.[/wave]")
				await show_dialogue("Because I am a fish!")
			5:
				await show_dialogue("The alternate dimension is completely empty now.")
				await show_dialogue("We used up all the sticks there.")
				await show_dialogue("Thankfully, I have the power to banish sticks from this dimension.")
				await show_dialogue("But banishing is so exhausting.")
				await show_dialogue("I won't do it more than once.")
			6:
				await show_dialogue("[wave]Make it count.[/wave]")
			7:
				await show_dialogue("Look, the another dimension is full of shiny things!")
				await show_dialogue("No, it's just sticks again.")
				await show_dialogue("[wave]Stick*[/wave]")
			8:
				await show_dialogue("This is a complex equation.")
				await show_dialogue("But we are close to destination.")
		state = States.PLAY


func show_dialogue(new_text):
	var dialogue_panel: Node = preload("res://scenes/dialogue_panel.tscn").instantiate()
	dialogue_container.add_child(dialogue_panel)
	dialogue_panel.set_text(new_text)
	await dialogue_panel.dialogue_closed


func show_dialogue_initial(new_text):
	var dialogue_panel: Node = preload("res://scenes/dialogue_panel.tscn").instantiate()
	canvas_layer.add_child(dialogue_panel)
	dialogue_panel.position = equation_control.position
	dialogue_panel.set_text(new_text)
	await dialogue_panel.dialogue_closed


func _on_settings_button_pressed():
	AudioBus.play("Click")
	var settings: Window = preload("res://scenes/settings.tscn").instantiate()
	add_child(settings)
	settings.popup_centered()


func _on_restart_button_pressed():
	AudioBus.play("Click")
	reset_level()


func _on_quit_button_pressed():
	AudioBus.play("Click")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
