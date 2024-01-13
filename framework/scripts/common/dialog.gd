#*****************************************************************************
# @file    dialog.gd
# @author  MakerYang
#*****************************************************************************
extends Control

func _ready():
	$Message.modulate = Color(1, 1, 1, 0)
	$Message.visible = false

func show_message(content: String, duration: int):
	$Message/TextureRect/Label.text = content
	$Message.modulate = Color(1, 1, 1, 1)
	$Message.visible = true
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	if duration == 0:
		duration = 2
	tween.tween_property($Message, "modulate:a", 0, 0.5).set_delay(duration)
