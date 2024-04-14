extends Node2D


const FRAMES_HORIZONTAL = preload("res://data/stick_horizontal_frames.tres")
const TEXTURE_HORIZONTAL_UNDERWATER = preload("res://graphics/equation/stick_horizontal_underwater.png")
const FRAMES_VERTICAL = preload("res://data/stick_vertical_frames.tres")
const TEXTURE_VERTICAL_UNDERWATER = preload("res://graphics/equation/stick_vertical_underwater.png")

#   A
# F   B
#   G
# E   C
#   D

var index
var segment
var is_summoned = false


@onready var sprite_top: AnimatedSprite2D = %SpriteTop as AnimatedSprite2D
@onready var sprite_underwater = %SpriteUnderwater


func _ready():
	reload()


func reload():
	match segment:
		"A":
			sprite_top.sprite_frames = FRAMES_HORIZONTAL
			if is_summoned:
				sprite_top.play("summon")
				await sprite_top.animation_finished
			sprite_top.play("default")
			sprite_underwater.texture = TEXTURE_HORIZONTAL_UNDERWATER
		"B":
			sprite_top.sprite_frames = FRAMES_VERTICAL
			if is_summoned:
				sprite_top.play("summon")
				await sprite_top.animation_finished
			sprite_top.play("default")
			sprite_underwater.texture = TEXTURE_VERTICAL_UNDERWATER
		"C":
			sprite_top.sprite_frames = FRAMES_VERTICAL
			if is_summoned:
				sprite_top.play("summon")
				await sprite_top.animation_finished
			sprite_top.play("default")
			sprite_underwater.texture = TEXTURE_VERTICAL_UNDERWATER
		"D":
			sprite_top.sprite_frames = FRAMES_HORIZONTAL
			if is_summoned:
				sprite_top.play("summon")
				await sprite_top.animation_finished
			sprite_top.play("default")
			sprite_underwater.texture = TEXTURE_HORIZONTAL_UNDERWATER
		"E":
			sprite_top.sprite_frames = FRAMES_VERTICAL
			if is_summoned:
				sprite_top.play("summon")
				await sprite_top.animation_finished
			sprite_top.play("default")
			sprite_underwater.texture = TEXTURE_VERTICAL_UNDERWATER
		"F":
			sprite_top.sprite_frames = FRAMES_VERTICAL
			if is_summoned:
				sprite_top.play("summon")
				await sprite_top.animation_finished
			sprite_top.play("default")
			sprite_underwater.texture = TEXTURE_VERTICAL_UNDERWATER
		"G":
			sprite_top.sprite_frames = FRAMES_HORIZONTAL
			if is_summoned:
				sprite_top.play("summon")
				await sprite_top.animation_finished
			sprite_top.play("default")
			sprite_underwater.texture = TEXTURE_HORIZONTAL_UNDERWATER


func banish():
	sprite_top.play("banish")
	await sprite_top.animation_finished
	queue_free()


func _process(_delta):
	if index != null and segment != null:
		var offset = Vector2(8 + index * 48, 8) + Vector2(0, sin(Time.get_ticks_msec() * 0.001))
		match segment:
			"A":
				position = offset + Vector2(16, 0)
			"B":
				position = offset + Vector2(32, 16)	
			"C":
				position = offset + Vector2(32, 48)
			"D":
				position = offset + Vector2(16, 64)
			"E":
				position = offset + Vector2(0, 48)
			"F":
				position = offset + Vector2(0, 16)
			"G":
				position = offset + Vector2(16, 32)
